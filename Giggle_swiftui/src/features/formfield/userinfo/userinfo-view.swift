import SwiftUI

struct UserInfoView: View {
    @State private var name: String = ""
    @State private var dateOfBirth: Date = Date()
    @State private var selectedGender: String = "Male"
    @State private var phoneNumber: String = ""
    
    let genders = ["Male", "Female", "Other"]
    
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
                            .padding(.leading, geometry.size.width * 0.08)
                        }
                        Spacer()
                    }
                    .padding(.top, geometry.size.height * 0.02)
                    
                    
                    ProgressView(value: 20, total: 100)
                        .accentColor(Theme.primaryColor)
                        .padding(.horizontal, geometry.size.width * 0.08)
                        .padding(.bottom, 20)
                    
                    
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 100, height: 100)
                        .overlay(
                            Image(systemName: "person.fill.badge.plus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.white)
                        )
                        .padding(.bottom, 20)
                    
                    
                    VStack(alignment: .leading, spacing: 20) {
                        
                        Text("Name")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Theme.onPrimaryColor)
                        CustomTextField(placeholder: "Name", isSecure: false, text: $name, icon: "person")
                            .padding(.bottom, 12)
                            .padding(.horizontal, -20)
                        
                        c
                        
                        // Gender Picker
                        Text("Gender")
                            .font(.caption)
                            .foregroundColor(Theme.secondaryColor)
                        Picker("Gender", selection: $selectedGender) {
                            ForEach(genders, id: \.self) { gender in
                                Text(gender)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(.horizontal)
                        
                        // Phone Number TextField
                        Text("Phone Number")
                            .font(.caption)
                            .foregroundColor(Theme.secondaryColor)
                        TextField("+91", text: $phoneNumber)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    .padding(.horizontal, geometry.size.width * 0.08)
                    
                    Spacer()
                    
                    // Next Button
                    Button(action: {
                        // Handle the "Next" button action here
                    }) {
                        Text("NEXT")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.primaryColor)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal, geometry.size.width * 0.08)
                    .padding(.bottom, 20)
                }
            }
        }
    }
}

#Preview {
    UserInfoView()
}
