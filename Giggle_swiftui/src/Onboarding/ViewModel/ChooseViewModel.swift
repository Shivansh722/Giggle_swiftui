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
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing:40) {
            Image(icon)
                .resizable()
                .font(.title2)
                .foregroundColor(.red)
                .frame(width: 32,height: 47)
            Text(text)
                .foregroundColor(.white)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                
        }
        .padding([.leading,.trailing],60)
        
    }
}

#Preview {
    ClientOnboardingView()
}

