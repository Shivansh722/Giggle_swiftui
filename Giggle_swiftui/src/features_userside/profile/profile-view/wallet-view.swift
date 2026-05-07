import SwiftUI
import UIKit

struct WalletView: View {
    @State private var summary: CreditWalletSummary = .empty
    @State private var isLoading = true
    @State private var errorMessage: String?
    private let service = CreditService(appService: AppService())

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Wallet")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.onPrimaryColor)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Available Credits")
                        .foregroundColor(.gray)
                    Text("⚡ \(summary.balance)")
                        .font(.system(size: 36, weight: .bold, design: .monospaced))
                        .foregroundColor(Theme.secondaryColor)
                    if summary.balance < CreditConstants.lowCreditThreshold {
                        Text("Low balance. Complete FLN to earn +50 credits.")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(hex: "343434").opacity(0.6))
                .cornerRadius(14)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Recent Transactions")
                        .font(.headline)
                        .foregroundColor(Theme.onPrimaryColor)
                    ForEach(Array(summary.transactions.prefix(10))) { tx in
                        HStack {
                            Text(icon(for: tx.type))
                            Text(label(for: tx.type))
                                .foregroundColor(Theme.onPrimaryColor)
                            Spacer()
                            Text(tx.amount >= 0 ? "+\(tx.amount)" : "\(tx.amount)")
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(tx.amount >= 0 ? .green : .red)
                        }
                        HStack {
                            Text("Balance: \(tx.balanceAfter)")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Spacer()
                            Text(formatDate(tx.createdAt))
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        if !tx.referenceId.isEmpty {
                            Text("Ref: \(tx.referenceType) • \(tx.referenceId)")
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                        Divider().background(Color.gray.opacity(0.2))
                    }
                }
                .padding()
                .background(Color(hex: "343434").opacity(0.6))
                .cornerRadius(14)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Earn More Credits")
                        .font(.headline)
                        .foregroundColor(Theme.onPrimaryColor)
                    Text("Complete FLN Assessment (+50)")
                        .foregroundColor(Theme.onPrimaryColor)
                    NavigationLink(destination: FluencyIntroView()) {
                        Text("Go to Assessment")
                            .foregroundColor(Theme.primaryColor)
                    }
                }
                .padding()
                .background(Color(hex: "343434").opacity(0.6))
                .cornerRadius(14)
            }
            .padding()
        }
        .background(Theme.backgroundColor.edgesIgnoringSafeArea(.all))
        .onAppear { Task { await refresh(force: true) } }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            Task { await refresh(force: true) }
        }
        .overlay {
            if isLoading { ProgressView().tint(Theme.primaryColor) }
        }
        .alert("Credits", isPresented: Binding(
            get: { errorMessage != nil },
            set: { if !$0 { errorMessage = nil } }
        ), actions: {
            Button("OK") { errorMessage = nil }
        }, message: {
            Text(errorMessage ?? "")
        })
    }

    private func refresh(force: Bool) async {
        isLoading = true
        do {
            let previous = summary.balance
            summary = try await service.fetchSummary(forceRefresh: force)
            if previous != summary.balance {
                UIAccessibility.post(
                    notification: .announcement,
                    argument: "Credit balance updated. Available credits \(summary.balance)"
                )
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    private func icon(for type: CreditTransactionType) -> String {
        switch type {
        case .registration: return "🎁"
        case .flnCompletion: return "🎉"
        case .application: return "💼"
        }
    }

    private func label(for type: CreditTransactionType) -> String {
        switch type {
        case .registration: return "Registration Bonus"
        case .flnCompletion: return "FLN Completion"
        case .application: return "Job Application"
        }
    }

    private func formatDate(_ raw: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: raw) {
            let output = DateFormatter()
            output.dateStyle = .medium
            output.timeStyle = .short
            return output.string(from: date)
        }
        return raw
    }
}

#Preview {
    WalletView()
}
