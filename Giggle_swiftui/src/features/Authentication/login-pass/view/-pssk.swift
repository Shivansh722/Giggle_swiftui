import SwiftUI

struct LoginView: View {
    var body: some View {
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
                        }
                        .padding(.leading, 30)
                        
                        Spacer()
                    }
                    .padding(.top, 30)
                    
                    HStack {
                        Image("plane")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 400, height: 450)
                            .padding(.top, -150)
                        
                        Spacer() // Spacer to push the plane to the left edge
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 10) {
                        Image("face-id")
                            .resizable()
                            .frame(width: 156, height: 120)
                            .foregroundColor(Theme.primaryColor)
                            .padding(.top, -180)
                        
                        Text("Giggle Auth")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(Theme.onPrimaryColor)
                            .padding(.top, -60)
                    }
                    .padding(.bottom, 40)
                    
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
