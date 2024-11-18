import SwiftUI

struct skillView: View {
    @StateObject private var viewModel = PreferenceViewModel() // Initialize ViewModel

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Theme.backgroundColor
                    .edgesIgnoringSafeArea(.all) // Ensure full screen white background
                VStack {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            HStack{
                                Text("Education")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Theme.primaryColor)
                                Text("Details")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Theme.onPrimaryColor)
                            }
                            
                        }
                        Spacer()
                    }
                    .padding(.top, geometry.size.height * 0.06)
                    Spacer()
                    
                    VStack {
                        ChipContainerView(viewModel: viewModel)
                            .padding()
                    }
                    padding(.top, geometry.size.height * 0.02)
                    
                }
                ProgressView(value: 40, total: 100)
                    .accentColor(Theme.primaryColor)
                    .padding(.horizontal, geometry.size.width * 0.08)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 12)
            
                
              
            }
        }
    }
}

#Preview {
    skillView()
}
