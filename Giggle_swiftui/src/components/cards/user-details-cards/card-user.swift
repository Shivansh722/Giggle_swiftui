//
//  card-user.swift
//  Giggle_swiftui
//
//  Created by user@91 on 03/11/24.
//

import SwiftUI

struct userCardCustomView: View {
    
    var imageName: String
    var title: String

    var body: some View {
        VStack(spacing: 8) {
            
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            
            
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
        }
        .frame(width: 100, height: 100)
        .padding()
        .background(Color.gray)
        .cornerRadius(15)
    }
}

#Preview {
    
    userCardCustomView(imageName: "clipboard.icon", title: "Fill Form")
}
