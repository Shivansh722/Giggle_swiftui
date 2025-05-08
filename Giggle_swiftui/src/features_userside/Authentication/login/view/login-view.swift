import SwiftUI
import AuthenticationServices

struct LoginSimpleView: View {
    @EnvironmentObject var viewModel: RegisterViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isValidEmail = true
    @State private var isValidPassword = true
    @State private var navigateToNextScreen = false
    @State private var destinationView: AnyView?
    @State private var isVisible = false
    
    // Add FocusState to manage keyboard focus
    @FocusState private var focusedField: Field?
    enum Field {
        case email, password
    }

    var body: some View {
            ZStack {
                Theme.backgroundColor
                    .edgesIgnoringSafeArea(.all)

                // Main content that adjusts with keyboard
                VStack {
                    // Welcome back text
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text("Welcome")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Theme.primaryColor)
                                   
                                Text("Back!")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Theme.onPrimaryColor)
                            }
                            .offset(x: isVisible ? 0 : -UIScreen.main.bounds.width) // Start off-screen to the left
                            .animation(.easeInOut(duration: 0.8), value: isVisible) // Smooth animation
                            .padding(.leading, UIScreen.main.bounds.width * 0.08)
                        }
                        Spacer()
                    }
                    .padding(.top, 20)
                    .onAppear {
                        isVisible = true // Trigger animation on view appearance
                    }

                    // Plane image
                    Image("plane")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.3)
                        .padding(.top, -20)

                    // Logo image
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.1)
                        .padding(.top, -20)

                    // Email and password text fields
                    CustomTextField(
                        placeholder: "Email",
                        isSecure: false,
                        text: $email,
                        icon: "envelope"
                    )
                    .focused($focusedField, equals: .email)
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = .password
                    }
                    .padding(.bottom, 12)

                    CustomTextField(
                        placeholder: "Password",
                        isSecure: true,
                        text: $password,
                        icon: "lock"
                    )
                    .focused($focusedField, equals: .password)
                    .submitLabel(.go)
                    .onSubmit {
                        focusedField = nil // Dismiss keyboard on "Go"
                    }
                    .padding(.bottom, 20)

                    // Sign-in button
                    CustomButton(
                        title: "SIGN IN",
                        backgroundColor: Theme.primaryColor,
                        action: {
                            Task {
                                do {
                                    // Reset navigation state
                                    destinationView = nil
                                    navigateToNextScreen = false
                                    
                                    // Perform login
                                    try await viewModel.login(email: email, password: password)
                                    if viewModel.isLoggedIn {
                                        let userExists = try await SaveUserInfo(appService: AppService()).checkForUserExistence()
                                        print("User exists: \(userExists)")
                                        
                                        if userExists {
                                            UserDefaults.standard.set("completed user", forKey: "status")
                                            destinationView = AnyView(HomeView())
                                            navigateToNextScreen = true
                                        } else {
                                            let clientExists = try await ClientHandlerUserInfo(appService: AppService()).checkForCleintExixtence() // Fixed typo
                                            print("Client exists: \(clientExists)")
                                            
                                            if clientExists {
                                                UserDefaults.standard.set("completed client", forKey: "status")
                                                destinationView = AnyView(HomeClientView())
                                            } else {
                                                destinationView = AnyView(ChooseView())
                                            }
                                            navigateToNextScreen = true
                                        }
                                        print("Destination view: \(destinationView)")
                                        print("UserDefaults status: \(UserDefaults.standard.string(forKey: "status") ?? "none")")
                                    }
                                } catch {
                                    viewModel.alertMessage = "Login failed. Please try again."
                                    viewModel.showAlert = true
                                }
                            }
                        },
                        width: UIScreen.main.bounds.width * 0.6,
                        height: 50,
                        cornerRadius: 6
                    )
                    .disabled(viewModel.isLoading)
                    .padding(.top, -10)
                    .padding(.horizontal, 50)
                    .padding(.bottom, 10)

                    Spacer() // Pushes content up, but won't affect bottom HStack
                }
                .padding(.horizontal, 20)

                // "Not a member?" stuck at the bottom
                VStack {
                    Spacer() // Pushes the HStack to the bottom
                    HStack {
                        Text("Not a member?")
                            .foregroundColor(Theme.onPrimaryColor)
                        NavigationLink(destination: RegisterView()) {
                            Text("Register Now")
                                .foregroundColor(Theme.primaryColor)
                                .fontWeight(.bold)
                        }
                    }
                    .padding(.bottom, 30)
                }
                .ignoresSafeArea(.keyboard)

                // Dynamic NavigationLink
                NavigationLink(
                    destination: destinationView,
                    isActive: $navigateToNextScreen
                ) {
                    EmptyView()
                }
                .hidden()
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text(viewModel.alertMessage == "User created successfully!" ? "Success" : "Error"),
                    message: Text(viewModel.alertMessage),
                    dismissButton: .default(Text("OK")) {
                        viewModel.showAlert = false // Reset alert after dismissal
                    }
                )
            }
            .onTapGesture {
                focusedField = nil // Dismiss keyboard on tap anywhere
            }
            .onAppear {
                // Reset alert state when the view appears
                viewModel.showAlert = false
                viewModel.alertMessage = ""
            }
        .navigationBarHidden(true)
    }
}

#Preview {
    LoginSimpleView().environmentObject(RegisterViewModel(service: AppService()))
}
