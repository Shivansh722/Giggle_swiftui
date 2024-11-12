import SwiftUI

struct LoginSimpleView: View {
    @EnvironmentObject var viewModel: RegisterViewModel
   
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isValidEmail = true
    @State private var isValidPassword = true
    @State private var navigateToNextScreen = false // Navigation trigger

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
                                        try await viewModel.login(email: email, password: password)
                                        if viewModel.isLoggedIn {
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

                        // Divider
                        HStack {
                                           Divider()
                                               .frame(width: 110, height: 1)
                                               .background(Color.gray)
                                               .padding(.leading, 30)

                                           Text("OR")
                                               .foregroundColor(Color.gray)

                                           Divider()
                                               .frame(width: 110, height: 1)
                                               .background(Color.gray)
                                               .padding(.trailing, 30)
                                       }
                                       .padding(.vertical, 20)
                                       .padding(.top, 25)

                        // Google and Apple login options
                        HStack(spacing: geometry.size.width * 0.1) {
                            Image("google-logo")
                                .resizable()
                                .frame(width: geometry.size.width * 0.2, height: geometry.size.width * 0.2)
                            Image("apple-logo")
                                .resizable()
                                .frame(width: geometry.size.width * 0.2, height: geometry.size.width * 0.2)
                        }
                        .padding(.top, 10)
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

                    NavigationLink(
                        destination: HomeView(), // Replace with the actual next screen view
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
}

