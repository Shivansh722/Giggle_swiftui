//import Foundation
//
//@MainActor
//class RegisterViewModel: ObservableObject {
//    private let service: AppService
//    @Published var showAlert = false
//    @Published var alertMessage = ""
//    @Published var isLoading = false
//    @Published var isLoggedIn = false
//    
//    // Keeps track of any ongoing login task
//    private var loginTask: Task<Void, Never>?
//    
//    init(service: AppService) {
//        self.service = service
//    }
//    
//    func createUser(email: String, password: String) async {
//        guard !isLoading else { return } // Prevents multiple simultaneous tasks
//        isLoading = true
//        let status = await service.createUser(email: email, password: password)
//        
//        switch status {
//        case .success:
//            isLoggedIn = true
//            alertMessage = "User created successfully!"
//        case .error(let message):
//            alertMessage = message
//        }
//        showAlert = true
//        isLoading = false
//    }
//    
//    func login(email: String, password: String) {
//        guard !isLoading else { return } // Prevents new login attempt if already loading
//        
//        // Cancel any existing login task to avoid duplicate sessions
//        loginTask?.cancel()
//        
//        // Start a new login task
//        loginTask = Task {
//            isLoading = true
//            let status = await service.login(email: email, password: password)
//            
//            switch status {
//            case .success:
//                isLoggedIn = true
//            case .error(let message):
//                alertMessage = message
//                showAlert = true
//            }
//            
//            isLoading = false
//        }
//    }
//}

import Foundation
import AuthenticationServices
import SwiftUICore

@MainActor
class RegisterViewModel: ObservableObject {
    private let service: AppService
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var isLoading = false
    @Published var isLoggedIn = false
    
    // Keeps track of any ongoing login task
    private var loginTask: Task<Void, Never>?
    private var openURL: OpenURLAction?
    
    init(service: AppService) {
        self.service = service
    }
    
    func setOpenURLAction(_ action: OpenURLAction) {
        self.openURL = action
    }
    
    func createUser(email: String, password: String) async {
        guard !isLoading else { return } // Prevents multiple simultaneous tasks
        isLoading = true
        let status:RequestStatus = await service.createUser(email: email, password: password)
        
        switch status {
        case .success:
            isLoggedIn = true
            alertMessage = "User created successfully!"
        case .error(let message):
            alertMessage = message
        }
        
        showAlert = true
        isLoading = false
    }
    
    func signInWithApple(credential: ASAuthorizationAppleIDCredential) async {
        guard !isLoading else { return }
        isLoading = true
        
        let status = await service.createAppleSession()
        
        switch status {
        case .success:
            isLoggedIn = true
            alertMessage = "Successfully signed in with Apple!"
        case .error(let message):
            alertMessage = message
        }
        
        showAlert = true
        isLoading = false
    }
    
    func signInWithGoogle() async {
        guard !isLoading else { return }
        isLoading = true
        
        let status = await service.createGoogleSession(with: openURL)
        
        switch status {
        case .success:
            isLoggedIn = true
            alertMessage = "Successfully signed in with Google!"
        case .error(let message):
            alertMessage = message
        }
        
        showAlert = true
        isLoading = false
    }
    
    func login(email: String, password: String) {
        guard !isLoading else { return } // Prevents new login attempt if already loading
        
        // Cancel any existing login task to avoid duplicate sessions
        loginTask?.cancel()
        
        // Start a new login task
        loginTask = Task {
            isLoading = true
            
            // Attempt login with session cleanup if needed
            let status = await service.login(email: email, password: password)
            
            switch status {
            case .success:
                isLoggedIn = true
            case .error(let message):
                alertMessage = message
                showAlert = true
            }
            
            isLoading = false
        }
    }
    
    func logout() async {
        isLoading = true
        let status = await service.logout()
        
        switch status {
        case .success:
            isLoggedIn = false
            alertMessage = "Successfully logged out!"
        case .error(let message):
            alertMessage = message
        }
        
        showAlert = true
        isLoading = false
    }
}
