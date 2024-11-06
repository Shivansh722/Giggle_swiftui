import SwiftUI
import Appwrite

struct RegisterView: View {
    @EnvironmentObject var viewModel: ViewModel // Only use EnvironmentObject here
    @Environment(\.dismiss) var dismiss
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var navigateToUserDetail: Bool = false
    @State private var showPasswordMismatchAlert: Bool = false

    var body: some View {
        ZStack {
            Theme.backgroundColor
                .edgesIgnoringSafeArea(.all)

            VStack {
                HStack {
                    Text("Welcome")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.primaryColor)
                        .padding(.leading, 30)
                        .padding(.top, 20)
                    Spacer()
                }

                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 150)
                    .padding(.bottom, 30)

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
                    width: 340,
                    height: 50,
                    cornerRadius: 6
                )
                .padding(.top, 20)
                .alert(isPresented: $showPasswordMismatchAlert) {
                    Alert(title: Text("Error"), message: Text("Passwords do not match"), dismissButton: .default(Text("OK")))
                }
                .alert(viewModel.alertMessage, isPresented: $viewModel.showAlert) {
                    Button("OK", role: .cancel) { }
                }

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

                HStack(spacing: 30) {
                    Button(action: {
                        // Google login action
                    }) {
                        Image("google-logo")
                            .resizable()
                            .frame(width: 81, height: 75)
                    }

                    Button(action: {
                        // Apple login action
                    }) {
                        Image("apple-logo")
                            .resizable()
                            .frame(width: 81, height: 75)
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
    }

    private func registerUser() async {
        await viewModel.createUser(email: email, password: password)
        if viewModel.isLoggedIn {
            navigateToUserDetail = true
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
            .environmentObject(ViewModel(service: AppService()))
    }
}
