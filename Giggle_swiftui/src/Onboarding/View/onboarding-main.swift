//
//  onboarding-main.swift
//  Giggle_swiftui
//
//  Created by user@91 on 24/03/25.
//

//
//  OnboardingView.swift
//  Giggle_swiftui
//

import SwiftUI

struct OnboardingView: View {
    var selectedRole: ChooseViewModel.Role? // Assuming this comes from a role selection earlier
    @State private var navigate: Bool = false
    
    var body: some View {
        ZStack {
            Theme.backgroundColor.edgesIgnoringSafeArea(.all)

            VStack {
                Image("logo") // Replace with your actual logo asset name
                    .resizable()
                    .frame(width: 200, height: 120)
                    .padding(.top, 60)
                    .padding(.bottom, 80)
                
                VStack(spacing: 20) {
                    FeatureOnboardItem(
                        icon: "local", // Ensure these icons exist in your assets
                        text: selectedRole == .user ? "Kickstart your career with gigs at top retail stores" : "Post gigs and hire eager youth for your store"
                    )
                    FeatureOnboardItem(
                        icon: "Pass Fail",
                        text: selectedRole == .user ? "Show off your skills and get noticed by big brands" : "Find skilled young talent ready to shine"
                    )
                    FeatureOnboardItem(
                        icon: "Marked assignment papers",
                        text: selectedRole == .user ? "Earn money while building real-world experience" : "Fill shifts fast with reliable gig workers"
                    )
                    FeatureOnboardItem(
                        icon: "Request Money",
                        text: selectedRole == .user ? "Join a community of go-getters like you" : "Grow your team with Giggle’s vibrant youth"
                    )
                }
                
                Spacer()
                
                Button(action: {
                    navigate = true
                }) {
                    Text("CONTINUE")
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .frame(alignment: .center)
                        .foregroundColor(.white)
                }
                .frame(width: 323)
                .background(Color(Theme.primaryColor))
                .cornerRadius(8)
                .padding()
                
                if selectedRole == .user {
                    NavigationLink(
                        destination: ResumeUpload(),
                        isActive: $navigate
                    ) {
                        EmptyView()
                    }
                } else {
                    NavigationLink(
                        destination: ClientInfoView(),
                        isActive: $navigate
                    ) {
                        EmptyView()
                    }
                }
            }
        }
        .tint(Theme.primaryColor) // Customize back button color (iOS 16+)
    }
}

struct FeatureOnboardItem: View {  // Renamed to match your naming convention
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Image(icon)
                .resizable()
                .frame(width: 24, height: 24)
            Text(text)
                .foregroundColor(.white)
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(selectedRole: .user) // Preview as gig seeker
}
