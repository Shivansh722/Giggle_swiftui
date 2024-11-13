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

@MainActor//brings the query to the main running thread

class RegisterViewModel: ObservableObject {
    private let service: AppService
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var isLoading = false
    @Published var isLoggedIn = false
    
    /*
     
     @Published:
     
     This property wrapper is used in conjunction with the ObservableObject protocol to create observable objects. It's commonly used in SwiftUI apps with the MVVM pattern to represent the ViewModel layer. @Published is used to expose properties from the ViewModel that the View observes for changes. When a property marked with @Published changes, it automatically triggers the view to update any affected parts of its UI.
     
     @state:
     
     This property wrapper is used to declare state information within a SwiftUI view. It's typically used for local state within a view, meaning data that is relevant only to that specific view and doesn't need to be shared across multiple views or persisted beyond the lifetime of the view. @State is useful for managing things like whether a button is currently pressed, the current selection in a picker, or whether a modal is presented.




     */
    
    
    // Keeps track of any ongoing login task
    private var loginTask: Task<Void, Never>?
    
    init(service: AppService) {
        self.service = service
    }
    
    func createUser(email: String, password: String) async {
        guard !isLoading else { return } // Prevents multiple simultaneous tasks
        isLoading = true
        let status = await service.createUser(email: email, password: password)
        
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
