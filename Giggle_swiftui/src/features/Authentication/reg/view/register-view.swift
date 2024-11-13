import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var viewModel: RegisterViewModel
    @Environment(\.dismiss) var dismiss
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
                    .padding(.bottom, 30)

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
                    .padding(.top, 10)

                    HStack(spacing: geometry.size.width * 0.1) {
                        Button(action: {
                            // Google login action
                        }) {
                            Image("google-logo")
                                .resizable()
                                .frame(width: geometry.size.width * 0.2, height: geometry.size.width * 0.2)
                        }
                        Button(action: {
                            // Apple login action
                        }) {
                            Image("apple-logo")
                                .resizable()
                                .frame(width: geometry.size.width * 0.2, height: geometry.size.width * 0.2)
                        }
                    }
                    .padding(.bottom, 20)

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

                NavigationLink(destination: UserDetailView(), isActive: $navigateToUserDetail) {
                    EmptyView()
                }
                .hidden()
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .alert(isPresented: $showPasswordMismatchAlert) {
                Alert(title: Text("Password Mismatch"), message: Text("Passwords do not match. Please try again."), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func registerUser() async {
        await viewModel.createUser(email: email, password: password)
        if viewModel.isLoggedIn {
            navigateToUserDetail = true
        }
    }
}

#Preview {
    RegisterView()
}
