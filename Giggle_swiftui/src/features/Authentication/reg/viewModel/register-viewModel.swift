import Foundation

@MainActor
class RegisterViewModel: ObservableObject {
    private let service: AppService
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var isLoading = false
    @Published var isLoggedIn = false
    
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
}
