import Appwrite
import Combine
import Foundation

@MainActor
final class CreditCacheStore: ObservableObject {
    static let shared = CreditCacheStore()
    @Published var summary: CreditWalletSummary = .empty
    private let cacheKey = "credit_wallet_cache"

    func loadFromCache() {
        guard let raw = UserDefaults.standard.data(forKey: cacheKey),
              let decoded = try? JSONDecoder().decode(CreditWalletSummary.self, from: raw)
        else { return }
        summary = decoded
    }

    func saveToCache(_ value: CreditWalletSummary) {
        summary = value
        if let encoded = try? JSONEncoder().encode(value) {
            UserDefaults.standard.set(encoded, forKey: cacheKey)
        }
    }

    var isStale: Bool {
        Date().timeIntervalSince(summary.updatedAt) > CreditConstants.cacheTTLSeconds
    }
}

final class CreditService {
    let database: Databases
    let databaseID: String = "67da78cd00052312da62"
    let userCollection: String = "67da79a900157497cced"

    init(appService: AppService) {
        self.database = Databases(appService.client)
    }

    func fetchSummary(forceRefresh: Bool = false) async throws -> CreditWalletSummary {
        await CreditCacheStore.shared.loadFromCache()
        if !forceRefresh && !CreditCacheStore.shared.isStale {
            return CreditCacheStore.shared.summary
        }
        let summary = try await fetchSummaryFromRemote()
        await CreditCacheStore.shared.saveToCache(summary)
        return summary
    }

    func fetchSummaryFromRemote() async throws -> CreditWalletSummary {
        guard let userId = UserDefaults.standard.string(forKey: "userID") else {
            throw CreditError.invalidUserId
        }
        let userDoc = try await database.getDocument(
            databaseId: databaseID,
            collectionId: userCollection,
            documentId: userId
        )
        return parseSummary(userDoc.data, workerId: userId)
    }

    func previewApplicationCost(jobId: String) async throws -> Int {
        guard let userId = UserDefaults.standard.string(forKey: "userID") else {
            throw CreditError.invalidUserId
        }
        let userDoc = try await database.getDocument(databaseId: databaseID, collectionId: userCollection, documentId: userId)
        let appliedJobs = userDoc.data["applied_job_id"]?.value as? [String] ?? []
        if appliedJobs.contains(jobId) { return 0 }
        return appliedJobs.isEmpty ? 0 : CreditConstants.applicationCost
    }

    func applicationChargeUpdatePayload(userData: [String: Any], jobId: String, userId: String) throws -> [String: Any] {
        let appliedJobs = userData["applied_job_id"]?.value as? [String] ?? []
        let isFirstApplication = appliedJobs.isEmpty
        if isFirstApplication { return [:] }

        var summary = parseSummary(userData, workerId: userId)
        if summary.transactions.contains(where: { $0.type == .application && $0.referenceId == jobId }) {
            return [:]
        }

        if summary.balance < CreditConstants.applicationCost {
            throw CreditError.insufficientCredits(required: CreditConstants.applicationCost, current: summary.balance)
        }

        summary.balance -= CreditConstants.applicationCost
        summary.totalSpent += CreditConstants.applicationCost
        let transaction = CreditTransaction(
            id: UUID().uuidString,
            workerId: userId,
            type: .application,
            amount: -CreditConstants.applicationCost,
            balanceAfter: summary.balance,
            referenceId: jobId,
            referenceType: "job",
            createdAt: ISO8601DateFormatter().string(from: Date())
        )
        summary.transactions.insert(transaction, at: 0)
        let updated: [String: Any] = [
            "credit_balance": summary.balance,
            "total_credits_earned": summary.totalEarned,
            "total_credits_spent": summary.totalSpent,
            "credit_transactions": encodeTransactions(summary.transactions),
            "credit_updated_at": ISO8601DateFormatter().string(from: Date())
        ]
        Task { await CreditCacheStore.shared.saveToCache(summary) }
        print("analytics: credit_spent amount=\(CreditConstants.applicationCost) reference=\(jobId)")
        return updated
    }

