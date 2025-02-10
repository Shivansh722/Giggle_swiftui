//
//  Client-user-info.swift
//  Giggle_swiftui
//
//  Created by admin49 on 09/02/25.
//

import Foundation
import SwiftUI
import Appwrite

class ClientHandlerUserInfo: ObservableObject {
    let client: Client
    let database: Databases
    let appService: AppService
    let databaseID:String = "67729cb100158022ba8e"
    let collectionID:String = "67729cdc0016234d1704"
    
    init(appService: AppService) {
        self.client = appService.client
        self.database = Databases(client)
        self.appService = appService
    }
    
    func saveClientInfo(){
        
    }
}

// make view

//struct ClientUserInfoView: View {
//    @State private var name: String = "john doe"
//    @State private var DOB: String = "24/03/04"
//    @State private var gender: String = "male"
//    @State private var phone: String = "9898498944"
//    @State private var employerDetail: String = "me hu yaha"
//    @State private var storeName: String = "kachua"
//    @State private var location: String = "meraghar"
//    var body: some View {
//        Button(action:{}) {
//            
//        }
//    }
//}
//
//#Preview {
//    ClientUserInfoView()
//}
