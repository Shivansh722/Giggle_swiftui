import SwiftUI

struct UserInfoView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Text("User Info View")
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .background(Color.white)
            }
        }
    }
}

#Preview {
    UserInfoView()
}
