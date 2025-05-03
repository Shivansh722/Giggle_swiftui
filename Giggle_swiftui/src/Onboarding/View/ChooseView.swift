import SwiftUI
import Lottie
import CoreGraphics

struct ChooseView: View {
    @State private var isSelected: Bool = false
    @State private var isGigProviderSelected: Bool = false
    @State private var isGigSeekerSelected: Bool = false
    @State private var selectedRole: ChooseViewModel.Role?
    @State private var planePosition: CGFloat = 0.0
    @State private var trailPoints: [CGPoint] = []
    @State private var previousProgress: CGFloat = 0.0
    @State private var previousPoint: CGPoint = .zero
    @State private var progress: CGFloat = 0.0
    @State private var chooseAnimationProgress: CGFloat = 0.0
    @State private var animationFinished = false
    @State private var chooseAnimationFinished = false
    @State private var timer: Timer? = nil
    @State private var shouldNavigate = false
    
    private let providerAnimationRange: ClosedRange<CGFloat> = 0.5...0.8
    private let seekerAnimationRange: ClosedRange<CGFloat> = 0.0...0.3
    
    var body: some View {
        ZStack {
            Theme.backgroundColor
                .ignoresSafeArea()

            VStack {
                GeometryReader { geo in
                    let width = geo.size.width
                    let height = geo.size.height - 100
                    let midY = height * 0.5

                    let dynamicPath = Path { path in
                        path.move(to: CGPoint(x: 0, y: midY)) // Start at the left edge

                        // Small wave
                        path.addQuadCurve(to: CGPoint(x: width * 0.18, y: midY), control: CGPoint(x: width * 0.1, y: midY - 40))

                        // Loop at the start
//                        path.addArc(center: CGPoint(x: width * 0.25, y: midY ), radius: width * 0.06, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)

                        // Continue wavy path
                        path.addQuadCurve(to: CGPoint(x: width * 0.40, y: midY), control: CGPoint(x: width * 0.33, y: midY + 30))
                        path.addQuadCurve(to: CGPoint(x: width * 0.55, y: midY - 60), control: CGPoint(x: width * 0.48, y: midY - 60))

                        // Final wave and arrowhead approach
                        path.addQuadCurve(to: CGPoint(x: width * 0.65, y: midY - 50), control: CGPoint(x: width * 0.60, y: midY - 55))


                    }

                    let trimmedPath = dynamicPath.trimmedPath(from: 0, to: max(progress, 0.01)) // Avoid 0
                    let planePoint = trimmedPath.currentPoint ?? CGPoint(x: width * 0.01, y: midY)
                    

                    ZStack {
                        if !trailPoints.isEmpty {
                            Path { trail in
                                trail.move(to: trailPoints.first!)
                                for point in trailPoints {
                                    trail.addLine(to: point)
                                }
                            }
                            .stroke(Color.white, style: StrokeStyle(lineWidth: 4, lineCap: .round, dash: [10, 10]))
                        }

                        let dx = planePoint.x - previousPoint.x
                        let dy = planePoint.y - previousPoint.y


                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.white)
                            .rotationEffect(
                                // Calculate angle using ternary operator directly here
                                Angle(radians: (planePoint.x != previousPoint.x || planePoint.y != previousPoint.y) ? atan2(planePoint.y - previousPoint.y, planePoint.x - previousPoint.x) : 0 )
                                // Add adjustment if paperplane asset points up instead of right
                                + Angle(degrees: 60)
                            )
                            .position(planePoint)
                    }
                    .onChange(of: progress) { newProgress in
                        if newProgress < previousProgress {
                            trailPoints = []
                        }
                        
                        // Only add points if we have a valid previous point
                        if previousPoint != .zero || trailPoints.isEmpty {
                            trailPoints.append(planePoint)
                        }
                        
                        if trailPoints.count > 300 {
                            trailPoints.removeFirst()
                        }
                        previousPoint = planePoint
                        previousProgress = newProgress
                    }
                }
                .frame(height: 200)
                .onAppear {
                    // Reset everything when view appears
                    trailPoints = []
                    previousPoint = .zero
                    previousProgress = 0.0
                    progress = 0.0
                    animationFinished = false
                    
                    // Delay starting the animation slightly to ensure clean state
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        let duration: TimeInterval = 1.0
                        let fps: Double = 60
                        var timeElapsed: TimeInterval = 0

                        timer?.invalidate() // Cancel any existing timer
                        
                        timer = Timer.scheduledTimer(withTimeInterval: 1.0 / fps, repeats: true) { timer in
                            timeElapsed += 1.0 / fps
                            let newProgress = min(CGFloat(timeElapsed / duration), 1.0)

                            progress = newProgress

                            if newProgress >= 1.0 {
                                timer.invalidate()
                                self.timer = nil
                                animationFinished = true
                            }
                        }
                    }
                }
                .onDisappear {
                    // Cancel timer if view disappears
                    timer?.invalidate()
                    timer = nil
                }
                VStack {
                    Text("Are you looking for gigs or providing one?")
                        .font(Font.custom("SF Pro", size: 18).weight(.bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Theme.onPrimaryColor)
                        .padding(.bottom, 34)
                        .lineLimit(2)

                    HStack {
                        Button(action: {
                            selectedRole = .client
                            isGigProviderSelected = true
                            isGigSeekerSelected = false
                            isSelected = true
                            
                            playAnimation(range: providerAnimationRange)
                        }) {
                            Text("Gig Provider")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .background(isGigProviderSelected ? Color.red : Color(red: 0.64, green: 0.64, blue: 0.64))
                                .cornerRadius(16)
                        }
                        .disabled(chooseAnimationProgress > 0 && !chooseAnimationFinished)
                        
                        Button(action: {
                            selectedRole = .user
                            isGigSeekerSelected = true
                            isGigProviderSelected = false
                            isSelected = true
                            
                            playAnimation(range: seekerAnimationRange)
                        }) {
                            Text("Gig Seeker")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .background(isGigSeekerSelected ? Color.red : Color(red: 0.64, green: 0.64, blue: 0.64))
                                .cornerRadius(16)
                        }
                        .disabled(chooseAnimationProgress > 0 && !chooseAnimationFinished)
                    }
                    .padding(.horizontal, 26)
                    LottieView(name: "choose_view_animation", progress: $chooseAnimationProgress)
                                        .frame(height: 150)

                    if selectedRole == .user {
                        NavigationLink(
                            destination: ClientOnboardingView(selectedRole: selectedRole),
                            isActive: $shouldNavigate
                        ) {
                            EmptyView()
                        }
                    } else {
                        NavigationLink(
                            destination: ClientOnboardingView(),
                            isActive: $shouldNavigate
                        ) {
                            EmptyView()
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
    private func playAnimation(range: ClosedRange<CGFloat>) {
            // Reset animation state
            chooseAnimationFinished = false
            
            // Start from the beginning of the range
            chooseAnimationProgress = range.lowerBound
            
            // Create a timer to animate through the range
            let duration: TimeInterval = 1.0
            let fps: Double = 60
            let totalFrames = Int(duration * fps)
            let progressIncrement = (range.upperBound - range.lowerBound) / CGFloat(totalFrames)
            
            // Use a timer to increment the progress
            var currentFrame = 0
            Timer.scheduledTimer(withTimeInterval: 1.0 / fps, repeats: true) { timer in
                currentFrame += 1
                
                // Update animation progress
                chooseAnimationProgress = min(range.lowerBound + CGFloat(currentFrame) * progressIncrement, range.upperBound)
                
                // Check if animation is complete
                if currentFrame >= totalFrames {
                    timer.invalidate()
                    chooseAnimationFinished = true
                    
                    // Delay navigation to allow user to see the completed animation
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        shouldNavigate = true
                    }
                }
            }
        }
}

// Lottie View to display the animation
struct LottieView: UIViewRepresentable {
    var name: String
    @Binding var progress: CGFloat
    
    func makeUIView(context: Context) -> UIView {
        LottieConfiguration.shared.renderingEngine = .mainThread
        let view = UIView(frame: .zero)
        
        // Create the animation view
        let animationView = LottieAnimationView()
        animationView.animation = LottieAnimation.named(name)
        animationView.contentMode = .scaleAspectFit
        
        // Add animation view to container
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        // Store the animation view for updates
        context.coordinator.animationView = animationView
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Update the animation progress
        context.coordinator.animationView?.currentProgress = Double(progress)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator {
        var animationView: LottieAnimationView?
    }
}

extension CGPath {
    var length: CGFloat {
        var length: CGFloat = 0.0
        var currentPoint: CGPoint = .zero

        applyWithBlock { elementPointer in
            let element = elementPointer.pointee
            switch element.type {
            case .moveToPoint:
                currentPoint = element.points[0]
            case .addLineToPoint:
                let nextPoint = element.points[0]
                length += currentPoint.distance(to: nextPoint)
                currentPoint = nextPoint
            case .addQuadCurveToPoint:
                // Approximate curve with line segments
                let nextPoint = element.points[1]
                length += currentPoint.distance(to: nextPoint) // simple approximation
                currentPoint = nextPoint
            case .addCurveToPoint:
                let nextPoint = element.points[2]
                length += currentPoint.distance(to: nextPoint)
                currentPoint = nextPoint
            default:
                break
            }
        }
        return length
    }

    func point(at distance: CGFloat) -> CGPoint? {
        var total: CGFloat = 0.0
        var currentPoint: CGPoint = .zero
        var result: CGPoint?

        applyWithBlock { elementPointer in
            let element = elementPointer.pointee
            switch element.type {
            case .moveToPoint:
                currentPoint = element.points[0]
            case .addLineToPoint:
                let nextPoint = element.points[0]
                let segmentLength = currentPoint.distance(to: nextPoint)
                if total + segmentLength >= distance {
                    let ratio = (distance - total) / segmentLength
                    result = CGPoint(
                        x: currentPoint.x + (nextPoint.x - currentPoint.x) * ratio,
                        y: currentPoint.y + (nextPoint.y - currentPoint.y) * ratio
                    )
                }
                total += segmentLength
                currentPoint = nextPoint
            default:
                break
            }
        }

        return result
    }
}

extension CGPoint {
    func distance(to: CGPoint) -> CGFloat {
        sqrt(pow(x - to.x, 2) + pow(y - to.y, 2))
    }
}

#Preview {
    ChooseView()
}
