import Foundation

@MainActor //attribute is used in Swift to ensure that all code within the marked class, struct,
            //or function runs on the main thread

class RegisterViewModel: ObservableObject {
    private let service: AppService
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var isLoading = false
    @Published var isLoggedIn = false
    
    init(service: AppService) {
        self.service = service
    }
    
    func createUser(email: String, password: String) async {
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
    
    func login(email: String, password: String) async {
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
