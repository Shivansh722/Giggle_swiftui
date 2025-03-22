import SwiftUI
import AuthenticationServices

struct RegisterView: View {
    @EnvironmentObject var viewModel: RegisterViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) private var openURL
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var navigateToUserDetail: Bool = false
    @State private var showPasswordMismatchAlert: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Theme.backgroundColor
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    HStack {
                        Text("Welcome")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Theme.primaryColor)
                            .padding(.leading, geometry.size.width * 0.08)
                            .padding(.top, geometry.size.height * 0.02)
                        Spacer()
                    }

                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width * 0.6, height: geometry.size.height * 0.2)
                        .padding(.bottom, geometry.size.height * 0.05)

                    CustomTextField(placeholder: "Email", isSecure: false, text: $email, icon: "envelope")
                        .padding(.bottom, 12)

                    CustomTextField(placeholder: "Password", isSecure: true, text: $password, icon: "lock")
                        .padding(.bottom, 12)

                    CustomTextField(placeholder: "Confirm Password", isSecure: true, text: $confirmPassword, icon: "lock")
                        .padding(.bottom, 20)

                    CustomButton(
                        title: "SIGN UP",
                        backgroundColor: Theme.primaryColor,
                        action: {
                            Task {
                                if password == confirmPassword {
                                    await registerUser()
                                    if viewModel.isLoggedIn {
                                        navigateToUserDetail = true
                                        viewModel.isLoggedIn = false
                                    }
                                } else {
                                    showPasswordMismatchAlert = true
                                }
                            }
                        },
                        width: geometry.size.width * 0.8,
                        height: 50,
                        cornerRadius: 6
                    )
                    .padding(.top, 16)
                    .padding(.bottom, 50)
//\*
//                    HStack {
//                        Divider()
//                            .frame(width: 95, height: 1)
//                            .background(Color.gray)
//                            .padding(.leading, 30)
//
//                        Text("OR Sign Up with ")
//                            .foregroundColor(Color.gray)
//
//                        Divider()
//                            .frame(width: 95, height: 1)
//                            .background(Color.gray)
//                            .padding(.trailing, 30)
//                    }
//                    .padding(.bottom, 10)
//                    .padding(.top, 20)
//
//                    HStack(spacing: geometry.size.width * 0.1) {
//                        Button(action: {
//                            handleGoogleSignInButtonTapped()
//                        }) {
//                            Image("google-logo2")
//                                .resizable()
//                                .scaledToFit()
//                                .scaleEffect(1.2)
//                                .frame(width: geometry.size.width * 0.1, height: geometry.size.width * 0.1)
//                                .padding()
//                                .background(Color.white)
//                                .clipShape(RoundedRectangle(cornerRadius: 10))
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 10)
//                                        .stroke(Color.clear, lineWidth: 1)
//                                )
//                        }
//                        .disabled(viewModel.isLoading)
//                        
//                        Button(action: {
//                            handleAppleSignInButtonTapped()
//                        }) {
//                            Image(systemName: "apple.logo")
//                                .resizable()
//                                .scaledToFit()
//                                .foregroundColor(.black)
//                                .frame(width: geometry.size.width * 0.1, height: geometry.size.width * 0.1)
//                                .padding()
//                                .background(Color.white)
//                                .clipShape(RoundedRectangle(cornerRadius: 10))
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 10)
//                                        .stroke(Color.clear, lineWidth: 1)
//                                )
//                        }
//                        .disabled(viewModel.isLoading)
//                        .frame(width: geometry.size.width * 0.2, height: geometry.size.width * 0.2)
//                    }
//                    .padding(.bottom, 20)
//                    */

                    Spacer()

                    HStack {
                        Text("Already a member?")
                            .foregroundColor(Color.gray)

                        NavigationLink(destination: LoginSimpleView()) {
                            Text("Login")
                                .foregroundColor(Theme.primaryColor)
                        }
                    }
                    .padding(.bottom, 20)
                }

                NavigationLink(destination: ChooseView(), isActive: $navigateToUserDetail) {
                    EmptyView()
                }
                .hidden()
                
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(2)
                        .progressViewStyle(CircularProgressViewStyle(tint: Theme.primaryColor))
                        .background(Color.white.opacity(0.3))
                        .frame(width: 100, height: 100)
                        .cornerRadius(10)
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("User Created"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
            .alert(isPresented: $showPasswordMismatchAlert) {
                Alert(title: Text("Password Mismatch"), message: Text("Passwords do not match. Please try again."), dismissButton: .default(Text("OK")))
            }
            .onAppear {
                // Pass the OpenURLAction to the view model
                viewModel.setOpenURLAction(openURL)
            }
        }
    }

    private func registerUser() async {
        await viewModel.createUser(email: email, password: password)
    }
    
    private func handleAppleSignInButtonTapped() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = AppleSignInDelegate(viewModel: viewModel, navigateToUserDetail: $navigateToUserDetail)
        authorizationController.performRequests()
    }
    
    private func handleGoogleSignInButtonTapped() {
        Task {
            await viewModel.signInWithGoogle()
        }
    }
}

class AppleSignInDelegate: NSObject, ASAuthorizationControllerDelegate {
    private let viewModel: RegisterViewModel
    @Binding private var navigateToUserDetail: Bool

    init(viewModel: RegisterViewModel, navigateToUserDetail: Binding<Bool>) {
        self.viewModel = viewModel
        self._navigateToUserDetail = navigateToUserDetail
        super.init()
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            Task {
                await viewModel.signInWithApple(credential: appleIDCredential)
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        Task { @MainActor in
            viewModel.alertMessage = "Apple Sign In failed: \(error.localizedDescription)"
            if let authError = error as? ASAuthorizationError {
                switch authError.code {
                case .canceled:
                    viewModel.alertMessage = "Sign In was canceled"
                case .failed:
                    viewModel.alertMessage = "Sign In failed. Check your configuration"
                case .invalidResponse:
                    viewModel.alertMessage = "Invalid response from Apple"
                case .notHandled:
                    viewModel.alertMessage = "Sign In not handled"
                case .unknown:
                    viewModel.alertMessage = "Unknown error occurred"
                @unknown default:
                    viewModel.alertMessage = "Unexpected error: \(error.localizedDescription)"
                }
            }
            viewModel.showAlert = true
        }
    }
}

#Preview {
    RegisterView()
}

