//
//  Job-card-view.swift
//  Giggle_swiftui
//
//  Created by user@91 on 16/12/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Theme.backgroundColor
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Hi")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.primaryColor)
                            
                            Text("Orlando Diggs")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.onPrimaryColor)
                        }
                        .padding()
                        
                        Spacer()
                        
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color.gray)
                            .padding()
                    }
                    Spacer()
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
}

#Preview {
    HomeView()
}
