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
                    Text("Are you looking for gigs or providing one?")
                        .font(Font.custom("SF Pro", size: 18).weight(.bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Theme.onPrimaryColor)
                        .padding(.bottom, 56)
                        .lineLimit(2)
                        //text is not coming in one line

                    Button(action: {
                        selectedRole = .client
                        isGigProviderSelected = true
                        isGigSeekerSelected = false
                        isSelected = true // Trigger navigation
                    }) {
                        Text("Gig Provider")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(isGigProviderSelected ? Color.red : Color(red: 0.64, green: 0.64, blue: 0.64))
                            .cornerRadius(16)
                    }
                    .frame(width: 323)
                    .padding(.bottom, 15)

                    Button(action: {
                        selectedRole = .user
                        isGigSeekerSelected = true
                        isGigProviderSelected = false
                        isSelected = true // Trigger navigation
                    }) {
                        Text("Gig Seeker")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(isGigSeekerSelected ? Color.red : Color(red: 0.64, green: 0.64, blue: 0.64))
                            .cornerRadius(16)
                    }
                    .frame(width: 323)
                    .padding(.bottom, 220)

                    // Navigation Links
                    if selectedRole == .user {
                        NavigationLink(
                            destination: ClientOnboardingView(selectedRole: selectedRole),
                            isActive: $isSelected
                        ) {
                            EmptyView()
                        }
                    } else {
                        NavigationLink(
                            destination: ClientOnboardingView(),
                            isActive: $isSelected
                        ) {
                            EmptyView()
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    ChooseView()
}
