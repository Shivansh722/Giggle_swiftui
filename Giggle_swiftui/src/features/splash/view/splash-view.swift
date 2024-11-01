//
//  splash-view.swift
//  Giggle_swiftui
//
//  Created by user@91 on 01/11/24.
//
import SwiftUI

struct SplashScreen: View {
    var body: some View {
        ZStack {
            Theme.backgroundColor
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 280, height: 150)
                
                Spacer()
                
                Image("tabline")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 180)
            }
        }
    }
}

