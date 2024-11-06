//
//  register-viewModel.swift
//  Giggle_swiftui
//
//  Created by user@91 on 05/11/24.
//
//
//import Appwrite
//
//struct Giggle_swiftuiTests {
//    init(){}
//    let client = Client().setProject("6729f0c60023e865f840")
//}
import Foundation

class ViewModel: ObservableObject {
    private let service: AppService
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var hasError = false
    @Published var isLoading = false
    @Published var isLoggedIn = false
    
    init(service: AppService) {
        self.service = service
    }
    
    func createUser(email: String, password: String) async throws {
        
        isLoading = true
        let status = try await service.createUser(email: email, password: password)
        
        switch status {
        case .success:
            isLoggedIn = true
            alertMessage = "User created successfully"
            showAlert.toggle()
            
        case .error(let message):
            isLoading = false
            hasError = true
            alertMessage = message
            showAlert.toggle()
        }
    }
}
