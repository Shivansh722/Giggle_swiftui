import SwiftUI

struct skillView: View {
    @StateObject private var viewModel = PreferenceViewModel() // Initialize ViewModel

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white
                    .edgesIgnoringSafeArea(.all) // Ensure full screen white background
                VStack {
                    ChipContainerView(viewModel: viewModel)
                        .padding()
                }
            }
        }
    }
}

#Preview {
    skillView()
}
