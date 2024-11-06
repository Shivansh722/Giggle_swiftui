import Foundation

@MainActor //@MainActor helps ensure that your RegisterViewModel operates safely with the UI by keeping all updates on the main thread

class RegisterViewModel: ObservableObject {
    private let service: AppService
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var isLoading = false
    @Published var isLoggedIn = false
    
    //@Published:
    
    //ObservableObject protocol, which allows SwiftUI views to observe and react to changes within this class
    
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
