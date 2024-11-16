//
//  edu-view2.swift
//  Giggle_swiftui
//
//  Created by user@91 on 16/11/24.
//

import SwiftUI

struct eduView2: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Theme.backgroundColor
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            HStack {
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
                
                ProgressView(value: 60, total: 100)
                    .accentColor(Theme.primaryColor)
                    .padding(.horizontal, geometry.size.width * 0.08)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 12)
            }
        }
    }
}

#Preview {
    eduView2()
}
