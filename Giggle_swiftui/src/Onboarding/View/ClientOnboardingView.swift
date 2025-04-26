//
//  ClientOnboardingView.swift
//  Giggle_swiftui
//
//  Created by admin49 on 07/02/25.
//

import SwiftUI

struct ClientOnboardingView: View {
    var selectedRole: ChooseViewModel.Role?
    @State private var navigate: Bool = false
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Theme.backgroundColor.edgesIgnoringSafeArea(.all)

            VStack {
                Image("logo")
                    .resizable()
                    .frame(width: 200, height: 120)
                    .padding(.top, 60)
                    .padding(.bottom, 80)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : -20)
                    .animation(.easeOut(duration: 0.8).delay(0.2), value: isAnimating)
                
                VStack(spacing: 20) {
                    FeatureItem(
                        emoji: "📍",
                        text: selectedRole == .user ? "Find gigs easily near you" : "Find employees near you",
                        delay: 0.3
                    )
                    FeatureItem(
                        emoji: "📘",
                        text: selectedRole == .user ? "Prove your skills through FLN assessment" : "Giggle graded employees",
                        delay: 0.4
                    )
                    FeatureItem(
                        emoji: "💯",
                        text: selectedRole == .user ? "Get a Giggle grading and stand out from others" : "Find the best fit for the Gig",
                        delay: 0.5
                    )
                    FeatureItem(
                        emoji: "💵",
                        text: selectedRole == .user ? "Earn a respectable income" : "Reach out and get set",
                        delay: 0.6
                    )
                }
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : 20)
                
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
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : 20)
                .animation(.easeOut(duration: 0.8).delay(0.7), value: isAnimating)
                
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
        .tint(Theme.primaryColor)
        .onAppear {
            withAnimation {
                isAnimating = true
            }
        }
    }
}

struct FeatureOnboardItem: View {
    let emoji: String
    let text: String
    
    var body: some View {
        HStack {
            Text(emoji)
            Text(text)
                .foregroundColor(.white)
            Spacer()
        }
    }
}

#Preview {
    ClientOnboardingView(selectedRole: .user) // Added selectedRole for preview
}
