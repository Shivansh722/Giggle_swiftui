//
//  edit-profile-view.swift
//  Giggle_swiftui
//
//  Created by rjk on 08/01/25.
//

import PhotosUI  // For image picker functionality
import SwiftUI

struct edit_profile_view: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedImage: UIImage? = nil  // To hold the selected image
    @State private var isImagePickerPresented = false
    @State private var name = FormManager.shared.formData.name  // Editable name
    @State private var email = ""  // Editable email
    @State private var biography = FormManager.shared.formData.Biography // Editable biography

    // States for Experience Section
    @State private var companyName = ""
    @State private var position = ""
    @State private var companyBranch = ""

    // States for Month and Year Selection
    @State private var startMonth = 0  // Index for the selected start month
    @State private var startYear = Calendar.current.component(
        .year, from: Date())  // Default to current year
    @State private var endMonth = 0  // Index for the selected end month
    @State private var endYear = Calendar.current.component(.year, from: Date())  // Default to current year
    
    // New states for skills
    @State private var skills: [String] = []
    @State private var newSkill = ""

    let months = Calendar.current.monthSymbols  // Array of month names
    let yearRange = Array(
        2000...Calendar.current.component(.year, from: Date()))  // Year range

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                ZStack {
                    Theme.backgroundColor.edgesIgnoringSafeArea(.all)
                    
                    // Decorative elements
                    Circle()
                        .fill(Theme.primaryColor.opacity(0.05))
                        .frame(width: 200, height: 200)
                        .blur(radius: 30)
                        .offset(x: -geometry.size.width/2, y: 100)
                    
                    Circle()
                        .fill(Theme.primaryColor.opacity(0.08))
                        .frame(width: 250, height: 250)
                        .blur(radius: 40)
                        .offset(x: geometry.size.width/2, y: 300)
                    
                    VStack(spacing: 16) {
                        // Header with back button
                        HStack {
                            Button(action: {
                                dismiss()
                            }) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.white)
                                    .imageScale(.large)
                                    .padding(8)
                            }
                            
                            
                            Text("Edit Profile")
                                .font(.title)
                                .foregroundColor(Theme.onPrimaryColor)
                            
                            Spacer()
                            
                            // Empty view for symmetry
                            Circle()
                                .fill(Color.clear)
                                .frame(width: 40, height: 40)
                        }
                        .padding(.horizontal)
                        
                        // Profile Picture and Name Section
                        VStack(spacing: 0) {
                            ZStack(alignment: .bottomTrailing) {
                                // Profile Image with improved styling
                                ZStack {
                                    
                                    
                                    if let selectedImage = selectedImage {
                                        Image(uiImage: selectedImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 110, height: 110)
                                            .clipShape(Circle())
                                            .shadow(color: Theme.primaryColor.opacity(0.3), radius: 5)
                                    } else {
                                        Image(systemName: "person.crop.circle")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 110, height: 110)
                                            .foregroundColor(Theme.onPrimaryColor.opacity(0.7))
                                    }
                                }

                                // Edit Pen Icon with improved styling
                                Button(action: {
                                    isImagePickerPresented = true
                                }) {
                                    Image(systemName: "pencil.circle.fill")
                                        .resizable()
                                        .foregroundColor(Theme.primaryColor)
                                        .frame(width: 30, height: 30)
                                        .background(
                                            Circle()
                                                .fill(Color.white)
                                                .shadow(color: Color.black.opacity(0.2), radius: 2)
                                        )
                                        .offset(x: 5, y: 5)
                                }
                            }

                            // Editable Name with improved styling
                            TextField("", text: $name)
                                .foregroundColor(Theme.onPrimaryColor)
                                .font(.title2.bold())
                                .multilineTextAlignment(.center)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(.horizontal)
                            
                            // Editable Email with improved styling
                            TextField("", text: $email, prompt: Text("Email").foregroundColor(.gray))
                                .foregroundColor(.gray)
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(.horizontal)
                                .padding(.bottom, 8)
                        }
                        
                        // Skills Section (New)
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Skills")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(Theme.onPrimaryColor)
                                
                                Spacer()
                                
                                Image(systemName: "star.fill")
                                    .foregroundColor(Theme.primaryColor.opacity(0.7))
                            }
                            .padding(.bottom, 4)
                            
                            VStack(spacing: 8) {
                                ForEach(skills, id: \.self) { skill in
                                    HStack {
                                        Text("• \(skill)")
                                            .foregroundColor(Theme.onPrimaryColor)
                                        Spacer()
                                        Button(action: {
                                            skills.removeAll { $0 == skill }
                                        }) {
                                            Image(systemName: "xmark")
                                                .foregroundColor(.red)
                                        }
                                    }
                                    .padding(.vertical, 4)
                                }
                                
                                HStack {
                                    TextField("", text: $newSkill, prompt: Text("Add a skill").foregroundColor(Theme.onPrimaryColor.opacity(0.6)))
                                        .foregroundColor(Theme.onPrimaryColor)
                                        .padding(14)
                                        .background(Color(hex: "343434").opacity(0.6))
                                        .cornerRadius(8)
                                        .font(.system(size: 14))
                                        .submitLabel(.done)
                                        .onSubmit {
                                            if !newSkill.isEmpty {
                                                skills.append(newSkill)
                                                newSkill = ""
                                            }
                                        }
                                }
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(hex: "343434").opacity(0.4))
                        )
                        .padding(.horizontal)
                        
                        // Biography Section with improved styling
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Biography")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(Theme.onPrimaryColor)
                                
                                Spacer()
                                
                                Image(systemName: "quote.bubble")
                                    .foregroundColor(Theme.primaryColor.opacity(0.7))
                            }
                            .padding(.bottom, 4)

                            TextEditor(text: $biography)
                                .frame(height: 150)
                                .foregroundColor(Theme.onPrimaryColor)
                                .padding(4)
                                .font(.system(size: 14))
                                .scrollContentBackground(.hidden)
                                .background(Color(hex: "343434").opacity(0.6))
                                .cornerRadius(8)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(hex: "343434").opacity(0.4))
                        )
                        .padding(.horizontal)
                        
                        // Experience Section with improved styling
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Experience")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(Theme.onPrimaryColor)
                                
                                Spacer()
                                
                                Image(systemName: "briefcase.fill")
                                    .foregroundColor(Theme.primaryColor.opacity(0.7))
                            }
                            .padding(.bottom, 4)
                            
                            // Company Name
                            ZStack(alignment: .leading) {
                                if companyName.isEmpty {
                                    Text("Company Name")
                                        .foregroundColor(Theme.onPrimaryColor.opacity(0.6))
                                        .padding(.horizontal, 10)
                                        .font(.system(size: 16))
                                }
                                TextField("", text: $companyName)
                                    .foregroundColor(Theme.onPrimaryColor)
                                    .padding(14)
                                    .background(Color(hex: "343434").opacity(0.6))
                                    .cornerRadius(8)
                                    .font(.system(size: 14))
                                    .textFieldStyle(PlainTextFieldStyle())
                            }
                            .padding(.bottom, 8)
                            
                            // Position
                            ZStack(alignment: .leading) {
                                if position.isEmpty {
                                    Text("Position")
                                        .foregroundColor(Theme.onPrimaryColor.opacity(0.6))
                                        .padding(.horizontal, 10)
                                        .font(.system(size: 16))
                                }
                                TextField("", text: $position)
                                    .foregroundColor(Theme.onPrimaryColor)
                                    .padding(14)
                                    .background(Color(hex: "343434").opacity(0.6))
                                    .cornerRadius(8)
                                    .font(.system(size: 14))
                                    .textFieldStyle(PlainTextFieldStyle())
                            }
                            .padding(.bottom, 8)
                            
                            // Company Branch
                            ZStack(alignment: .leading) {
                                if companyBranch.isEmpty {
                                    Text("Company Branch (City, State)")
                                        .foregroundColor(Theme.onPrimaryColor.opacity(0.6))
                                        .padding(.horizontal, 10)
                                        .font(.system(size: 16))
                                }
                                TextField("", text: $companyBranch)
                                    .foregroundColor(Theme.onPrimaryColor)
                                    .padding(14)
                                    .background(Color(hex: "343434").opacity(0.6))
                                    .cornerRadius(8)
                                    .font(.system(size: 14))
                                    .textFieldStyle(PlainTextFieldStyle())
                            }
                            
                            // Date Pickers with improved styling
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Start Date")
                                    .foregroundColor(Theme.onPrimaryColor)
                                    .font(.headline)
                                
                                HStack {
                                    Picker("Month", selection: $startMonth) {
                                        ForEach(0..<months.count, id: \.self) { index in
                                            Text(months[index]).tag(index)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                    .frame(maxWidth: .infinity)
                                    
                                    Picker("Year", selection: $startYear) {
                                        ForEach(yearRange, id: \.self) { year in
                                            Text(String(year)).tag(year)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                    .frame(maxWidth: .infinity)
                                }
                                .padding(14)
                                .background(Color(hex: "343434").opacity(0.6))
                                .cornerRadius(8)
                                
                                Text("End Date")
                                    .foregroundColor(Theme.onPrimaryColor)
                                    .font(.headline)
                                    .padding(.top, 8)
                                
                                HStack {
                                    Picker("Month", selection: $endMonth) {
                                        ForEach(0..<months.count, id: \.self) { index in
                                            Text(months[index]).tag(index)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                    .frame(maxWidth: .infinity)
                                    
                                    Picker("Year", selection: $endYear) {
                                        ForEach(yearRange, id: \.self) { year in
                                            Text(String(year)).tag(year)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                    .frame(maxWidth: .infinity)
                                }
                                .padding(14)
                                .background(Color(hex: "343434").opacity(0.6))
                                .cornerRadius(8)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(hex: "343434").opacity(0.4))
                        )
                        .padding(.horizontal)
                        
                        // Save Button with improved styling
                        Button(action: {
                            Task {
                                await nameChanges()
                                await bioChanges()
                            }
                            let startDate = "\(months[startMonth]) \(startYear)"
                            let endDate = "\(months[endMonth]) \(endYear)"
                            let experience = Experience(
                                position: position,
                                companyName: companyName,
                                location: companyBranch,
                                startDate: startDate,
                                endDate: endDate
                            )
                            ExperienceStore.shared.addExperience(experience)
                            
                            // Reset fields after saving
                            companyName = ""
                            position = ""
                            companyBranch = ""
                            startMonth = 0
                            endMonth = 0
                            startYear = Calendar.current.component(.year, from: Date())
                            endYear = startYear
                            dismiss()
                        }) {
                            Text("SAVE")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(width: geometry.size.width * 0.8, height: 50)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Theme.primaryColor, Theme.primaryColor.opacity(0.8)]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(10)
                                .shadow(color: Theme.primaryColor.opacity(0.3), radius: 5, x: 0, y: 2)
                        }
                        .padding(.vertical, 16)
                    }
                    .padding(.vertical)
                }
            }
            .navigationBarBackButtonHidden(true)
            .background(Theme.backgroundColor)
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(
                    image: Binding(
                        get: { self.selectedImage },
                        set: { newImage in
                            self.selectedImage = newImage
                            GlobalData.shared.profileImage = newImage  // Store globally
                        }
                    ))
            }
        }
    }

    func bioChanges() async {
        do {
            try await SaveUserInfo(appService: AppService()).updateBiographhy(
                biography)
        } catch {
            print(error)
        }
    }

    func nameChanges() async {
        do {
            try await SaveUserInfo(appService: AppService()).updateName(name)
        } catch {
            print(error)
        }
    }
}

class GlobalData: ObservableObject {
    static let shared = GlobalData()
    @Published var profileImage: UIImage?

    private init() {}
}

// Experience Model
struct Experience: Identifiable {
    let id = UUID()
    var position: String
    var companyName: String
    var location: String
    var startDate: String
    var endDate: String
}

// Singleton Global Store
class ExperienceStore {
    static let shared = ExperienceStore()
    private(set) var experiences: [Experience] = []
    
    private init() {}
    
    func addExperience(_ experience: Experience) {
        experiences.append(experience)
    }
    
    func clearExperiences() {
        experiences.removeAll()
    }
}

// ImagePicker Helper for selecting images
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(
        _ uiViewController: PHPickerViewController, context: Context
    ) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(
            _ picker: PHPickerViewController,
            didFinishPicking results: [PHPickerResult]
        ) {
            picker.dismiss(animated: true)
            guard let provider = results.first?.itemProvider,
                provider.canLoadObject(ofClass: UIImage.self)
            else { return }
            provider.loadObject(ofClass: UIImage.self) { image, _ in
                DispatchQueue.main.async {
                    self.parent.image = image as? UIImage
                }
            }
        }
    }
}

#Preview {
    edit_profile_view()
}
