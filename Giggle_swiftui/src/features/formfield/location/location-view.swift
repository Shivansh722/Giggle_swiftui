//
//  location-view.swift
//  Giggle_swiftui
//
//  Created by user@91 on 12/11/24.
//

import SwiftUI

struct locationView: View {
    
    var body: some View {
        
        GeometryReader { geometry in
            
            
            ZStack {
                Theme.backgroundColor
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text("Location")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Theme.primaryColor)
                                Text("Details")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Theme.onPrimaryColor)
                            }
                            .padding(.leading, geometry.size.width * 0.08)
                        }
                        Spacer()
                    }
                    .padding(.top, geometry.size.height * 0.02)
                    
                    ProgressView(value: 20, total: 100)
                        .accentColor(Theme.primaryColor)
                        .padding(.horizontal, geometry.size.width * 0.08)
                        .padding(.bottom, 20)
                    
                    Image("local")
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, geometry.size.width * 0.4)
                        .padding(.top, geometry.size.height * 0.09)
                       
                    Text("Discover the best Gigs for you with Giggle!")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.onPrimaryColor)
                        .padding(.top, 12)
                       
                    Text("With Giggle, you can fund your own dates—no need to call your dad!")
                        .font(.subheadline)
                        .fontWeight(.light)
                        .foregroundColor(Theme.onPrimaryColor)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 35)
                        .padding(.top, 12)
                    
                    CustomButton(title: "NEXT", backgroundColor: Theme.primaryColor, action: {
                        //daba ke next page
                    }, width:320, height: 50, cornerRadius: 6)
                       
                        
                    
                }
                
            }
        }
    }
}

#Preview {
    locationView()
}
