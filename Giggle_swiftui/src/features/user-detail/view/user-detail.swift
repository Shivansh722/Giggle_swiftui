import SwiftUI

struct UserDetailView: View {
    var body: some View {
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
                    .padding(.leading, 30)
                    
                    Spacer()
                }
                .padding(.top, 20)
                
                Spacer()
                
                VStack(spacing: 16) {
                    // First Section: Fill Manually
                    SectionTitleView(title: "Fill Manually", color: .yellow)
                        .padding(.leading, -170)
                    
                    HStack(alignment: .center) {
                        userCardCustomView(imageName: "clipboard.icon", title: "Fill Form")
                            .padding(.leading, 20)
                        
                        Text("Take control of your job search with manual entry.")
                            .font(.caption)
                            .foregroundColor(Theme.tertiaryColor)
                            .padding(.leading, 10)
                    }
                    
                    CustomButton(title: "FILL MANUALLY", backgroundColor: .red, action: {
                        // Action for Fill Manually button
                    }, width: 320, height: 50)
                    .padding(.horizontal, 20)
                    
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
                    
                    // Second Section: Fill Automatically
                    SectionTitleView(title: "Fill Automatically", color: .yellow)
                        .padding(.leading, -120)
                    
                    HStack(alignment: .center) {
                        userCardCustomView(imageName: "photo.icon", title: "Upload Resume")
                            .padding(.leading, 20)
                        
                        Text("Giggle AI will extract your personal details from your resume, college ID, or any other document containing your information.")
                            .font(.caption)
                            .foregroundColor(Theme.tertiaryColor)
                            .padding(.leading, 10)
                    }
                    
                    CustomButton(title: "FILL AUTOMATICALLY", backgroundColor: .red, action: {
                        // Action for Fill Automatically button
                    }, width: 320, height: 50)
                    .padding(.horizontal, 20)
                }
                
                Spacer()
            }
            .padding(.top, 20)
        }
        
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailView()
    }
}
