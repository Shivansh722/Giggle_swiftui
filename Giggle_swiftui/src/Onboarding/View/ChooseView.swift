import SwiftUI
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
    @State private var animationFinished = false
    @State private var timer: Timer? = nil
    
    var body: some View {
        ZStack {
            Theme.backgroundColor
                .ignoresSafeArea()

            VStack {
                GeometryReader { geo in
                    let width = geo.size.width
                    let height = geo.size.height
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
                        trailPoints.append(planePoint)
                        if trailPoints.count > 300 {
                            trailPoints.removeFirst()
                        }
                        previousPoint = planePoint
                        previousProgress = newProgress
                    }
                }
                .frame(height: 300)
                .onAppear {
                    let duration: TimeInterval = 1.0
                    let fps: Double = 60
                    var timeElapsed: TimeInterval = 0

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
                VStack {
                    Text("Are you looking for gigs or providing one?")
                        .font(Font.custom("SF Pro", size: 18).weight(.bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Theme.onPrimaryColor)
                        .padding(.bottom, 56)
                        .lineLimit(2)

                    Button(action: {
                        selectedRole = .client
                        isGigProviderSelected = true
                        isGigSeekerSelected = false
                        isSelected = true
                    }) {
                        Text("Gig Provider")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(isGigProviderSelected ? Color.red : Color(red: 0.64, green: 0.64, blue: 0.64))
                            .cornerRadius(16)
                    }
                    .frame(width: 323)
                    .padding(.bottom, 15)

                    Button(action: {
                        selectedRole = .user
                        isGigSeekerSelected = true
                        isGigProviderSelected = false
                        isSelected = true
                    }) {
                        Text("Gig Seeker")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(isGigSeekerSelected ? Color.red : Color(red: 0.64, green: 0.64, blue: 0.64))
                            .cornerRadius(16)
                    }
                    .frame(width: 323)
                    .padding(.bottom, 220)

                    if selectedRole == .user {
                        NavigationLink(
                            destination: ClientOnboardingView(selectedRole: selectedRole),
                            isActive: $isSelected
                        ) {
                            EmptyView()
                        }
                    } else {
                        NavigationLink(
                            destination: ClientOnboardingView(),
                            isActive: $isSelected
                        ) {
                            EmptyView()
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
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
