import SwiftUI

@main
struct Giggle_swiftuiApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var viewModel = RegisterViewModel(service:AppService()) // Create the ViewModel instance here
    @Environment(\.scenePhase) private var scenePhase
    private let creditService = CreditService(appService: AppService())

    var body: some Scene {
        WindowGroup {

           

            SplashScreen()

                .environmentObject(viewModel) // Inject ViewModel as an environment object
                .onChange(of: scenePhase) { _, newPhase in
                    if newPhase == .active {
                        Task {
                            _ = try? await creditService.fetchSummary(forceRefresh: true)
                        }
                    }
                }
        }
    }
}
//@EnvironmentObject is used to share data across the entire view hierarchy by injecting an object at the root view
