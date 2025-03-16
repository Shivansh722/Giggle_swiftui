import Foundation
import Appwrite

class JobPost: ObservableObject {
    let client: Client
    let database: Databases
    let appService: AppService
    
    let databaseID: String = "67729cb100158022ba8e"
    let posted_job = "67c803360001275e630b"
    let ClientCollection = "67a88597000fd8837adf"
    
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
}
