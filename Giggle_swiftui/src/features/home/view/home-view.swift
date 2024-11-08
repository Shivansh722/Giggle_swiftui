import SwiftUI

struct HomeView: View { // Add ': View' to conform to the 'View' protocol
    @State var text = "Hello, World!"

    var body: some View {
        Text(text)
    }
}
