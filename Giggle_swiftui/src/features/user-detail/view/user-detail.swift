import SwiftUI

struct UserDetailView: View {
    @State private var navigateToUserInfo = false // State variable for navigation
    @State private var navigateToUserDetailAuto = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    Theme.backgroundColor
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 5) {
                                HStack {
                                    Text("User")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(Theme.primaryColor)
                                    
                                    Text("Details")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(Theme.onPrimaryColor)
                                }
                            }
                            .padding(.leading, geometry.size.width * 0.1)
                            
                            Spacer()
                        }
                        
                        Spacer()
                        
                        VStack(spacing: 16) {
                            SectionTitleView(title: "Fill Manually", color: .yellow)
                                .padding(.leading, geometry.size.width * -0.4)
                                .padding(.top, 30)
                            
                            HStack(alignment: .center) {
                                Image(systemName: "pencil.and.list.clipboard")
                                    .font(.system(size: 60))
                                    .foregroundColor(.gray)
                                    .padding(.leading, 20)
                                
                                Text("Take control of your job search with manual entry.")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(Theme.tertiaryColor)
                                    .padding(.leading, 10)
                            }
                            
                            // NavigationLink controlled by `navigateToUserInfo`
                            NavigationLink(
                                destination: UserInfoView(),
                                isActive: $navigateToUserInfo // Binding to navigate
                            ) {
                                EmptyView()
                            }
                            
                            CustomButton(title: "FILL MANUALLY", backgroundColor: Theme.primaryColor, action: {
                                navigateToUserInfo = true // Set to true to trigger navigation
                                UserPreference.shared.shouldLoadUserDetailsAutomatically = false
                            }, width: geometry.size.width * 0.6, height: 50, cornerRadius: 6)
                            .padding(.horizontal, 45)
                            .padding(.top, 20)
                            
                            HStack {
                                Divider()
                                    .frame(width: geometry.size.width * 0.3, height: 1)
                                    .background(Color.gray)
                                    .padding(.leading, 20)

                                Text("OR")
                                    .foregroundColor(Color.gray)
                                    .frame(width: geometry.size.width * 0.1)

                                Divider()
                                    .frame(width: geometry.size.width * 0.3, height: 1)
                                    .background(Color.gray)
                                    .padding(.trailing, 20)
                            }
                            .padding(.top, geometry.size.height * -0.05)
                            
                            Spacer()
                            
                            SectionTitleView(title: "Fill Automatically", color: .yellow)
                                .padding(.leading, geometry.size.width * -0.3)
                            
                            HStack(alignment: .center) {
                                Image(systemName: "photo.badge.plus")
                                    .font(.system(size: 60))
                                    .foregroundColor(.gray)
                                    .padding(.leading, 20)
                                
                                Text("Giggle AI will extract your personal details from your resume, college ID, or any other document containing your information.")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(Theme.tertiaryColor)
                                    .padding(.leading, 10)
                            }
                            
                            NavigationLink(
                                destination: ResumeUpload(),
                                isActive: $navigateToUserDetailAuto // Binding to navigate
                            ) {
                                EmptyView()
                            }
                            CustomButton(title: "FILL AUTOMATICALLY", backgroundColor: Theme.primaryColor, action: {
                                navigateToUserDetailAuto = true
                                UserPreference.shared.shouldLoadUserDetailsAutomatically = true
                            }, width: geometry.size.width * 0.6, height: 50, cornerRadius: 6)
                            .padding(.horizontal, 45)
                            .padding(.top, 20)
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 20)
                }
            }
           
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: EmptyView())
    }
}

#Preview {
    UserDetailView()
}
