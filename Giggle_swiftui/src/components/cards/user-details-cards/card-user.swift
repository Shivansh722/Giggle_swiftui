
import SwiftUI
struct userCardCustomView: View {
    
    var imageName: String
    var title: String

    var body: some View {
        VStack(spacing: 8) {
            
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 80)
            
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .padding(.top, -6)
        }
        .frame(width: 120, height: 102)
        .padding()
        .background(Color(red: 0.2, green: 0.2, blue: 0.2)) // Darker gray background
        .cornerRadius(15)
    }
}

#Preview {
    userCardCustomView(imageName: "clipboard.icon", title: "Fill Form")
}
