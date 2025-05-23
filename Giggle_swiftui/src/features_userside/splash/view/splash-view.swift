import SwiftUI

// Custom smile-shaped path
struct SmileShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Create a smile-shaped curve
        let start = CGPoint(x: rect.minX, y: rect.midY)
        let end = CGPoint(x: rect.maxX, y: rect.midY)
        let control1 = CGPoint(x: rect.width * 0.25, y: rect.midY + rect.height * 0.5)
        let control2 = CGPoint(x: rect.width * 0.75, y: rect.midY + rect.height * 0.5)
        
        path.move(to: start)
        path.addCurve(to: end, control1: control1, control2: control2)
        
        return path
    }
}

struct SplashScreen: View {
    @State private var isActive = false
    @State private var destinationView: AnyView?
    @State private var smileYPosition: CGFloat = 1000 // Start offscreen
    @State private var smileWidth: CGFloat = 200
    @State private var animationStarted = false
    @State private var logoBottomPosition: CGFloat = 0
    @State private var textOpacity: Double = 0 // New state for text opacity
    
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
                // Background
                Theme.backgroundColor
                    .edgesIgnoringSafeArea(.all)
                
                // Content
                VStack {
                    Spacer()
                    
                    Image("logo2")
                        .resizable()
                        .padding(.trailing, 10)
                        .scaledToFit()
                        .frame(width: 260, height: 150)
                        .background(GeometryReader { geo in
                            Color.clear
                                .onAppear {
                                    // Store the logo's bottom position
                                    logoBottomPosition = geo.frame(in: .global).maxY
                                    print("Logo bottom position: \(logoBottomPosition)")
                                }
                        })
                    
                    Spacer()
                    
                    Text("Make your Story!!!")
                        .font(.custom("Borel-Regular", size: 20))
                        .padding(.bottom, 10)
                        .foregroundColor(Theme.onPrimaryColor)
                        .opacity(textOpacity) // Apply opacity
                        .onAppear {
                            // Animate the text fade in after the smile animation
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                withAnimation(.easeIn(duration: 1.0)) {
                                    textOpacity = 1.0
                                }
                            }
                        }
                }
                
                // Smile line - positioned just below the logo
                SmileShape()
                    .stroke(Theme.onPrimaryColor, lineWidth: 4)
                    .frame(width: smileWidth, height: 60) // Height controls the curve depth
                    .position(x: UIScreen.main.bounds.width/2, y: smileYPosition)
                    .onAppear {
                        guard !animationStarted else { return }
                        animationStarted = true

                        // Initial values
                        smileYPosition = UIScreen.main.bounds.height + 50 // Start below screen
                        smileWidth = UIScreen.main.bounds.width - 40 // Full width with padding

                        // Animate up to just below the logo with iPad-specific offset
                        let isIpad = UIDevice.current.userInterfaceIdiom == .pad
                        let finalSmileY = logoBottomPosition + (isIpad ? 600 : 420)

                        withAnimation(.easeOut(duration: 1.0)) {
                            smileYPosition = finalSmileY
                        }

                        // Then resize
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                smileWidth = 120 // Final width
                            }
                        }

                        // Navigate after delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            self.isActive = true
                        }
                    }

                
                // Navigation Link
                NavigationLink(
                    destination: destinationView,
                    isActive: $isActive
                ) {
                    EmptyView()
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                destinationView = determineDestination()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
