//
//  onboarding-main.swift
//  Giggle_swiftui
//
//  Created by user@91 on 24/03/25.
//

import SwiftUI

struct OnboardingView: View {
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
                    Feature1OnboardItem(
                        icon: "local", // Ensure these icons exist in your assets
                        text: "Kickstart your career with gigs at top retail stores"
                    )
                    Feature1OnboardItem(
                        icon: "Pass Fail",
                        text: "Show off your skills and get noticed by big brands"
                    )
                    Feature1OnboardItem(
                        icon: "Request Money",
                        text: "Earn money while building real-world experience"
                    )
                    Feature1OnboardItem(
                        icon: "Marked assignment papers",
                        text: "Join a community of go-getters like you"
                    )
                }
                
                Spacer()
                
                NavigationLink(
                    destination: RegisterView(),
                    isActive: $navigate
                ) {
                    EmptyView()
                }
                
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
            }
            .padding(.horizontal, 50)
        }
        .tint(Theme.primaryColor) // Customize back button color (iOS 16+)
        .navigationBarBackButtonHidden(true)
    }
}

struct Feature1OnboardItem: View {  // Renamed to match your naming convention
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .padding(.trailing)
            Text(text)
                .foregroundColor(.white)
            Spacer()
        }
        .padding(.leading)
        
    }
}

#Preview {
    OnboardingView() // Preview as gig seeker
}
