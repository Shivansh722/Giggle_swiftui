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
    let databaseID:String = "67729cb100158022ba8e"
    let collectionID:String = "67729cdc0016234d1704"
    let storageBucketId:String = "67863b500019e5de0dd8"
    
    init(appService: AppService) {
        self.client = appService.client
        self.database = Databases(client)
        self.appService = appService
    }
    func saveInfo() async -> Bool {
        let databaseId = databaseID
        let collectionId = collectionID
        
        @ObservedObject var formManager = FormManager.shared
        let user = formManager.formData.userId
        print(user)
        let degreeName = dumpToDB()
        
        // Prepare the data to be stored
        let data: [String: Any] = [
//            "userId": user,
            "degreeName":degreeName,
            "name":formManager.formData.name,
            "email":formManager.formData.email,
            "phone":formManager.formData.phone,
            "gender":formManager.formData.gender,
            "universityName":formManager.formData.universityName,
            "resumeIds":formManager.formData.resumeIds
        ]
        
        do {
            // Try saving the data as a document in the database
            let result = try await database.createDocument(
                databaseId: databaseId,
                collectionId: collectionId,
                documentId: String(user),
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
    
    func fetchUser(userId: String) async{
        let databaseId = databaseID
        let collectionId = collectionID

        do {
            // Fetch the document using the userId as the document ID
            let document = try await database.getDocument(
                databaseId: databaseId,
                collectionId: collectionId,
                documentId: userId
            )
            print(document.data)
            FormManager.shared.formData.name = (document.data["name"]?.value as? String) ?? ""
        } catch {
            print("error fetching user: \(error)")
        }
    }
    
    @MainActor
    func fetchFiles(userId: String) async -> [[String]] {
        print("fetchFiles() called for userId:", userId)
        
        let databaseId = databaseID
        let collectionId = collectionID
        var fileDetails: [[String]] = [] 

        do {
            let document = try await database.getDocument(
                databaseId: databaseId,
                collectionId: collectionId,
                documentId: userId
            )

            if let fileArray = document.data["resumeIds"]?.value as? [String] {
                print("Found resume IDs:", fileArray)
                
                let storage = Storage(client)

                for fileId in fileArray {
                    do {
                        let byteBuffer = try await storage.getFile(
                            bucketId: storageBucketId,
                            fileId: fileId
                        )
                        
                        let fileInfo = [byteBuffer.name, String(byteBuffer.sizeOriginal)]
                        fileDetails.append(fileInfo)
                        
                        print("Fetched file:", fileInfo)
                    } catch {
                        print("Error fetching file \(fileId):", error)
                    }
                }
            }
        } catch {
            print("Error fetching document:", error)
            return [["error loading"]]
        }

        return fileDetails
    }






}
