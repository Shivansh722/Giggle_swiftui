import SwiftUI
import WebKit

struct skillView: View {
    @StateObject private var viewModel = PreferenceViewModel()
    @State private var skillName = ""
    @State private var navigateToHome = false
    let userDetailAutoView = UserDetailAutoView()
    @StateObject var saveUserInfo = SaveUserInfo(appService: AppService())
    
    var body: some View {
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
                            .padding(.leading, 30)
                        }
                        Spacer()
                    }
                    .padding(.top, 20)
                    
                    ProgressView(value: 100, total: 100)
                        .accentColor(Theme.primaryColor)
                        .padding(.horizontal, 30)
                        .padding(.top, 20)
                    
                    // Animation
                    WebSkillHomeView(
                        url: Bundle.main.url(forResource: "jobs-list", withExtension: "gif")
                            ?? URL(fileURLWithPath: NSTemporaryDirectory())
                    )
                    .frame(width: 200, height: 200)
                    .padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("What skills do you have?")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Theme.onPrimaryColor)
                            .padding(.leading, 30)
                        
                        Text("Get noticed for right jobs by adding your skills.")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(Color.gray)
                            .padding(.leading, 30)
                        
                        ChipContainerView(viewModel: viewModel)
                            .frame(minHeight: 100)
                            .padding(.horizontal, 30)
                            .padding(.bottom, 20)
                            .padding(.top, 25)
                        
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
                        .padding(.horizontal, 30)
                        .padding(.top, 45)
                        Spacer()
                        
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
                                        userDetailAutoView.deleteAllUserDefaults()
                                        let userDefault = UserDefaults.standard
                                        userDefault.set(FormManager.shared.formData.userId, forKey: "userID")
                                        userDefault.set("completed user", forKey: "status")
                                        let status = UserDefaults.standard.string(forKey: "status")
                                        print(status!)
                                        navigateToHome = true
                                    } else {
                                        print("Failed to save user info")
                                    }
                                }
                            },
                            width: 320,
                            height: 50,
                            cornerRadius: 6
                        )
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                    }
                    .padding(.top, 20)
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
