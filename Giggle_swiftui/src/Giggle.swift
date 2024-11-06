import SwiftUI

@main
struct Giggle_swiftuiApp: App {
    @StateObject private var viewModel = RegisterViewModel(service:AppService()) // Create the ViewModel instance here

    var body: some Scene {
        WindowGroup {
            SplashScreen()
                .environmentObject(viewModel) // Inject ViewModel as an environment object
        }
    }
}
