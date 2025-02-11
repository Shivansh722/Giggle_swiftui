import SwiftUI
import PhotosUI

struct ClientInfoView: View {
    @State private var name: String = ""
    @State private var dateOfBirth: Date = Date()
    @State private var selectedGender: String = "Male"
    @State private var phoneNumber: String = ""
    @State private var companyName: String = ""
    @State private var selectedWorkTrait: String = "Technical"
    
    @State private var selectedImage: UIImage?
    @State private var photosPickerItem: PhotosPickerItem?
    
    let genders = ["Male", "Female", "Other"]
    let workTraits = ["Technical", "Management", "Creative", "Support", "Sales"]

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    // Header
                    HStack {
                        Text("Get")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                        Text("Started!")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 20)

                    // Progress Bar
                    ProgressView(value: 0.2, total: 1.0)
                        .tint(.blue)
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
                            .font(.headline)
                            .foregroundColor(.black)
                        TextField("Enter your name", text: $name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.bottom, 10)

                        // Date of Birth Field
                        Text("Date of Birth")
                            .font(.headline)
                            .foregroundColor(.black)
                        DatePicker("Select Date", selection: $dateOfBirth, displayedComponents: .date)
                            .datePickerStyle(CompactDatePickerStyle())
                            .padding(.bottom, 10)

                        // Gender Field
                        Text("Gender")
                            .font(.headline)
                            .foregroundColor(.black)
                        Picker("Gender", selection: $selectedGender) {
                            ForEach(genders, id: \.self) { gender in
                                Text(gender)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(.bottom, 10)

                        // Phone Number Field
                        Text("Phone Number")
                            .font(.headline)
                            .foregroundColor(.black)
                        TextField("Enter your phone number", text: $phoneNumber)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.phonePad)
                            .padding(.bottom, 10)

                        // Company Name Field
                        Text("Company Name")
                            .font(.headline)
                            .foregroundColor(.black)
                        TextField("Enter your company name", text: $companyName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.bottom, 10)

                        // Work Trait Field
                        Text("Work Trait")
                            .font(.headline)
                            .foregroundColor(.black)
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
                        print("Next button tapped")
                        print("Name: \(name)")
                        print("Date of Birth: \(dateOfBirth)")
                        print("Gender: \(selectedGender)")
                        print("Phone Number: \(phoneNumber)")
                        print("Company Name: \(companyName)")
                        print("Work Trait: \(selectedWorkTrait)")
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
                }
            }
        }
    }
}

#Preview {
    ClientInfoView()
}
