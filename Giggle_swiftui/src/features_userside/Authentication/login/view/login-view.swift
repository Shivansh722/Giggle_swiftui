import SwiftUI
import AuthenticationServices // Ensure this is imported

struct LoginSimpleView: View {
    @EnvironmentObject var viewModel: RegisterViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isValidEmail = true
    @State private var isValidPassword = true
    @State private var navigateToNextScreen = false // Navigation trigger
    @State private var destinationView: AnyView? // Dynamic destination view

    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ZStack {
                    Theme.backgroundColor
                        .edgesIgnoringSafeArea(.all)

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
                                .padding(.leading, geometry.size.width * 0.08)
                            }
                            Spacer()
                        }
                        .padding(.top, geometry.size.height * 0.02)

                        // Plane image
                        Image("plane")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.6)
                            .padding(.top, geometry.size.height * -0.2)

                        // Logo image
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.4, height: geometry.size.height * 0.2)
                            .padding(.top, -geometry.size.height * 0.20) // Reduced padding to move fields up

                        Spacer()

                        // Email and password text fields
                        CustomTextField(placeholder: "Email", isSecure: false, text: $email, icon: "envelope")
                            .padding(.bottom, 12)

                        CustomTextField(placeholder: "Password", isSecure: true, text: $password, icon: "lock")
                            .padding(.bottom, 20)

                        // Sign-in button
                        CustomButton(
                            title: "SIGN IN",
                            backgroundColor: Theme.primaryColor,
                            action: {
                                Task {
                                    guard !viewModel.isLoading else { return } // Prevent duplicate tasks
                                    do {
                                        // Attempt login first
                                        try await viewModel.login(email: email, password: password)
                                        if viewModel.isLoggedIn {
                                            // Check where the logged-in person belongs
                                            let userExists = try await SaveUserInfo(appService: AppService()).checkForUserExistence()
                                            if userExists {
                                                // User exists, go to HomeView
                                                let userDefault = UserDefaults.standard
                                                userDefault.set("completed user", forKey: "status")
                                                destinationView = AnyView(HomeView())
                                            } else {
                                                let userDefault = UserDefaults.standard
                                                userDefault.set("completed client", forKey: "status")
                                                let clientExists = try await ClientHandlerUserInfo(appService: AppService()).checkForCleintExixtence()
                                                if clientExists {
                                                    // Client exists, go to ClientHomeView
                                                    destinationView = AnyView(HomeClientView())
                                                } else {
                                                    // Neither user nor client exists, go to ChooseView
                                                    destinationView = AnyView(ChooseView())
                                                }
                                            }
                                            navigateToNextScreen = true
                                        }
                                    } catch {
                                        viewModel.alertMessage = "Login failed. Please try again."
                                        viewModel.showAlert = true
                                    }
                                }
                            },
                            width: geometry.size.width * 0.6,
                            height: 50,
                            cornerRadius: 6
                        )
                        .disabled(viewModel.isLoading) // Disable button when loading
                        .padding(.top, -10) // Reduced padding to move button up
                        .padding(.horizontal, 50)
                        .padding(.bottom, 10)

                        // Divider
                        HStack {
                            Divider()
                                .frame(width: 95, height: 1)
                                .background(Color.gray)
                                .padding(.leading, 30)

                            Text("OR Sign In with")
                                .foregroundColor(Color.gray)

                            Divider()
                                .frame(width: 95, height: 1)
                                .background(Color.gray)
                                .padding(.trailing, 30)
                        }
                        .padding(.vertical, 20)
                        .padding(.top, 25)

                        // Google and Apple login options
                        HStack(spacing: geometry.size.width * 0.1) {
                            Button(action: {
                                // Google login action (implement as needed)
                            }) {
                                Image("google-logo2")
                                    .resizable()
                                    .scaledToFit()
                                    .scaleEffect(1.2)
                                    .frame(width: geometry.size.width * 0.1, height: geometry.size.width * 0.1)
                                    .padding()
                                    .background(Color.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.clear, lineWidth: 1)
                                    )
                            }

                            // Custom Apple Sign In Button
                            Button(action: {
                                handleAppleSignInButtonTapped()
                            }) {
                                Image(systemName: "apple.logo")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.black)
                                    .frame(width: geometry.size.width * 0.1, height: geometry.size.width * 0.1)
                                    .padding()
                                    .background(Color.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.black, lineWidth: 2)
                                    )
                            }
                            .frame(width: geometry.size.width * 0.2, height: geometry.size.width * 0.2)
                        }
                        .padding(.bottom, 10)

                        Spacer()

                        // Register text and link
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
                    .padding(.horizontal, 20)

                    // Dynamic NavigationLink
                    NavigationLink(
                        destination: destinationView ?? AnyView(EmptyView()), // Fallback to EmptyView if nil
                        isActive: $navigateToNextScreen
                    ) {
                        EmptyView()
                    }
                    .hidden() // Keep the link hidden, but active when triggered
                }
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(
                        title: Text("Error"),
                        message: Text(viewModel.alertMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
            .navigationBarHidden(true)
        }
    }

    private func handleAppleSignInButtonTapped() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = AppleSignInDelegate(viewModel: viewModel, navigateToUserDetail: $navigateToNextScreen)
        authorizationController.performRequests()
    }
}

#Preview {
    LoginSimpleView()
}
