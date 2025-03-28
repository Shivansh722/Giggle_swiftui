import SwiftUI

@main
struct Giggle_swiftuiApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var viewModel = RegisterViewModel(service:AppService()) // Create the ViewModel instance here

    var body: some Scene {
        WindowGroup {

           

            SplashScreen()

                .environmentObject(viewModel) // Inject ViewModel as an environment object
        }
    }
}
//@EnvironmentObject is used to share data across the entire view hierarchy by injecting an object at the root view
