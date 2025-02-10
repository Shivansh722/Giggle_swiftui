import SwiftUI
import UniformTypeIdentifiers

struct user_detail_auto: View {
    @State private var showPreview = false
    @State private var navigateToUserInfo = false
    let userDetailAutoView = UserDetailAutoView()
    let image = UIImage(named: "FullResume")

    var body: some View {
            GeometryReader { geometry in
                ZStack {
                    Theme.backgroundColor
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        HStack {
                            Text("Upload")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.primaryColor)
                            
                            Text("Resume")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.onPrimaryColor)
                        }
                        .padding(.bottom, 450)
                        
                        Button(action: {
                            showPreview.toggle()
                        }) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                                .padding()
                        }
                        .padding(.bottom, 60)
                        
                        NavigationLink(destination: UserInfoView(), isActive: $navigateToUserInfo) {
                            EmptyView()
                        }
                        
                        CustomButton(title: "NEXT", backgroundColor: Theme.primaryColor, action: {
                            if let image = image {
                                Task {
                                    // Extract text from the image
                                    let extractedText = await userDetailAutoView.extractText(from: image)
                                    
                                    if extractedText.isEmpty {
                                        print("Error: No text extracted from image")
                                        return
                                    }

                                    // Generate text using the extracted text
//                                    let generatedText = await userDetailAutoView.generateTextForPrompt(promptText: extractedText)
//                                    print("Generated Text from Gemini: \(generatedText)")
                                    
                                    // Store the generated text directly in UserDefaults
//                                    userDetailAutoView.storeResumeToUserDefaults(jsonString: generatedText)
                                    userDetailAutoView.deleteAllUserDefaults()
                                    
                                    // Navigate to the next screen
                                    navigateToUserInfo = true
                                }
                            } else {
                                print("Error: Image not found")
                            }
                        }, width: geometry.size.width * 0.75, height: 50, cornerRadius: 6)

                    }
                    .padding()

                    if showPreview {
                        VStack {
                            Image("testing screen")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.4)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                            
                            Button(action: {
                                showPreview = false
                            }) {
                                Text("Close Preview")
                                    .fontWeight(.bold)
                                    .padding()
                                    .background(Theme.primaryColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                        .padding(.top, -200)
                        .transition(.scale)
                    }
                }
            }
    }
}

#Preview {
    user_detail_auto()
}
