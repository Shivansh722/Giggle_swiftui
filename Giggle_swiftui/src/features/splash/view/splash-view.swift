
import SwiftUI
struct SplashScreen: View {
    @State private var isActive = false // Controls navigation
    
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
                NavigationLink(destination: RegisterView(), isActive: $isActive) {
                    EmptyView()
                }
            }
            .navigationBarHidden(true) // Hide the navigation bar in SplashScreen
            .onAppear {
            
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    self.isActive = true
                }
            }
        }
       
    }
}
