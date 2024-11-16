//
//  education-view.swift
//  Giggle_swiftui
//
//  Created by user@91 on 09/11/24.
//

import SwiftUI

struct eduView: View {
    
    @State private var selectedOption = "Yes"
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Theme.backgroundColor
                    .edgesIgnoringSafeArea(.all)
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
                            .padding(.leading, geometry.size.width * 0.08)
                        }
                        Spacer()
                    }
                    .padding(.top, geometry.size.height * 0.02)
                    Spacer()
                    
                }
                ProgressView(value: 40, total: 100)
                    .accentColor(Theme.primaryColor)
                    .padding(.horizontal, geometry.size.width * 0.08)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 12)
            
                Text("A")
                    .font(.system(size:56 , weight: .bold))
                    
                    .foregroundColor(Theme.primaryColor)
                + Text("re you pursuing your education")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.primaryColor)
                + Text("?")
                    .font(.system(size:56 , weight: .bold))
                    .foregroundColor(Theme.onPrimaryColor)
                
                
                Picker("Are you pursuing your education?", selection: $selectedOption) {
                                       Text("Yes").tag("Yes")
                        .foregroundColor(selectedOption == "Yes" ? .black : .white)
                                       Text("No").tag("No")
                        .foregroundColor(selectedOption == "No" ? .black : .white)
                                   }
                                   .pickerStyle(SegmentedPickerStyle())
                                   .padding(.horizontal, geometry.size.width * 0.08)
                                   .padding(.top, geometry.size.height * 0.4)
                
                
                
            }
            
            Spacer()
        }
       

    }
}

#Preview {
    eduView()
}
