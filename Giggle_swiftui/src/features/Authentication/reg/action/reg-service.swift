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
    
    func createUser(email: String, password: String) async throws ->  RequestStatus{
        
        do {
            _ = try await account.create(userId: ID.unique(), email: email, password: password)
        }
        catch {
            return .error(error.localizedDescription)
        }
        return .success//abhi ke lie hi daala bas, will remove after commiting createUser function
    }
}