    func rewardFLNCompletion(flnId: String) async throws -> CreditWalletSummary {
        guard let userId = UserDefaults.standard.string(forKey: "userID") else {
            throw CreditError.invalidUserId
        }
        let userDoc = try await database.getDocument(databaseId: databaseID, collectionId: userCollection, documentId: userId)
        var summary = parseSummary(userDoc.data, workerId: userId)

        let rewardedIds = userDoc.data["fln_rewarded_ids"]?.value as? [String] ?? []
        if rewardedIds.contains(flnId) {
            throw CreditError.duplicateReward
        }

        let nextBalance = min(summary.balance + CreditConstants.flnCompletionBonus, CreditConstants.maxBalance)
        if nextBalance == summary.balance {
            throw CreditError.maxBalanceExceeded
        }
        let awardAmount = nextBalance - summary.balance
        summary.balance = nextBalance
        summary.totalEarned += awardAmount
        let transaction = CreditTransaction(
            id: UUID().uuidString,
            workerId: userId,
            type: .flnCompletion,
            amount: awardAmount,
            balanceAfter: summary.balance,
            referenceId: flnId,
            referenceType: "assessment",
            createdAt: ISO8601DateFormatter().string(from: Date())
        )
        summary.transactions.insert(transaction, at: 0)
        let updatePayload: [String: Any] = [
            "credit_balance": summary.balance,
            "total_credits_earned": summary.totalEarned,
            "total_credits_spent": summary.totalSpent,
            "credit_transactions": encodeTransactions(summary.transactions),
            "credit_updated_at": ISO8601DateFormatter().string(from: Date()),
            "fln_rewarded_ids": rewardedIds + [flnId]
        ]

        _ = try await database.updateDocument(
            databaseId: databaseID,
            collectionId: userCollection,
            documentId: userId,
            data: updatePayload
        )
        await CreditCacheStore.shared.saveToCache(summary)
        print("analytics: credit_earned amount=\(awardAmount) reference=\(flnId)")
        return summary
    }

    func bootstrapRegistrationCreditsPayload(userId: String) -> [String: Any] {
        let now = ISO8601DateFormatter().string(from: Date())
        let registrationTx = CreditTransaction(
            id: UUID().uuidString,
            workerId: userId,
            type: .registration,
            amount: CreditConstants.registrationBonus,
            balanceAfter: CreditConstants.registrationBonus,
            referenceId: userId,
            referenceType: "registration",
            createdAt: now
        )
        return [
            "credit_balance": CreditConstants.registrationBonus,
            "total_credits_earned": CreditConstants.registrationBonus,
            "total_credits_spent": 0,
            "credit_transactions": encodeTransactions([registrationTx]),
            "credit_updated_at": now,
            "fln_rewarded_ids": []
        ]
    }

    private func parseSummary(_ data: [String: Any], workerId: String) -> CreditWalletSummary {
        let balance = max(CreditConstants.minBalance, min(CreditConstants.maxBalance, data["credit_balance"]?.value as? Int ?? 0))
        let earned = data["total_credits_earned"]?.value as? Int ?? 0
        let spent = data["total_credits_spent"]?.value as? Int ?? 0
        let transactions = decodeTransactions(data["credit_transactions"]?.value as? [[String: Any]] ?? [], workerId: workerId)
        let updatedAtRaw = data["credit_updated_at"]?.value as? String ?? ""
        let updatedAt = ISO8601DateFormatter().date(from: updatedAtRaw) ?? Date()
        return CreditWalletSummary(balance: balance, totalEarned: earned, totalSpent: spent, transactions: transactions, updatedAt: updatedAt)
    }

    private func decodeTransactions(_ list: [[String: Any]], workerId: String) -> [CreditTransaction] {
        list.compactMap { item in
            guard let typeRaw = item["type"] as? String,
                  let type = CreditTransactionType(rawValue: typeRaw)
            else { return nil }
            return CreditTransaction(
                id: item["id"] as? String ?? UUID().uuidString,
                workerId: item["workerId"] as? String ?? workerId,
                type: type,
                amount: item["amount"] as? Int ?? 0,
                balanceAfter: item["balanceAfter"] as? Int ?? 0,
                referenceId: item["referenceId"] as? String ?? "",
                referenceType: item["referenceType"] as? String ?? "",
                createdAt: item["createdAt"] as? String ?? ISO8601DateFormatter().string(from: Date())
            )
        }
    }

    private func encodeTransactions(_ list: [CreditTransaction]) -> [[String: Any]] {
        list.map {
            [
                "id": $0.id,
                "workerId": $0.workerId,
                "type": $0.type.rawValue,
                "amount": $0.amount,
                "balanceAfter": $0.balanceAfter,
                "referenceId": $0.referenceId,
                "referenceType": $0.referenceType,
                "createdAt": $0.createdAt
            ]
        }
    }
}
