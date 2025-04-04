import SwiftUI

struct CustomButton: View {
    var title: String
    var backgroundColor: Color
    var action: () -> Void
    var width: CGFloat? // Use nil for flexible width
    var height: CGFloat? // Use nil for flexible height
    var cornerRadius: CGFloat = 12
    var hasStroke: Bool = false // New property to control stroke visibility
    var strokeColor: Color = .white // Default stroke color
    var lineWidth: CGFloat = 2 // Default stroke width

    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.white)
                .fontWeight(.bold)
                .padding()
                .frame(width: width ?? 200, // Default width if nil
                       height: height ?? 50) // Default height if nil
                .background(
                    ZStack {
                        backgroundColor
                        if hasStroke {
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .stroke(strokeColor, lineWidth: lineWidth)
                        }
                    }
                )
                .cornerRadius(cornerRadius)
        }
        .padding(.horizontal, 20) // Default horizontal padding
    }
}

#Preview {
    VStack(spacing: 20) {
        CustomButton(
            title: "With Stroke",
            backgroundColor: Theme.backgroundColor,
            action: {},
            width: 180,
            height: 50,
            cornerRadius: 6,
            hasStroke: true,
            strokeColor: .blue,
            lineWidth: 3
        )

        CustomButton(
            title: "No Stroke",
            backgroundColor: Theme.backgroundColor,
            action: {},
            width: 320,
            height: 50,
            cornerRadius: 6
        )
    }
}
