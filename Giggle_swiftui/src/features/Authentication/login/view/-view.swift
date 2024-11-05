import SwiftUI

struct LoginSimpleView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.backgroundColor
                    .edgesIgnoringSafeArea(.all)
                
                VStack() {
                    // Welcome Back Text
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
                            // Plane Image below Welcome Back
                            Image("plane")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 400, height: 450) // Adjust width and height as needed
                                .padding(.top, -140) // Adjust spacing as desired
                            Image("logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 160, height: 140)
                                .padding(.top, -150)
                                .padding(.leading, 110)
                        }
                        .padding(.leading, 30)
                        
                        Spacer()
                    }
                    .padding(.top, 20)
                    
                    // Email and Password Fields
                    CustomTextField(placeholder: "Email", isSecure: false, text: $email, icon: "envelope")
                        .padding(.bottom, 12)
                        
                    
                    CustomTextField(placeholder: "Password", isSecure: true, text: $password, icon: "lock")
                        .padding(.bottom, 20)
                    
                    // Sign In Button
                    CustomButton(
                        title: "SIGN IN",
                        backgroundColor: Theme.primaryColor,
                        action: {
                            // Sign in action
                        },
                        width: 340,
                        height: 50,
                        cornerRadius: 6
                    )
                    .padding(.top, 20)

                    // Divider with OR text
                    HStack {
                        Divider()
                            .frame(width: 110, height: 1)
                            .background(Color.gray)

                        Text("OR")
                            .foregroundColor(Color.gray)

                        Divider()
                            .frame(width: 110, height: 1)
                            .background(Color.gray)
                    }
                    .padding(.vertical, 20)

                    // Social Login Icons
                    HStack(spacing: 40) {
                        Image("google-logo")
                            .resizable()
                            .frame(width: 81, height: 75)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        Image("apple-logo")
                            .resizable()
                            .frame(width: 81, height: 75)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding(.top, 20)

                    Spacer()

                    // Bottom registration link
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
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    LoginSimpleView()
}
