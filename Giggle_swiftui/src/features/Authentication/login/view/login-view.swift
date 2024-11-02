import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false

    var body: some View {
        ZStack {
            Theme.backgroundColor
                .edgesIgnoringSafeArea(.all)

            VStack {
                // Welcome text aligned to the top left
                HStack {
                    Text("Welcome")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.primaryColor)
                        .padding(.leading, 30)
                        .padding(.top, 20)
                    Spacer()
                }

                // Logo centered below the welcome text
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 150)
                    .padding(.bottom, 30)

                // Email TextField
                CustomTextField(placeholder: "Email", isSecure: false, text: $email, icon: "envelope")
                
                // Password TextField with visibility toggle
                CustomTextField(placeholder: "Password", isSecure: true, text: $password, icon: "lock")
                    
                // Sign Up button using CustomButton
                CustomButton(
                    title: "SIGN UP",
                    backgroundColor: Theme.primaryColor,
                    action: {
                        // sign up action
                    },
                    width: 260,
                    height: 50,
                    cornerRadius: 12
                )
                .padding(.top, 20)

                // Divider with OR text
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

                // Social media login buttons (Google and Apple)
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

                // Already a member? Login text
                HStack {
                    Text("Already a member?")
                        .foregroundColor(Color.gray)

                    Button(action: {
                        // Login action
                    }) {
                        Text("Login")
                            .foregroundColor(Theme.primaryColor)
                    }
                }
                .padding(.bottom, 20)
            }
        }
        .navigationBarBackButtonHidden(true) // Ensures the back button is hidden
        .navigationBarHidden(true)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
