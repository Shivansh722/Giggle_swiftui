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
                try await saveUserInfo.get_job_post()
            }
        }){
            Text("click")
        }
    }
}

#Preview {
    Testing()
}
