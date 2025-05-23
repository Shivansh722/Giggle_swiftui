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
    let postedJobId:String = "67da7b190038325b3b99"
    
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
    
    func fetchClientJob() async throws -> [[String: Any]] {
        do {
            let userDefaults = UserDefaults.standard
            guard let storedUserId = userDefaults.string(forKey: "userID") else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID not found in UserDefaults"])
            }
            
            let documents = try await database.listDocuments(
                databaseId: databaseID,
                collectionId: postedJobId,
                queries: [Query.equal("client_id", value: storedUserId)]
            )
            var jobData: [[String: Any]] = []
            
            for document in documents.documents {
                var data = document.data as [String: Any]
                let jobTitle = String(describing: data["job_title"] ?? "")
                data["job_title"] = jobTitle
                data["$id"] = document.id
                jobData.append(data)
            }
            return jobData
        } catch {
            print("Error fetching client job: \(error)")
            return []
        }
    }
    
    func deleteClientJob(_ getId:Any) async throws {
        do{
            print(getId)
            let userDefaults = UserDefaults.standard
            guard let storedUserId = userDefaults.string(forKey: "userID") else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID not found in UserDefaults"])
            }
            let result = try await database.deleteDocument(databaseId: databaseID, collectionId: postedJobId, documentId: getId as! String)

            let clientDoc = try await database.getDocument(databaseId: databaseID, collectionId: collectionID, documentId: storedUserId)
            
            var jobPostIds = clientDoc.data["job_post_id"] as? [String] ?? []
            
            jobPostIds.removeAll { $0 == getId as? String }
            
            let updatedDoc = try await database.updateDocument(
                databaseId: databaseID,
                collectionId: collectionID,
                documentId: storedUserId,
                data: ["job_post_id": jobPostIds]
            )
            
            print("Updated client doc: \(updatedDoc)")
            
        }
        catch{
            print(error)
        }
    }
}
