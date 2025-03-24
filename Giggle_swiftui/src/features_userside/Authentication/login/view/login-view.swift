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
    
    // Add FocusState to manage keyboard focus
    @FocusState private var focusedField: Field?
    enum Field {
        case email, password
    }

    var body: some View {
        GeometryReader { geometry in
            NavigationView {
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
                            .padding(.top, -geometry.size.height * 0.20)

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
                                    guard !viewModel.isLoading else { return }
                                    do {
                                        try await viewModel.login(email: email, password: password)
                                        if viewModel.isLoggedIn {
                                            let userExists = try await SaveUserInfo(appService: AppService()).checkForUserExistence()
                                            if userExists {
                                                UserDefaults.standard.set("completed user", forKey: "status")
                                                destinationView = AnyView(HomeView())
                                            } else {
                                                UserDefaults.standard.set("completed client", forKey: "status")
                                                let clientExists = try await ClientHandlerUserInfo(appService: AppService()).checkForCleintExixtence()
                                                destinationView = clientExists ? AnyView(HomeClientView()) : AnyView(ChooseView())
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
                    navigateToNextScreen = false // Reset navigation state
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    LoginSimpleView().environmentObject(RegisterViewModel(service: AppService()))
}
