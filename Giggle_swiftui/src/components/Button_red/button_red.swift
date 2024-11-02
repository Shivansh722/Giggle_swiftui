//
//  button_red.swift
//  Giggle_swiftui
//
//  Created by user@91 on 02/11/24.
//

import SwiftUI

struct CustomButton: View {
    var title: String
    var backgroundColor: Color
    var action: () -> Void //
    var width: CGFloat = .infinity
    var height: CGFloat = .infinity
    var cornerRadius: CGFloat = 12
  
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.white)
                .fontWeight(.bold)
                .padding()
                .frame(width: width, height: height)//use width and height param in respec files
                .background(Theme.primaryColor)
                .cornerRadius(cornerRadius)
                
            
            
        }
        .padding(.horizontal, 30)
    }
}
