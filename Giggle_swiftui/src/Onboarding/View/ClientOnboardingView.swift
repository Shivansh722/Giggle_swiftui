//
//  ClientOnboardingView.swift
//  Giggle_swiftui
//
//  Created by admin49 on 07/02/25.
//

import SwiftUI

struct ClientOnboardingView: View {
//    @State private var selectedRole: ChooseViewModel.Role?
    var selectedRole: ChooseViewModel.Role?
    @State private var navigate:Bool = false
    var body: some View {
        ZStack {
            Theme.backgroundColor.edgesIgnoringSafeArea(.all)

            VStack {
                Image("logo")
                    .resizable()
                    .frame(width: 300, height: 150)
                    .padding(.top,40)
                
                Spacer()
                
                VStack(spacing: 20) {  
                    FeatureItem(
                        icon: "local", text: selectedRole == .user ? "Find gigs easily near you" : "Find employees near you")
                    FeatureItem(
                        icon: "Pass Fail",
                        text: selectedRole == .user ? "Prove your skills through FLN assessment":"Get Giggle graded skilled employees")
                    FeatureItem(
                        icon: "Marked assignment papers",
                        text:selectedRole == .user ? "Get a Giggle grading and stand out from others" : "Find the best fit for the Gig")
                    FeatureItem(
                        icon: "Request Money",
                        text: selectedRole == .user ? "Earn a respectable income":"Reach out and get set")
                }
                
                Spacer()
                
                Button(action:{
                    navigate = true
                }){
                    Text("CONTINUE")
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .frame(alignment: .center)
                        .foregroundColor(.white)
                }.frame(width: 323)
                    .background(Color(Theme.primaryColor))
                    .cornerRadius(8)
                    .padding()
                
                if selectedRole == .user {
                    NavigationLink(
                        destination: UserDetailView(),
                        isActive: $navigate
                    ) {
                        EmptyView()
                    }
                }
                else{
                    NavigationLink(
                        destination: ClientInfoView(),
                        isActive: $navigate
                    ){
                        EmptyView()
                    }
                }
                
            }
        }
        
    }
    
}

#Preview {
    ClientOnboardingView()
}
