//
//  button_red.swift
//  Giggle_swiftui
//
//  Created by user@91 on 02/11/24.
//
//
//import SwiftUI
//
//struct CustomButton: View {
//    var title: String
//    var backgroundColor: Color
//    var action: () -> Void //
//    var width: CGFloat = .infinity
//    var height: CGFloat = .infinity
//    var cornerRadius: CGFloat = 12
//  
//    
//    var body: some View {
//        Button(action: action) {
//            Text(title)
//                .foregroundColor(.white)
//                .fontWeight(.bold)
//                .padding()
//                .frame(width: width, height: height)//use width and height param in respec files
//                .background(Theme.primaryColor)
//                .cornerRadius(cornerRadius)
//                
//            
//            
//        }
//        .padding(.horizontal, 30)
//    }
//}

import SwiftUI

struct CustomButton: View {
    var title: String
    var backgroundColor: Color
    var action: () -> Void
    var width: CGFloat? // Use nil for flexible width
    var height: CGFloat? // Use nil for flexible height
    var cornerRadius: CGFloat = 12
    
    var body: some View {
        GeometryReader { geometry in
            Button(action: action) {
                Text(title)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding()
                    .frame(width: width ?? geometry.size.width * 0.9, // 90% of available width if nil
                           height: height ?? geometry.size.height * 0.1) // 10% of available height if nil
                    .background(backgroundColor)
                    .cornerRadius(cornerRadius)
            }
            .padding(.horizontal, geometry.size.width * 0.1) // 10% horizontal padding
        }
    }
}
