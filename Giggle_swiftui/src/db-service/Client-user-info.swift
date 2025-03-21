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
    let databaseID:String = "67da78cd00052312da62"
    let collectionID:String = "67da7b8e001f23053dd5"
    
    init(appService: AppService) {
        self.client = appService.client
        self.database = Databases(client)
        self.appService = appService
    }
    
    func saveClientInfo() async {
        let databaseId = databaseID
        let collectionId = collectionID
        
        let data:[String:Any] = [
            "name":ClientFormManager.shared.clientData.name,
            "DOB":"nil",
            "gender":ClientFormManager.shared.clientData.gender,
            "phone":ClientFormManager.shared.clientData.phone,
            "employerDetail":ClientFormManager.shared.clientData.employerDetail,
            "storeName":ClientFormManager.shared.clientData.storeName,
            "location":ClientFormManager.shared.clientData.location,
            "work_trait":ClientFormManager.shared.clientData.workTrait,
            "photos":ClientFormManager.shared.clientData.photos
        ]
        
        do {
            let result = try await database.createDocument(databaseId: databaseId, collectionId: collectionId, documentId: String(FormManager.shared.formData.userId), data: data)
            let userId = FormManager.shared.formData.userId
            let userDefaults = UserDefaults.standard
            let storedUserId = userDefaults.string(forKey: "userID")
            DispatchQueue.main.async {
                if storedUserId != userId {
                    // Update userId in FormManager and UserDefaults if it's different
                    FormManager.shared.formData.userId = userId
                    userDefaults.set(userId, forKey: "userID")
                    print("UserId updated to: \(userId)")
                } else {
                    FormManager.shared.formData.userId = userId
                    print("UserId remains the same: \(userId)")
                }
            }
            userDefaults.set("completed client", forKey: "status")
            print("Data saved Successfully. \(result.data)")
        }
        catch{
            print(error)
        }
        
    }
    
    func checkForCleintExixtence() async throws -> Bool {
        do{
            let userDefaults = UserDefaults.standard
            let storedUserId = userDefaults.string(forKey: "userID")
            let documentId = FormManager.shared.formData.userId.isEmpty ? storedUserId : FormManager.shared.formData.userId
            let result = try await database.getDocument(databaseId: databaseID, collectionId: collectionID, documentId: storedUserId!)
            print("Retrieved document data: \(result.data)")
            return !result.data.isEmpty
        }catch{
            print(error)
            return false
        }
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
