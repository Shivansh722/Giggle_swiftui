//
//  user-detail.swift
//  Giggle_swiftui
//
//  Created by user@91 on 03/11/24.
//

import SwiftUI

struct user_detail: View {
    var body: some View {
        
        ZStack {
            Theme.backgroundColor
                .edgesIgnoringSafeArea(.all)
            
            VStack() {
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text("User")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.primaryColor)
                            
                            Text("Details")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.onPrimaryColor)
                        }
                    }
                    .padding(.leading, 30)
                    
                    Spacer()
                }
                .padding(.top, 30)
                
                Spacer()
                
                Text("Fill Manually")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.secondaryColor)
                    .padding(.top, -300)
                    .padding(.leading, -100)
                Spacer()
                
                userCardCustomView(imageName: "clipboard.icon", title: "Fill Form")
                
                userCardCustomView(imageName: "photo.icon", title: "Upload Resume") 
                
            }
        }
    }
}

#Preview {
    user_detail()
}
