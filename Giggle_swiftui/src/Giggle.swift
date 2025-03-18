import SwiftUI

@main
struct Giggle_swiftuiApp: App {
    @StateObject private var viewModel = RegisterViewModel(service: AppService()) // For RegisterViewModel
    @StateObject private var profileViewModel = ProfileViewModel() // For ProfileViewModel

    var body: some Scene {
        WindowGroup {
            NavigationStack { // Add NavigationStack for navigation support
                HomeClientView()
                    .environmentObject(viewModel) // Inject RegisterViewModel
                    .environmentObject(profileViewModel) // Inject ProfileViewModel
            }
        }
    }
}
