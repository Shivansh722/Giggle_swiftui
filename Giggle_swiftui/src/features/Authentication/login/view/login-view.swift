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
                                .padding(.leading, geometry.size.width * -0.08)

                                Image("plane")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geometry.size.width * 1, height: geometry.size.height * 0.6)
                                    .padding(.top, -geometry.size.height * 0.28)
                                Image("logo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geometry.size.width * 0.4, height: geometry.size.height * 0.2)
                                    .padding(.top, -geometry.size.height * 0.15)
                                    .padding(.leading, geometry.size.width * 0.3)
                            }
                            .padding(.leading, geometry.size.width * 0.08)
                            Spacer()
                        }
                        .padding(.top, geometry.size.height * 0.02)

                        CustomTextField(placeholder: "Email", isSecure: false, text: $email, icon: "envelope")
                            .padding(.bottom, 12)

                        CustomTextField(placeholder: "Password", isSecure: true, text: $password, icon: "lock")
                            .padding(.bottom, 20)

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
                            width: geometry.size.width * 0.8,
                            height: 50,
                            cornerRadius: 6
                        )
                        .disabled(viewModel.isLoading) // Disable button when loading
                        .padding(.top, 20)
                        
                        Divider().padding(.horizontal, geometry.size.width * 0.1)

                        HStack(spacing: geometry.size.width * 0.1) {
                            Image("google-logo")
                                .resizable()
                                .frame(width: geometry.size.width * 0.2, height: geometry.size.width * 0.2)
                            Image("apple-logo")
                                .resizable()
                                .frame(width: geometry.size.width * 0.2, height: geometry.size.width * 0.2)
                        }
                        .padding(.top, 20)

                        Spacer()

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
