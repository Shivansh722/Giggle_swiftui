//
//  education-view.swift
//  Giggle_swiftui
//
//  Created by user@91 on 09/11/24.
//

import SwiftUI

struct eduView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Theme.backgroundColor
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            Text("Education")
                                .font(.title)
                                .foregroundColor(.white)
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, geometry.size.width * 0.08)
                    
                }
            }
        }
    }
}

#Preview {
    eduView()
}
