//
//  reg-service.swift
//  Giggle_swiftui
//
//  Created by user@91 on 06/11/24.
//

import Appwrite

enum RequestStatus {
    case success
    case error(_ message: String)
}

class AppService {
    
    let client = Client()
        .setEndpoint("https://cloud.appwrite.io/v1")
        .setProject("6729f0c60023e865f840")
        .setSelfSigned(true)
    
    let account: Account
    
    init() {
        account = Account(client)
    }
    
    //user banao function
    
    func createUser(email: String, password: String) async throws ->  RequestStatus{
        
        do {
            _ = try await account.create(userId: ID.unique(), email: email, password: password)
            return .success
        }
        catch {
            return .error(error.localizedDescription)
        }
        
    }
    
    //create email n pass
    
    func login(email: String, password: String) async throws ->  RequestStatus{
        
        do {
            _ = try await account.createEmailPasswordSession(email: email, password: password)
            return .success
        }
        catch {
            return .error(error.localizedDescription)
        }
    }
    
    //logout or delete this particular session
    
    func logout() async throws ->  RequestStatus{
        
        do {
            _ = try await account.deleteSession(sessionId: "currentSession")
            return .success
        }
        catch {
            return .error(error.localizedDescription)
        }
    }
}
