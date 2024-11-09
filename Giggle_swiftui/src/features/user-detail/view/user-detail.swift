//import SwiftUI
//
//struct UserDetailView: View {
//    var body: some View {
//        ZStack {
//            Theme.backgroundColor
//                .edgesIgnoringSafeArea(.all)
//            
//            VStack {
//                HStack(alignment: .top) {
//                    VStack(alignment: .leading, spacing: 5) {
//                        HStack {
//                            Text("User")
//                                .font(.title)
//                                .fontWeight(.bold)
//                                .foregroundColor(Theme.primaryColor)
//                            
//                            Text("Details")
//                                .font(.title)
//                                .fontWeight(.bold)
//                                .foregroundColor(Theme.onPrimaryColor)
//                        }
//                    }
//                    .padding(.leading, 30)
//                    
//                    Spacer()
//                }
//                
//                
//                Spacer()
//                
//                VStack(spacing: 16) {
//                    // First Section: Fill Manually
//                    SectionTitleView(title: "Fill Manually", color: .yellow)
//                        .padding(.leading, -170)
//                        .padding(.top, 30)
//                    
//                    HStack(alignment: .center) {
//                        Image(systemName: "pencil.and.list.clipboard")
//                            .font(.system(size: 60))
//                            .foregroundColor(.gray)
//                            .padding(.leading, 20)
//                        
//                        Text("Take control of your job search with manual entry.")
//                            .font(.caption)
//                            .foregroundColor(Theme.tertiaryColor)
//                            .padding(.leading, 10)
//                    }
//                    
//                    CustomButton(title: "FILL MANUALLY", backgroundColor: Theme.primaryColor, action: {
//                        // Action for Fill Manually button
//                    }, width: 222, height: 50, cornerRadius: 6)
//                    .padding(.horizontal, 20)
//                    .padding(.top, 20)
//                    
//                   
//                
//                    
//                    HStack {
//                        Divider()
//                            .frame(width: 110, height: 1)
//                            .background(Color.gray)
//                            .padding(.leading, 30)
//
//                        Text("OR")
//                            .foregroundColor(Color.gray)
//
//                        Divider()
//                            .frame(width: 110, height: 1)
//                            .background(Color.gray)
//                            .padding(.trailing, 30)
//                    }
//                    
//                    Spacer()
//                    
//                    // Second Section: Fill Automatically
//                    SectionTitleView(title: "Fill Automatically", color: .yellow)
//                        .padding(.leading, -150)
//                    
//                    HStack(alignment: .center) {
//                        Image(systemName: "photo.badge.plus")
//                            .font(.system(size: 60))
//                            .foregroundColor(.gray)
//                            .padding(.leading, 20)
//                        
//                        Text("Giggle AI will extract your personal details from your resume, college ID, or any other document containing your information.")
//                            .font(.caption)
//                            .foregroundColor(Theme.tertiaryColor)
//                            .padding(.leading, 10)
//                    }
//                    
//                    CustomButton(title: "FILL AUTOMATICALLY", backgroundColor: Theme.primaryColor, action: {
//                        // Action for Fill Automatically button
//                    }, width: 222, height: 50, cornerRadius: 6)
//                    .padding(.horizontal, 20)
//                }
//                
//                Spacer()
//            }
//            .padding(.top, 20)
//        }
//        
//        .navigationBarBackButtonHidden(true)
//        .navigationBarHidden(true)
//    }
//}
//
//#Preview {
//    UserDetailView()
//}

import SwiftUI

struct UserDetailView: View {
    var body: some View {
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
                        .padding(.leading, geometry.size.width * 0.1) // Adjust padding based on screen width
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 16) {
                        // First Section: Fill Manually
                        SectionTitleView(title: "Fill Manually", color: .yellow)
                            .padding(.leading, geometry.size.width * -0.4) // Adjust padding based on screen width
                            .padding(.top, 30)
                        
                        HStack(alignment: .center) {
                            Image(systemName: "pencil.and.list.clipboard")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                                .padding(.leading, 20)
                            
                            Text("Take control of your job search with manual entry.")
                                .font(.system(size: 13,weight: .bold ))
                                .foregroundColor(Theme.tertiaryColor)
                                .padding(.leading, 10)
                        }
                        
                        CustomButton(title: "FILL MANUALLY", backgroundColor: Theme.primaryColor, action: {
                            // Action for Fill Manually button
                        }, width: geometry.size.width * 0.6, height: 50, cornerRadius: 6) // Center button with width relative to screen size
                        .padding(.horizontal, 45)
                        .padding(.top, 20)
                        
                        HStack {
                            Divider()
                                .frame(width: geometry.size.width * 0.3, height: 1)
                                .background(Color.gray)
                                .padding(.leading, 20)

                            Text("OR")
                                .foregroundColor(Color.gray)
                                .frame(width: geometry.size.width * 0.1) // Ensure the text is centered between dividers

                            Divider()
                                .frame(width: geometry.size.width * 0.3, height: 1)
                                .background(Color.gray)
                                .padding(.trailing, 20)
                        }
                        .padding(.top, geometry.size.height * -0.05)
                        
                        Spacer()
                        
                        // Second Section: Fill Automatically
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
                        
                        CustomButton(title: "FILL AUTOMATICALLY", backgroundColor: Theme.primaryColor, action: {
                            // Action for Fill Automatically button
                        }, width: geometry.size.width * 0.6, height: 50, cornerRadius: 6) // Center button with width relative to screen size
                        .padding(.horizontal, 45)
                        .padding(.top, 20)
                        
                    }
                    
                    Spacer()
                }
                .padding(.top, 20)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    UserDetailView()
}
