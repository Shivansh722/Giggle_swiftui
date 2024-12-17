//
//  save-user-info.swift
//  Giggle_swiftui
//
//  Created by admin49 on 17/12/24.
//

import Foundation
import Appwrite
import SwiftUICore

class SaveUserInfo:ObservableObject {
    let client: Client
    let database: Databases
    let appService: AppService
    
    init(appService: AppService) {
        self.client = appService.client
        self.database = Databases(client)
        self.appService = appService
    }
    func saveInfo() async -> Bool {
        let databaseId = "657eb094cd7622cdc23b"
        let collectionId = "67609b2c0020a833ac33"
        
        @ObservedObject var formManager = FormManager.shared
        let user = formManager.formData.userId
        print(user)
        let degreeName = dumpToDB()
        
        // Prepare the data to be stored
        let data: [String: Any] = [
            "userId": user,
            "degreeName":degreeName,
            "name":formManager.formData.name,
            "email":formManager.formData.email,
            "phone":formManager.formData.phone,
            "gender":formManager.formData.gender,
            "universityName":formManager.formData.universityName,
        ]
        
        do {
            // Try saving the data as a document in the database
            let result = try await database.createDocument(
                databaseId: databaseId,
                collectionId: collectionId,
                documentId: UUID().uuidString,  
                data: data
            )
            print("Data saved successfully. \(result)")
            return true
        } catch let error as AppwriteError {
            // Handle specific Appwrite errors
            if error.code == 404 { // Collection not found
                print("Error: Collection not found. Please create the collection first.")
            } else if error.code == 401 { // Unauthorized
                print("Error: Unauthorized access. Please check user permissions.")
            } else {
                print("Error saving data: \(error.localizedDescription)")
            }
            return false
        } catch {
            // Handle other unexpected errors
            print("Unexpected error: \(error.localizedDescription)")
            return false
        }
    }

    
    private func dumpToDB() -> String{
        @ObservedObject var formManager = FormManager.shared
        return formManager.formData.degreeName
    }
    
}
