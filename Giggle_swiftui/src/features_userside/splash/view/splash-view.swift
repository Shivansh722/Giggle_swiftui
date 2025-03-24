
import SwiftUI
struct SplashScreen: View {
    @State private var isActive = false // Controls navigation
    @State private var destinationView: AnyView?
        
        // Define possible destinations
        private func determineDestination() -> AnyView {
            let status = UserDefaults.standard.string(forKey: "status")
            print(status ?? "nostatus")
            
            switch status {
            case "register", "login":
                return AnyView(ChooseView())
            case "completed user":
                return AnyView(HomeView())
            case "completed client":
                return AnyView(HomeClientView())
            default:
                return AnyView(OnboardingView())
            }
        }
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.backgroundColor
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 280, height: 150)
                    
                    Spacer()
                    
                    Image("tabline")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 180)
                }
                
                // Navigation Link
                NavigationLink(
                    destination: destinationView,
                                    isActive: $isActive
                                ) {
                                    EmptyView()
                                }
            }
            .navigationBarHidden(true) // Hide the navigation bar in SplashScreen
            .onAppear {
                destinationView = determineDestination()
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    self.isActive = true
                }
            }
        }
       
    }
}
