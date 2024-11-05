import SwiftUI

struct RegisterView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = "" // State for confirm password
    @State private var isPasswordVisible: Bool = false
    @State private var navigateToUserDetail: Bool = false // State to manage navigation
    @State private var showPasswordMismatchAlert: Bool = false // State for alert

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
                
                CustomTextField(placeholder: "Confirm Password", isSecure: true, text: $confirmPassword, icon: "lock") // Confirm password field
                    .padding(.bottom, 20)

                CustomButton(
                    title: "SIGN UP",
                    backgroundColor: Theme.primaryColor,
                    action: {
                        if password == confirmPassword {
                            navigateToUserDetail = true
                        } else {
                            showPasswordMismatchAlert = true
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

                    NavigationLink(destination: LoginView()) {
                        Text("Login")
                            .foregroundColor(Theme.primaryColor)
                    }
                }
                .padding(.bottom, 20)
            }
            
            // NavigationLink to navigate to UserDetailView when navigateToUserDetail is true
            NavigationLink(destination: UserDetailView(), isActive: $navigateToUserDetail) {
                EmptyView()
            }
            .hidden() // Hide the NavigationLink
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
