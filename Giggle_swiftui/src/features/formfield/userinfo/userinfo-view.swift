import SwiftUI
import PhotosUI

struct UserInfoView: View {
    @ObservedObject var formManager = FormManager.shared
    @State private var name: String = ""
    @State private var dateOfBirth: Date = Date()
    @State private var selectedGender: String = "Male"
    @State private var phoneNumber: String = ""
    @State private var selectedCountryCode: String = "+91"
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var navigateToLocation:Bool = false
    
    let genders = ["Male", "Female", "Other"]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Theme.backgroundColor
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: geometry.size.height * 0.005) {
                            HStack {
                                Text("Get")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Theme.primaryColor)
                                Text("Started!")
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
                        .padding(.bottom, geometry.size.height * 0.02)
                    
                    PhotosPicker(selection: $photosPickerItem) {
                        Circle()
                            .fill(Color.gray)
                            .frame(width: geometry.size.width * 0.25, height: geometry.size.width * 0.25)
                            .overlay(
                                Image(systemName: "person")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geometry.size.width * 0.15, height: geometry.size.width * 0.15)
                                    .foregroundColor(.white)
                            )
                            .padding(.bottom, geometry.size.height * 0.02)
                    }
                    
                    VStack(alignment: .leading, spacing: geometry.size.height * 0.02) {
                        
                        Text("Name")
                            .font(.system(size: geometry.size.width * 0.04, weight: .bold))
                            .foregroundColor(Theme.onPrimaryColor)
                        CustomTextField(placeholder: "Name", isSecure: false, text: $name, icon: "person")
                            .padding(.bottom, geometry.size.height * 0.015)
                            .padding(.horizontal, -geometry.size.width * 0.05)
                        
                        DateViewPicker(selectedDate: $dateOfBirth, title: "Date of Birth", BackgroundColor: Color.white, textColor: Theme.onPrimaryColor, padding: geometry.size.width * 0.03)
                            .padding(.bottom, geometry.size.height * 0.015)
                        
                        Text("Gender")
                            .font(.system(size: geometry.size.width * 0.04, weight: .bold))
                            .foregroundColor(Theme.onPrimaryColor)
                       
                        Picker("Gender", selection: $selectedGender) {
                            ForEach(genders, id: \.self) { gender in
                                Text(gender)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(.horizontal, -geometry.size.width * 0.02)
                        .padding(.top, -geometry.size.height * 0.01)
                        
                        Text("Phone Number")
                            .font(.system(size: geometry.size.width * 0.04, weight: .bold))
                            .foregroundColor(Theme.onPrimaryColor)
                        PhoneNumberInputView(selectedCountryCode: $selectedCountryCode, phoneNumber: $phoneNumber, showAlert: $showAlert, alertMessage: $alertMessage)
                            .padding(.bottom, geometry.size.height * 0.015)
                            .padding(.horizontal, -geometry.size.width * 0.05)
                    }
                    .padding(.horizontal, geometry.size.width * 0.08)
                    
                    Spacer()
                    NavigationLink(
                        destination:LocationView(),
                        isActive: $navigateToLocation
                    ){
                        EmptyView()
                    }
                    // Next Button
                    Button(action: {
                        setData()
                        navigateToLocation = true
                    }) {
                        Text("NEXT")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.primaryColor)
                            .cornerRadius(geometry.size.width * 0.02)
                    }
                    .padding(.horizontal, geometry.size.width * 0.08)
                    .padding(.bottom, geometry.size.height * 0.02)
                }
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                loadUserDataFromUserDefaults()
                }
        }
    }
    private func setData(){
        formManager.formData.name = name
        formManager.formData.phone = phoneNumber
        formManager.formData.gender = selectedGender
    }
    
    private func saveUserDataToUserDefaults() {
        UserDefaults.standard.set(name, forKey: "userName")
        UserDefaults.standard.set(phoneNumber, forKey: "userPhone")
        print("User data saved: Name = \(name), Phone = \(phoneNumber)")
    }

    private func loadUserDataFromUserDefaults() {
        if UserPreference.shared.shouldLoadUserDetailsAutomatically {
            if let resumeData = UserDefaults.standard.data(forKey: "resumeData") {
                do {
                    if let resume = try JSONSerialization.jsonObject(with: resumeData, options: []) as? [String: Any] {
                        if let storedName = resume["Name"] as? String {
                            name = storedName
                            print("User data loaded: Name = \(name)")
                        } else {
                            print("Name key not found in the resume data")
                        }
                        if let storedPhone = resume["Contact"] as? String {
                            phoneNumber = storedPhone
                            print("User data loaded: Phone = \(phoneNumber)")
                        } else {
                            print("Phone key not found in the resume data")
                        }
                    }
                } catch {
                    print("Error decoding resume data: \(error.localizedDescription)")
                }
            } else {
                print("No resume data found in UserDefaults")
            }
        }
    }
}
