//
//  onboarding-main.swift
//  Giggle_swiftui
//
//  Created by user@91 on 24/03/25.
//

import SwiftUI

struct OnboardingView: View {
    @State private var navigate: Bool = false
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Theme.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack {
                Image("logo") // Replace with your actual logo asset name
                    .resizable()
                    .frame(width: 200, height: 120)
                    .padding(.top, 60)
                    .padding(.bottom, 40)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : -20)
                    .animation(.easeOut(duration: 0.8).delay(0.2), value: isAnimating)
                
                VStack(spacing: 20) {
                    FeatureItem(
                        emoji: "📍",// Ensure these icons exist in your assets
                        text: "Kickstart your career",
                        delay: 0.3
                    )
                    FeatureItem(
                        emoji: "🥷🏻",
                        text: "Show off your skills",
                        delay: 0.3
                    )
                    FeatureItem(
                        emoji: "💵",
                        text: "Earn money",
                        delay: 0.3
                    )
                    FeatureItem(
                        emoji: "🤹‍♂️",
                        text: "Join community of go-getters",
                        delay: 0.3
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
                        .foregroundColor(Theme.onPrimaryColor)
                }
                .frame(width: 323)
                .background(Color(Theme.primaryColor))
                .cornerRadius(8)
                .padding()
            }
            .padding(.top, 40)
            .padding(.horizontal, 50)
        }
        .tint(Theme.primaryColor) // Customize back button color (iOS 16+)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            withAnimation {
                isAnimating = true
            }
        }
        
    }
    
    struct Feature1OnboardItem: View {  // Renamed to match your naming convention
        let emoji: String
        let text: String
        
        
        var body: some View {
            HStack {
                Text(emoji)
                Text(text)
                    .foregroundColor(Theme.onPrimaryColor)
                Spacer()
            }
            .padding(.leading)
            
        }
    }
}

#Preview {
    OnboardingView() // Preview as gig seeker
}
