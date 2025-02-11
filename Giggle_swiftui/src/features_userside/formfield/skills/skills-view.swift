import SwiftUI

struct skillView: View {
    @StateObject private var viewModel = PreferenceViewModel() // Initialize ViewModel
    @State private var skillName = ""
    @State private var navigateToHome = false
    let userDetailAutoView = UserDetailAutoView()
    @StateObject var saveUserInfo = SaveUserInfo(appService: AppService())
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Theme.backgroundColor
                    .edgesIgnoringSafeArea(.all) // Ensure full-screen white background
                
                VStack {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Your")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Theme.primaryColor)
                                Text("Skills")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Theme.onPrimaryColor)
                            }
                            .padding(.leading, geometry.size.width * 0.08)
                        }
                        Spacer()
                    }
                    .padding(.top, geometry.size.height * 0.02)
                    
                    Spacer()
                    
                    VStack {
                        // Replace with a placeholder for debugging if needed
                        
                        Text("What skills do you have?")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Theme.onPrimaryColor)
                        
                        Text("Get noticed for right jobs by adding your skills.")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(Theme.onPrimaryColor)
                        
                        
                        ChipContainerView(viewModel: viewModel)
                            .padding()
                        
                        Text("Add skills ?")
                            .font(.callout)
                            .fontWeight(.medium)
                            .foregroundColor(Theme.onPrimaryColor)
                            .padding(.top, geometry.size.height * -0.6)
                        
                        
                    }
                    .padding(.top, geometry.size.height * 0.08) // Added leading dot
                }
                
                CustomTextField(
                    placeholder: "Your Skill",
                    isSecure: false,
                    text: $skillName,
                    icon: "star.fill"
                )
                
                NavigationLink(destination: HomeView(), isActive: $navigateToHome) {
                    EmptyView()
                }
                
                CustomButton(
                    title: "NEXT",
                    backgroundColor: Theme.primaryColor,
                    action:{
                        Task {
                            let result = await saveUserInfo.saveInfo()
                            if result {
                                navigateToHome = true
                                userDetailAutoView.deleteAllUserDefaults()
                                let userDefault = UserDefaults.standard
                                userDefault.set(FormManager.shared.formData.userId, forKey: "userID")
                            } else {
                                print("Failed to save user info")
                            }
                        }
                        
                    },
                    width: geometry.size.width * 0.8,
                    height: 50
                )
                .padding(.top, 700)
                .padding(.leading, geometry.size.width * -0.06)
                .padding(.horizontal, geometry.size.width * 0.08)
                
                
                
                
                ProgressView(value: 40, total: 100)
                    .accentColor(Theme.primaryColor)
                    .padding(.horizontal, geometry.size.width * 0.08)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 12) // Adjust position
            }
        }.navigationBarHidden(true)
    }
}

private func dumpToDB(){
    @ObservedObject var formManager = FormManager.shared
    print(formManager.formData.degreeName)
}

#Preview {
    skillView()
}

// Ensure Theme and ChipContainerView are defined properly.
