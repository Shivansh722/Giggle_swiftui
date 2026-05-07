import Foundation

enum CreditTransactionType: String, Codable {
    case registration
    case flnCompletion = "fln_completion"
    case application
}

struct CreditConstants {
    static let minBalance = 0
    static let maxBalance = 200
    static let registrationBonus = 20
    static let flnCompletionBonus = 50
    static let applicationCost = 5
    static let lowCreditThreshold = 10
    static let cacheTTLSeconds: TimeInterval = 120
}

struct CreditTransaction: Identifiable, Codable, Equatable {
    let id: String
    let workerId: String
    let type: CreditTransactionType
    let amount: Int
    let balanceAfter: Int
    let referenceId: String
    let referenceType: String
    let createdAt: String

    var isCredit: Bool { amount >= 0 }
}

struct CreditWalletSummary: Codable, Equatable {
    var balance: Int
    var totalEarned: Int
    var totalSpent: Int
    var transactions: [CreditTransaction]
    var updatedAt: Date

    static let empty = CreditWalletSummary(
        balance: 0,
        totalEarned: 0,
        totalSpent: 0,
        transactions: [],
        updatedAt: .distantPast
    )
}

enum CreditError: Error, LocalizedError, Equatable {
    case insufficientCredits(required: Int, current: Int)
    case maxBalanceExceeded
    case duplicateReward
    case invalidUserId

    var errorDescription: String? {
        switch self {
        case let .insufficientCredits(required, current):
            return "You need \(required) credits to apply. You have \(current) credits. Complete the FLN assessment to earn more credits."
        case .maxBalanceExceeded:
            return "Maximum balance reached."
        case .duplicateReward:
            return "Credits already awarded for this assessment."
        case .invalidUserId:
            return "Unable to identify your account."
        }
    }
}
