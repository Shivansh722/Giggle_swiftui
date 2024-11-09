//
//  skills-view.swift
//  Giggle_swiftui
//
//  Created by user@91 on 09/11/24.
//

import SwiftUI

struct skillView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Text("skill  View")
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .background(Color.white)
            }
        }
    }
}

#Preview {
    skillView()
}
