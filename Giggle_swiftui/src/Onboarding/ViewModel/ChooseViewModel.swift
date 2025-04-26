//
//  ChooseViewModel.swift
//  Giggle_swiftui
//
//  Created by admin49 on 07/02/25.
//

import Foundation
import SwiftUI

class ChooseViewModel:ObservableObject{
    
    enum Role:String, CaseIterable{
        case user = "Gig Seeker"
        case client = "Gig Provider"
    }
    
    init(){}
}


struct FeatureItem: View {
    let emoji: String
    let text: String
    let delay: Double
    @State private var isVisible = false
    
    var body: some View {
        HStack(spacing: 40) {
            Text(emoji)
                .opacity(isVisible ? 1 : 0)
                .offset(x: isVisible ? 0 : -20)
                .animation(.easeOut(duration: 0.5).delay(delay), value: isVisible)
            
            Text(text)
                .foregroundColor(.white)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .opacity(isVisible ? 1 : 0)
                .offset(x: isVisible ? 0 : 20)
                .animation(.easeOut(duration: 0.5).delay(delay + 0.1), value: isVisible)
        }
        .padding([.leading, .trailing], 60)
        .onAppear {
            withAnimation {
                isVisible = true
            }
        }
    }
}

#Preview {
    ClientOnboardingView()
}

