import SwiftUI

struct PlaneAnimationView: View {
    @State private var planePosition: CGFloat = 0.0
    @State private var trailPoints: [CGPoint] = []

    let path = Path { path in
        path.move(to: CGPoint(x: 50, y: 300))
        
        // Wavy motion before the loop
        path.addQuadCurve(to: CGPoint(x: 150, y: 250), control: CGPoint(x: 100, y: 200))
        path.addQuadCurve(to: CGPoint(x: 250, y: 300), control: CGPoint(x: 200, y: 350))
        
        // Big loop
        path.addArc(center: CGPoint(x: 300, y: 250), radius: 40, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)
        
        // More wavy motion
        path.addQuadCurve(to: CGPoint(x: 400, y: 300), control: CGPoint(x: 350, y: 350))
        path.addQuadCurve(to: CGPoint(x: 500, y: 250), control: CGPoint(x: 450, y: 200))
        path.addQuadCurve(to: CGPoint(x: 600, y: 300), control: CGPoint(x: 550, y: 350))
        
        // Arrowhead (optional - not strictly necessary for infinite trail)
        path.addLine(to: CGPoint(x: 650, y: 275))
        path.addLine(to: CGPoint(x: 620, y: 300))
        path.addLine(to: CGPoint(x: 650, y: 325))
        path.addLine(to: CGPoint(x: 600, y: 300))
    }

    var body: some View {
        Canvas { context, size in
            // Draw the trail
            if !trailPoints.isEmpty {
                context.stroke(
                    Path { path in
                        path.addLines(trailPoints)
                    },
                    with: .color(.white),
                    style: StrokeStyle(lineWidth: 6, lineCap: .round, dash: [10, 10])
                )
            }

            // Draw the plane
            let trimmedPath = path.trimmedPath(from: 0, to: min(planePosition, 1.0))
            let planePoint = trimmedPath.currentPoint ?? CGPoint(x: 50, y: 300)
            if let planeImage = context.resolveSymbol(id: 1) {
                context.draw(planeImage, at: planePoint, anchor: .center)
            } else {
                context.fill(
                    Circle().path(in: CGRect(x: planePoint.x - 5, y: planePoint.y - 5, width: 10, height: 10)),
                    with: .color(.red)
                )
            }

            // Update trail points
            if planePosition > 0 {
                trailPoints.append(planePoint)
            }
        } symbols: {
            Image(systemName: "paperplane.fill")
                .renderingMode(.template)
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
                .tag(1)
        }
        .frame(width: .infinity, height: .infinity)
        .background(Color.black)
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1.0 / 60.0, repeats: true) { timer in
                withAnimation(.linear(duration: 0.0)) { // immediate update
                    planePosition += 0.0015 // speed
                }
                if planePosition >= 1.0 {
                    planePosition = 0.0
                    trailPoints.removeAll()
                }
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        PlaneAnimationView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
