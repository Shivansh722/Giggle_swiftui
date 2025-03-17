//
//  Testing.swift
//  Giggle_swiftui
//
//  Created by admin49 on 01/03/25.
//

import SwiftUI

struct Testing: View {
    @StateObject var saveUserInfo = JobPost(appService: AppService())
    var body: some View {
        Button(action:{
            Task{
                try await saveUserInfo.fetchImage("CEFBBD65-618E-4C49-B650-6D266111BEB8")
            }
        }){
            Text("click")
        }
    }
}

#Preview {
    Testing()
}
