import SwiftUI
import PhotosUI

struct ClientInfoView: View {
    @State private var name: String = ""
    @State private var dateOfBirth: Date = Date()
    @State private var selectedGender: String = "Male"
    @State private var phoneNumber: String = ""
    @State private var companyName: String = ""
    @State private var selectedWorkTrait: String = "Technical"
    @State private var selectedCountryCode: String = "+91"
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var selectedImage: UIImage?
    @State private var photosPickerItem: PhotosPickerItem?
    
    @State private var navigate: Bool = false
    
    // Add FocusState to manage keyboard focus
    @FocusState private var focusedField: Field?
    enum Field {
        case name, phoneNumber, companyName
    }
    
    let genders = ["Male", "Female", "Other"]
    let workTraits = ["Technical", "Management", "Creative", "Support", "Sales"]

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Theme.backgroundColor
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack {
                        // Header
                        HStack {
                            Text("Get")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.primaryColor)
                            Text("Started!")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.tertiaryColor)
                            Spacer()
                        }
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                        
                        // Progress Bar
                        ProgressView(value: 0.2, total: 1.0)
                            .tint(Theme.primaryColor)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        
                        // Profile Image Picker
                        PhotosPicker(selection: $photosPickerItem, matching: .images) {
                            if let selectedImage = selectedImage {
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            } else {
                                Circle()
                                    .fill(Color.gray)
                                    .frame(width: 100, height: 100)
                                    .overlay(
                                        Image(systemName: "person")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                            .foregroundColor(.white)
                                    )
                            }
                        }
                        .onChange(of: photosPickerItem) { newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    selectedImage = uiImage
                                }
                            }
                        }
                        .padding(.bottom, 20)
                        
                        // Form Fields
                        VStack(alignment: .leading, spacing: 20) {
                            // Name Field
                            Text("Name")
                                .font(.system(size: geometry.size.width * 0.04, weight: .bold))
                                .foregroundColor(Theme.onPrimaryColor)
                            CustomTextField(placeholder: "Name", isSecure: false, text: $name, icon: "person")
                                .focused($focusedField, equals: .name)
                                .submitLabel(.next)
                                .onSubmit {
                                    focusedField = .phoneNumber
                                }
                                .padding(.bottom, geometry.size.height * 0.015)
                                .padding(.horizontal, -geometry.size.width * 0.05)
                            
                            DateViewPicker(selectedDate: $dateOfBirth, title: "Date of Birth", BackgroundColor: Color.white, textColor: Theme.onPrimaryColor, padding: geometry.size.width * 0.03)
                                .padding(.bottom, geometry.size.height * 0.015)
                            
                            // Gender Field
                            Text("Gender")
                                .font(.system(size: geometry.size.width * 0.04, weight: .bold))
                                .foregroundColor(Theme.onPrimaryColor)
                            Picker("Gender", selection: $selectedGender) {
                                ForEach(genders, id: \.self) { gender in
                                    Text(gender)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding(.bottom, 10)
                            
                            // Phone Number Field
                            Text("Phone Number")
                                .font(.system(size: geometry.size.width * 0.04, weight: .bold))
                                .foregroundColor(Theme.onPrimaryColor)
                            PhoneNumberInputView(selectedCountryCode: $selectedCountryCode, phoneNumber: $phoneNumber, showAlert: $showAlert, alertMessage: $alertMessage)
                                .focused($focusedField, equals: .phoneNumber)
                                .submitLabel(.next)
                                .onSubmit {
                                    focusedField = .companyName
                                }
                                .padding(.bottom, geometry.size.height * 0.015)
                                .padding(.horizontal, -geometry.size.width * 0.05)
                            
                            // Company Name Field
                            Text("Company Name")
                                .font(.system(size: geometry.size.width * 0.04, weight: .bold))
                                .foregroundColor(Theme.onPrimaryColor)
                            CustomTextField(placeholder: "Enter your Company Name", isSecure: false, text: $companyName, icon: "")
                                .focused($focusedField, equals: .companyName)
                                .submitLabel(.go)
                                .onSubmit {
                                    focusedField = nil // Dismiss keyboard on "Go"
                                }
                                .padding(.bottom, geometry.size.height * 0.015)
                                .padding(.horizontal, -geometry.size.width * 0.05)
                            
                            // Work Trait Field
                            Text("Work Trait")
                                .font(.system(size: geometry.size.width * 0.04, weight: .bold))
                                .foregroundColor(Theme.onPrimaryColor)
                            Picker("Work Trait", selection: $selectedWorkTrait) {
                                ForEach(workTraits, id: \.self) { trait in
                                    Text(trait)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding(.bottom, 10)
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer()
                        
                        // Next Button
                        Button(action: {
                            setData()
                            navigate = true
                        }) {
                            Text("NEXT")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                        
                        NavigationLink(destination: WorkPitcher(), isActive: $navigate) {
                            EmptyView()
                        }
                    }
                }
                .onTapGesture {
                    focusedField = nil // Dismiss keyboard on tap anywhere
                }
            }
        }
    }
    
    private func setData() {
        ClientFormManager.shared.clientData.name = name
        ClientFormManager.shared.clientData.DOB = dateOfBirth
        ClientFormManager.shared.clientData.gender = selectedGender
        ClientFormManager.shared.clientData.phone = phoneNumber
        ClientFormManager.shared.clientData.storeName = companyName
        ClientFormManager.shared.clientData.workTrait = selectedWorkTrait
    }
}

#Preview {
    ClientInfoView()
}
