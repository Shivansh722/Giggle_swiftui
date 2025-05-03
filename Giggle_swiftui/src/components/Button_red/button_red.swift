import SwiftUI

struct CustomButton: View {
    var title: String
    var backgroundColor: Color
    var action: () -> Void
    var width: CGFloat? = nil
    var height: CGFloat? = nil
    var cornerRadius: CGFloat = 12
    var hasStroke: Bool = false
    var strokeColor: Color = .white
    var lineWidth: CGFloat = 2

    // New for animated border
    @State private var dashPhase: CGFloat = 0
    @State private var animationDuration: Double = 2.0

    var body: some View {
        Button(action: action) {
            ZStack {
                backgroundColor

                if hasStroke {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .strokeBorder(strokeColor, style: StrokeStyle(lineWidth: lineWidth, dash: [15, 7], dashPhase: dashPhase))
                        .animation(
                            Animation.linear(duration: animationDuration).repeatForever(autoreverses: false),
                            value: dashPhase
                        )
                }

                Text(title)
                    .foregroundColor(Theme.onPrimaryColor)
                    .fontWeight(.bold)
            }
            .frame(width: width ?? 200, height: height ?? 50)
            .cornerRadius(cornerRadius)
        }
        .padding(.horizontal, 20)
        .onAppear {
            dashPhase = 25 // Adjust phase to match dash pattern
        }
    }
}
