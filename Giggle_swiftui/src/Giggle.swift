import SwiftUI

@main
struct Giggle_swiftuiApp: App {
    @StateObject private var viewModel = RegisterViewModel(service:AppService()) // Create the ViewModel instance here

    var body: some Scene {
        WindowGroup {

           

            FluencyView()

                .environmentObject(viewModel) // Inject ViewModel as an environment object
        }
    }
}
//@EnvironmentObject is used to share data across the entire view hierarchy by injecting an object at the root view
