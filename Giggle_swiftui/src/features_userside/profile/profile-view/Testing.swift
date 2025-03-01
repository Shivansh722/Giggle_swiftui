//
//  Testing.swift
//  Giggle_swiftui
//
//  Created by admin49 on 01/03/25.
//

import SwiftUI

struct Testing: View {
    @StateObject var saveUserInfo = SaveUserInfo(appService: AppService())
    var body: some View {
        Button(action:{
            Task{
                await saveUserInfo.fetchFiles(userId:"67a9e3659de7bda07a47")
            }
        }){
            Text("click")
        }
    }
}

#Preview {
    Testing()
}
