import Appwrite

enum RequestStatus {
    case success
    case error(_ message: String)
}

class AppService {
    let client: Client
    let account: Account
    
    init() {
        self.client = Client()
            .setEndpoint("https://cloud.appwrite.io/v1") // Ensure endpoint is correct
            .setProject("6729f0c60023e865f840")
            .setSelfSigned(true)
        
        self.account = Account(client)
    }
    
    func createUser(email: String, password: String) async -> RequestStatus {
        do {
            _ = try await account.create(userId: ID.unique(), email: email, password: password)
            return .success
        } catch {
            return .error(error.localizedDescription)
        }
    }
    
    func login(email: String, password: String) async -> RequestStatus {
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
