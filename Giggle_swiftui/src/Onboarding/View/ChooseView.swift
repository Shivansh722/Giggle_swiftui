import SwiftUI

struct ChooseView: View {
    @State private var isSelected: Bool = false
    @State private var isGigProviderSelected: Bool = false
    @State private var isGigSeekerSelected: Bool = false
    @State private var selectedRole: ChooseViewModel.Role?
    
    var body: some View {
        ZStack {
            Theme.backgroundColor
                .ignoresSafeArea()

            VStack {
                Image("plane")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .clipped()

                VStack {
                    Text("Are you looking for gigs or\nproviding one?")
                        .font(Font.custom("SF Pro", size: 16).weight(.bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .frame(width: 222)
                        .padding(.bottom,56)

                    Button(action: {
                        selectedRole = .client
                        isGigProviderSelected = true
                        isGigSeekerSelected = false
                    }) {
                        Text("Gig Provider")
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .frame(alignment: .center)
                    }
                    .frame(width: 323)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .inset(by: 0.5)
                            .stroke(isGigProviderSelected ? Color.red : Color(red: 0.64, green: 0.64, blue: 0.64), lineWidth: 1)
                    )
                    .padding(.bottom,15)

                    Button(action: {
                        selectedRole = .user
                        isGigSeekerSelected = true
                        isGigProviderSelected = false

                    }) {
                        Text("Gig Seeker")
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .frame(alignment: .center)
                    }
                    .frame(width: 323)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .inset(by: 0.5)
                            .stroke(isGigSeekerSelected ? Color.red : Color(red: 0.64, green: 0.64, blue: 0.64), lineWidth: 1)
                    ).padding(.bottom,220)

                    Button(action: {
                        isSelected = true
                    }) {
                        Text("Next")
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .frame(alignment: .center)
                            .foregroundColor(.white)
                    }
                    .frame(width: 323)
                    .background(Color(Theme.primaryColor))
                    .cornerRadius(8)
                    
                    if selectedRole == .user {
                        NavigationLink(
                            destination: ClientOnboardingView(selectedRole: selectedRole),
                            isActive: $isSelected
                        ) {
                            EmptyView()
                        }
                    }
                    else{
                        NavigationLink(
                            destination: ClientOnboardingView(),
                            isActive: $isSelected
                        ) {
                            EmptyView()
                        }
                    }
                

                    
                }
            }
        }.navigationBarHidden(true)
    }
}

#Preview {
    ChooseView()
}
