import SwiftUI
import WebKit

struct skillView: View {
    @StateObject private var viewModel = PreferenceViewModel()
    @State private var skillName = ""
    @State private var navigateToHome = false
    let userDetailAutoView = UserDetailAutoView()
    @StateObject var saveUserInfo = SaveUserInfo(appService: AppService())
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Theme.backgroundColor
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack {
                        // Header
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
                        
                        ProgressView(value: 40, total: 100)
                            .accentColor(Theme.primaryColor)
                            .padding(.horizontal, geometry.size.width * 0.08)
                            .padding(.top, geometry.size.height * 0.02)
                        
                        // Animation
                        WebSkillHomeView(
                            url: Bundle.main.url(forResource: "skill-animate", withExtension: "gif")
                                ?? URL(fileURLWithPath: NSTemporaryDirectory())
                        )
                        .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.3)
                        .padding(.top, 20)
                        
                        VStack(alignment: .leading, spacing: 20) {
                            Text("What skills do you have?")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.onPrimaryColor)
                                .padding(.leading, geometry.size.width * 0.08)
                            
                            Text("Get noticed for right jobs by adding your skills.")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(Theme.onPrimaryColor)
                                .padding(.leading, geometry.size.width * 0.08)
                            
                            ChipContainerView(viewModel: viewModel)
                                .frame(minHeight: 100)
                                .padding(.horizontal, geometry.size.width * 0.08)
                                .padding(.bottom, 20) // Added padding below chips
                            
                            // Custom Skill Input
                            HStack {
                                CustomTextField(
                                    placeholder: "Add a skill",
                                    isSecure: false,
                                    text: $skillName,
                                    icon: "star.fill"
                                )
                                
                                Button(action: {
                                    addCustomSkill()
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(Theme.primaryColor)
                                        .font(.system(size: 24))
                                }
                                .disabled(skillName.trimmingCharacters(in: .whitespaces).isEmpty)
                            }
                            .padding(.horizontal, geometry.size.width * 0.08)
                            .padding(.top, 20)
                            
                            NavigationLink(destination: HomeView(), isActive: $navigateToHome) {
                                EmptyView()
                            }
                            
                            CustomButton(
                                title: "NEXT",
                                backgroundColor: Theme.primaryColor,
                                action: {
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
                            .padding(.top, 20)    // Added padding above button
                            .padding(.bottom, 40) // Increased bottom padding
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private func addCustomSkill() {
        let trimmedSkill = skillName.trimmingCharacters(in: .whitespaces)
        if !trimmedSkill.isEmpty {
            if !viewModel.PreferenceArray.contains(where: { $0.title.lowercased() == trimmedSkill.lowercased() }) {
                viewModel.PreferenceArray.append(
                    PreferenceViewModel.PreferenceModel(isSelected: true, title: trimmedSkill)
                )
            }
            skillName = ""
        }
    }
}

struct WebSkillHomeView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.isOpaque = false
        webView.backgroundColor = .clear
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

#Preview {
    skillView()
}
