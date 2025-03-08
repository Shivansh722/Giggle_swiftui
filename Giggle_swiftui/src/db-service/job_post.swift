import Foundation
import Appwrite

class JobPost: ObservableObject {
    let client: Client
    let database: Databases
    let appService: AppService
    
    let databaseID: String = "67729cb100158022ba8e"
    let posted_job = "67c803360001275e630b"
    
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
}
