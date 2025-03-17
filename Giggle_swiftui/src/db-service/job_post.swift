import Foundation
import Appwrite
import UIKit

class JobPost: ObservableObject {
    let client: Client
    let database: Databases
    let appService: AppService
    
    let databaseID: String = "67729cb100158022ba8e"
    let posted_job = "67c803360001275e630b"
    let ClientCollection = "67a88597000fd8837adf"
    let userCollection = "67729cdc0016234d1704"
    let BucketId = "67863b500019e5de0dd8"
    
    init(appService: AppService) {
        self.client = appService.client
        self.database = Databases(client)
        self.appService = appService
    }
    
    func get_job_post() async throws -> [[String: Any]] {
        do {
            let documentList = try await database.listDocuments(
                databaseId: databaseID,
                collectionId: posted_job
            )
            
            var jobPosts: [[String: Any]] = []
            
            for document in documentList.documents {
                let data = document.data as [String: Any]
                jobPosts.append(data)
            }
            
            print(jobPosts)
            return jobPosts
            
        } catch {
            print("Error fetching documents: \(error)")
            throw error
        }
    }
    
    func postJob() async throws{
        let userDefaults = UserDefaults.standard
        let storedUserId = userDefaults.string(forKey: "userID")
        
        do{
            let data:[String:Any] = [
                "job_title" : JobFormManager.shared.formData.jobTitle,
                "location": JobFormManager.shared.formData.location,
                "salary": JobFormManager.shared.formData.salary,
                "job_type": JobFormManager.shared.formData.jobType,
                "job_trait": JobFormManager.shared.formData.jobTrait,
                "client_id":storedUserId!
            ]
            
            let result = try await database.createDocument(databaseId: databaseID, collectionId: posted_job, documentId: String(describing:JobFormManager.shared.formData.id), data: data)
            
            print(result.id)
            let idString:[String] = [String(describing:JobFormManager.shared.formData.id)]
            let clientUpdateId:[String:Any] = [
                "job_post_id":idString]
            
            _ = try await database.updateDocument(databaseId: databaseID, collectionId: ClientCollection, documentId: storedUserId!, data: clientUpdateId)
        }catch{
            print(error)
        }
    }
    
    func applyJob(_ jobId: String) async throws {
        let userDefaults = UserDefaults.standard
        let storedUserId = userDefaults.string(forKey: "userID")
        
        do {
            let userDoc = try await database.getDocument(
                databaseId: databaseID,
                collectionId: userCollection,
                documentId: storedUserId!
            )
            
            let jobDoc = try await database.getDocument(
                databaseId: databaseID,
                collectionId: posted_job,
                documentId: jobId
            )
            
            var currentAppliedJobs = userDoc.data["applied_job_id"]?.value as? [String] ?? []
            var currentPeopleApplied = jobDoc.data["people_applied"]?.value as? [String] ?? []
            
            if !currentAppliedJobs.contains(jobId) {
                currentAppliedJobs.append(jobId)
            }
            if !currentPeopleApplied.contains(storedUserId!) {
                currentPeopleApplied.append(storedUserId!)
            }
            
            let userData: [String: Any] = ["applied_job_id": currentAppliedJobs]
            let _ = try await database.updateDocument(
                databaseId: databaseID,
                collectionId: userCollection,
                documentId: storedUserId!,
                data: userData
            )
            
            let jobData: [String: Any] = ["people_applied": currentPeopleApplied]
            let _ = try await database.updateDocument(
                databaseId: databaseID,
                collectionId: posted_job,
                documentId: jobId,
                data: jobData
            )
            
        } catch {
            print(error)
        }
    }
    
    func fetchImage(_ jobId: String) async throws -> String {
        let result = try await database.getDocument(databaseId: databaseID, collectionId: posted_job, documentId: jobId)
        
        print(result.data["client_id"]?.value as? String ?? "undefines")
        
        let getClientImageId = try await database.getDocument(databaseId: databaseID, collectionId: ClientCollection, documentId: result.data["client_id"]?.value as? String ?? "undefines")
        
        print(getClientImageId.data["photos"])
        
        guard let photos = getClientImageId.data["photos"]?.value as? [String],
                  let photoId = photos.first else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No photos found"])
            }
        print("Photo ID: \(photoId)")
        let storage = Storage(client)
        let imageData = try await storage.getFilePreview (
                bucketId: BucketId,
                fileId: photoId
            )
        
        var byteBuffer = imageData
        
        let data = byteBuffer.readData(length: byteBuffer.readableBytes)
        
        return String((data?.base64EncodedString())!)
    }
}
