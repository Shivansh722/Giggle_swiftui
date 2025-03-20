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
import Foundation
import SwiftUICore

enum RequestStatus {
    case success
    case error(_ message: String)
}

class AppService: ObservableObject {
    let client: Client
    let account: Account
    @Published var userId: String?

    init() {
        self.client = Client()
            .setEndpoint("https://cloud.appwrite.io/v1")  // Ensure endpoint is correct
            .setProject("67da77af003e5e94f856")
            .setSelfSigned(true)

        self.account = Account(client)
    }

    func createUser(email: String, password: String) async -> RequestStatus {
        do {
            let user = try await account.create(
                userId: ID.unique(), email: email, password: password)
            FormManager.shared.formData.userId = user.id
            FormManager.shared.formData.email = user.email
            return .success
        } catch {
            return .error(error.localizedDescription)
        }
    }

    func login(email: String, password: String) async -> RequestStatus {
        // First, ensure any existing session is cleared
        let logoutStatus = await logout()  // Attempt to log out any active session
        if case .error(let message) = logoutStatus {
            print("Logout failed: \(message)")  // Optional: handle failed logout case
        }

        do {
            _ = try await account.createEmailPasswordSession(email: email, password: password)
//            let session = try await account.createEmailPasswordSession(email: email, password: password)
//            if let token = UserDefaults.standard.string(forKey: "apnsToken") {
//                let target = try await account.createPushTarget(
//                    targetId: ID.unique(),
//                    identifier: token,
//                    providerId: "67d9112700349d6ec5de"
//                )
//                print("Push target created: \(target.id)")
//            } else {
//                print("No APNs token found in UserDefaults")
//            }
            if let user = try? await account.get() {
                let userId = user.id
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
            } else {
                print("Failed to fetch user details after login.")
            }

            return .success
        } catch {
            return .error(error.localizedDescription)
        }
    }
    
    func createAppleSession() async -> RequestStatus {
        do {
            // This will open the Apple OAuth2 flow in a web view
            _ = try await account.createOAuth2Session(provider: .apple)
            if let user = try? await account.get() {
                self.userId = user.id
                FormManager.shared.formData.userId = user.id
                FormManager.shared.formData.email = user.email
            }
            return .success
        } catch {
            return .error(error.localizedDescription)
        }
    }
    
    func createGoogleSession(with openURL: OpenURLAction?) async -> RequestStatus {
            do {
                if let openURL = openURL {
                    // Use modern WebView OAuth approach for iOS 14+
                    _ = try await account.createOAuth2Session(
                        provider: .google,
                        success: nil, failure: nil, scopes: ["profile", "email"]
                    )
                } else {
                    // Fallback for testing/preview environment
                    print("Warning: OpenURLAction not available - OAuth may not complete properly")
                    _ = try await account.createOAuth2Session(provider: .google)
                }
                
                // If we get here without error, try to fetch the user details
                if let user = try? await account.get() {
                    DispatchQueue.main.async {
                        self.userId = user.id
                        FormManager.shared.formData.userId = user.id
                        FormManager.shared.formData.email = user.email
                        
                        // Save to UserDefaults for persistence
                        UserDefaults.standard.set(user.id, forKey: "userID")
                    }
                }
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
