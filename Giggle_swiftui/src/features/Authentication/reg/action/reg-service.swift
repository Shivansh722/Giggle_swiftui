//import Appwrite
//
//enum RequestStatus {
//    case success
//    case error(_ message: String)
//}
//
//class AppService {
//    let client: Client
//    let account: Account
//    
//    init() {
//        self.client = Client()
//            .setEndpoint("https://cloud.appwrite.io/v1") // Ensure endpoint is correct
//            .setProject("6729f0c60023e865f840")
//            .setSelfSigned(true)
//        
//        self.account = Account(client)
//    }
//    
//    func createUser(email: String, password: String) async -> RequestStatus {
//        do {
//            _ = try await account.create(userId: ID.unique(), email: email, password: password)
//            return .success
//        } catch {
//            return .error(error.localizedDescription)
//        }
//    }
//    
//    func login(email: String, password: String) async -> RequestStatus {
//        do {
//            _ = try await account.createEmailPasswordSession(email: email, password: password)
//            return .success
//        } catch {
//            return .error(error.localizedDescription)
//        }
//    }
//    
//    func logout() async -> RequestStatus {
//        do {
//            _ = try await account.deleteSession(sessionId: "current")
//            return .success
//        } catch {
//            return .error(error.localizedDescription)
//        }
//    }
//}

import Appwrite

enum RequestStatus {
    case success
    case error(_ message: String)
}

class AppService {
    let client: Client
    let account: Account
    var userId:String?
    
    init() {
        self.client = Client()
            .setEndpoint("https://cloud.appwrite.io/v1") // Ensure endpoint is correct
            .setProject("6729f0c60023e865f840")
            .setSelfSigned(true)
        
        self.account = Account(client)
    }
    
    func createUser(email: String, password: String) async -> RequestStatus {
        do {
            let user = try await account.create(userId: ID.unique(), email: email, password: password)
            self.userId = user.id
            return .success
        } catch {
            return .error(error.localizedDescription)
        }
    }
    
    func login(email: String, password: String) async -> RequestStatus {
        // First, ensure any existing session is cleared
        let logoutStatus = await logout() // Attempt to log out any active session
        if case .error(let message) = logoutStatus {
            print("Logout failed: \(message)") // Optional: handle failed logout case
        }
        
        // Now, try to create a new session
        do {
            _ = try await account.createEmailPasswordSession(email: email, password: password)
            return .success
        } catch {
            return .error(error.localizedDescription)
        }
    }
    
    func logout() async -> RequestStatus {
        do {
            _ = try await account.deleteSession(sessionId: "current")
            return .success
        } catch {
            return .error(error.localizedDescription)
        }
    }
}
