//
//  view.swift
//  Giggle_swiftui
//
//  Created by user@91 on 04/11/24.
//


import SwiftUI
struct SectionTitleView: View {
    var title: String
    var color: Color
    
    var body: some View {
        Text(title)
            .font(.system(size: 24, weight: .bold))
            .foregroundColor(color)
            .padding(.bottom, 4)
    }
}
