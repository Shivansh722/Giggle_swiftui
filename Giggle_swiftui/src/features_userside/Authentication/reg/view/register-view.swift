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
    @State private var emailError: String? = nil
    @State private var passwordError: String? = nil
    @State private var isVisible: Bool = false
    
    // Add FocusState to manage keyboard focus
    @FocusState private var focusedField: Field?
    enum Field {
        case email, password, confirmPassword
    }
    
    // Computed property to check if form is valid
    private var isFormValid: Bool {
        emailError == nil && passwordError == nil && !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty && password == confirmPassword
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Theme.backgroundColor
                    .edgesIgnoringSafeArea(.all)

                ScrollView {
                    VStack {
                        HStack {
                            Text("Welcome")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.primaryColor)
                                .padding(.leading, geometry.size.width * 0.08)
                                .padding(.top, geometry.size.height * 0.02)
                                .offset(x: isVisible ? 0 : -UIScreen.main.bounds.width) // Start off-screen to the left
                                                .animation(.easeInOut(duration: 0.8), value: isVisible)
                            Spacer()
                        }
                        .onAppear {
                            isVisible = true // Trigger animation on view appearance
                        }

                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.6, height: geometry.size.height * 0.2)
                            .padding(.bottom, geometry.size.height * 0.05)

                        CustomTextField(
                            placeholder: "Email",
                            isSecure: false,
                            text: $email,
                            icon: "envelope",
                            errorMessage: emailError
                        )
                        .focused($focusedField, equals: .email)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .password
                        }
                        .onChange(of: email) { newValue in
                            validateEmail(newValue)
                        }
                        .padding(.bottom, 12)

                        CustomTextField(
                            placeholder: "Password",
                            isSecure: true,
                            text: $password,
                            icon: "lock",
                            errorMessage: passwordError
                        )
                        .focused($focusedField, equals: .password)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .confirmPassword
                        }
                        .onChange(of: password) { newValue in
                            validatePassword(newValue)
                        }
                        .padding(.bottom, 12)

                        CustomTextField(
                            placeholder: "Confirm Password",
                            isSecure: true,
                            text: $confirmPassword,
                            icon: "lock",
                            errorMessage: nil
                        )
                        .focused($focusedField, equals: .confirmPassword)
                        .submitLabel(.go)
                        .onSubmit {
                            focusedField = nil // Dismiss keyboard only
                        }
                        .padding(.bottom, 20)

                        CustomButton(
                            title: "SIGN UP",
                            backgroundColor: Theme.primaryColor,
                            action: {
                                // Force validation checks
                                validateEmail(email)
                                validatePassword(password)
                                
                                if password != confirmPassword {
                                    showPasswordMismatchAlert = true
                                } else if isFormValid {
                                    Task {
                                        await registerUser()
//                                        if viewModel.isLoggedIn {
                                            navigateToUserDetail = true
//                                        }
                                    }
                                }
                            },
                            width: geometry.size.width * 0.8,
                            height: 50,
                            cornerRadius: 6
                        )
                        .allowsHitTesting(true)
                        .padding(.top, 16)
                        .padding(.bottom, 50)

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
                        VStack {
                            Text("By signing up, you agree to our")
                                .foregroundColor(Color.gray)
                                .font(.footnote)
                            Button(action: {
                                if let url = URL(string: "https://www.mygiggle.tech/privacy") {
                                    UIApplication.shared.open(url)
                                }
                            }) {
                                Text("Terms & Privacy Policy")
                                    .foregroundColor(Color.gray)
                                    .font(.footnote)
                                    .underline()
                                    .fontWeight(.bold)
                            }
                            .padding(.bottom, 30)
                        }
                    }
                    .frame(minHeight: geometry.size.height)
                }
                .scrollDismissesKeyboard(.interactively)

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
            .alert(isPresented: $showPasswordMismatchAlert) {
                Alert(title: Text("Password Mismatch"), message: Text("Passwords do not match. Please try again."), dismissButton: .default(Text("OK")))
            }
            .onTapGesture {
                focusedField = nil
            }
            .onAppear {
                viewModel.setOpenURLAction(openURL)
            }
        }
    }

    private func validateEmail(_ email: String) {
        if email.isEmpty {
            emailError = "Email cannot be empty"
        } else if !email.contains("@") {
            emailError = "Email must contain '@'"
        } else {
            emailError = nil
        }
    }

    private func validatePassword(_ password: String) {
        if password.isEmpty {
            passwordError = "Password cannot be empty"
        } else {
            let hasUppercase = password.rangeOfCharacter(from: .uppercaseLetters) != nil
            let hasLowercase = password.rangeOfCharacter(from: .lowercaseLetters) != nil
            let hasNumber = password.rangeOfCharacter(from: .decimalDigits) != nil
            let symbolSet = CharacterSet(charactersIn: "!@#$%^&*()_+-=[]{}|;:,.<>?~`")
            let hasSymbol = password.rangeOfCharacter(from: symbolSet) != nil
            let passsize = password.count >= 8
            
            if !(hasUppercase && hasLowercase && hasNumber && hasSymbol && passsize) {
                passwordError = "Password must include uppercase, lowercase, number, and symbol and must have 8 characters or more"
            } else {
                passwordError = nil
            }
        }
    }

    private func registerUser() async {
        print("Starting registration with email: \(email), password: \(password)") // Debug
        await viewModel.createUser(email: email, password: password)
        print("Registration complete, isLoggedIn: \(viewModel.isLoggedIn)") // Debug
        passwordError = viewModel.alertMessage
    }
}

// Rest of the code (AppleSignInDelegate) remains unchanged

#Preview {
    RegisterView()
}
