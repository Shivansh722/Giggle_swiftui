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
    let databaseID:String = "67da78cd00052312da62"
    let collectionID:String = "67da79a900157497cced"
    let storageBucketId:String = "67da7d55000bf31fb062"
    
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
    func fetchFiles() async -> [[String]] {
        let userDefaults = UserDefaults.standard
        let storedUserId = userDefaults.string(forKey: "userID")
        print("fetchFiles() called for userId:", storedUserId!)
        
        let databaseId = databaseID
        let collectionId = collectionID
        var fileDetails: [[String]] = []

        do {
            let document = try await database.getDocument(
                databaseId: databaseId,
                collectionId: collectionId,
                documentId: storedUserId!
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

    func jobAppliedCheck(_ jobId:String) async throws -> Bool {
        
        let userDefaults = UserDefaults.standard
        let storedUserId = userDefaults.string(forKey: "userID")
        
        do{
            let result = try await database.getDocument(databaseId: databaseID, collectionId: collectionID, documentId: storedUserId!)
            
            if let appliedJobsArray = result.data["applied_job_id"]?.value as? [String] {
                let hasApplied = appliedJobsArray.contains(jobId)
                return hasApplied
            }
        }catch{
            print(error)
            return false
        }
        return false
    }
    
    func fetchUser() async throws -> (String,String) {
        let userDefaults = UserDefaults.standard
        let storedUserId = userDefaults.string(forKey: "userID")
        var arrayCount = "0"
        var gigGrade = "No Grade"
        let result = try await database.getDocument(databaseId: databaseID, collectionId: collectionID, documentId: storedUserId!)
        
        if let countm = result.data["applied_job_id"]?.value as? [String] {
            arrayCount = String(countm.count)
        }
        
        if let grade = result.data["fln_id"]?.value as? String {
            let gradding = try await database.getDocument(databaseId: databaseID, collectionId: "67da7a890023a1f7ed53", documentId: grade)
            gigGrade = gradding.data["giggle_grade"]?.value as? String ?? "No Grade"
        }
        
        return (arrayCount,gigGrade)
    }
    
    @MainActor
    func updateBiographhy(_ updatedBio:String) async throws {
        let userDefaults = UserDefaults.standard
        let storedUserId = userDefaults.string(forKey: "userID")
        
        do{
            _ =  try await database.updateDocument(databaseId: databaseID, collectionId: collectionID, documentId: storedUserId!,data: ["biography":updatedBio])
            FormManager.shared.formData.Biography = updatedBio
        }catch{
            print(error)
        }
    }
    
    @MainActor
    func getBio() async throws -> String {
        let userDefaults = UserDefaults.standard
        let storedUserId = userDefaults.string(forKey: "userID")
        var setBio:String = ""
        
        do{
            let bio = try await database.getDocument(databaseId: databaseID, collectionId: collectionID, documentId: storedUserId!)
            setBio = bio.data["biography"]?.value as? String ?? ""
            FormManager.shared.formData.Biography = setBio
        }catch{
            print(error)
        }
        return setBio
    }
    
    @MainActor
    func updateName(_ updatedName:String) async throws {
        let userDefaults = UserDefaults.standard
        let storedUserId = userDefaults.string(forKey: "userID")
        
        do{
           _ =  try await database.updateDocument(databaseId: databaseID, collectionId: collectionID, documentId: storedUserId!,data: ["name":updatedName])
            
            FormManager.shared.formData.name = updatedName
        }catch{
            print(error)
        }
    }
    
    func updateUserInfoResume() async throws{
        let userDefaults = UserDefaults.standard
        let storedUserId = userDefaults.string(forKey: "userID")
        do{
            print(FormManager.shared.formData.resumeIds)
            let updatedIDS:[String:Any] = ["resumeIds":FormManager.shared.formData.resumeIds]
            _ = try await database.updateDocument(databaseId: databaseID, collectionId: collectionID, documentId: storedUserId!,data: updatedIDS)
        }catch{
            print(error)
        }
        
        
    }
}
