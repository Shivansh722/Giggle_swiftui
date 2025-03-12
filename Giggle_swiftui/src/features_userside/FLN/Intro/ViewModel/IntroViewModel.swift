//
//  IntroViewModel.swift
//  Giggle_swiftui
//
//  Created by rjk on 09/03/25.
//

import Foundation
import SwiftUI

class IntroViewModel:ObservableObject{
    
    enum Role:String, CaseIterable{
        case user = "Gig Seeker"
        case client = "Gig Provider"
    }
    
    init(){}
}


struct IntroItem: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing:20) {
            Image(icon)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .font(.title2)
                .foregroundColor(.red)
                .frame(width: 50,height: 50)
            Text(text)
                .foregroundColor(.white)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                
        }
        .padding(.leading, 40)
        .padding(.trailing, 60)
        
    }
}

