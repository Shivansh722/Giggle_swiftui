//
//import SwiftUI
//struct userCardCustomView: View {
//    
//    var imageName: String
//    var title: String
//
//    var body: some View {
//        VStack(spacing: 8) {
//            
//            Image(imageName)
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 60, height: 80)
//            
//            Text(title)
//                .font(.system(size: 16, weight: .medium))
//                .foregroundColor(.white)
//                .padding(.top, -6)
//        }
//        .frame(width: 120, height: 102)
//        .padding()
//        .background(Color(red: 0.2, green: 0.2, blue: 0.2)) // Darker gray background
//        .cornerRadius(15)
//    }
//}
//
//#Preview {
//    userCardCustomView(imageName: "clipboard.icon", title: "Fill Form")
//}

import SwiftUI

struct userCardCustomView: View {
    var imageName: String
    var title: String

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: geometry.size.height * 0.08) { // Spacing as 8% of available height
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.8) // Adjusted for screen
                Text(title)
                    .font(.system(size: geometry.size.width * 0.1, weight: .medium)) // Responsive font size
                    .foregroundColor(Theme.onPrimaryColor)
            }
            .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.5) // Responsive frame size
            .padding()
            .background(Color(red: 0.2, green: 0.2, blue: 0.2))
            .cornerRadius(15)
        }
    }
}
