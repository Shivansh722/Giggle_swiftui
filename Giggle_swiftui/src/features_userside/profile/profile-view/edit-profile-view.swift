//
//  edit-profile-view.swift
//  Giggle_swiftui
//
//  Created by rjk on 08/01/25.
//

import PhotosUI  // For image picker functionality
import SwiftUI

struct edit_profile_view: View {
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

    let months = Calendar.current.monthSymbols  // Array of month names
    let yearRange = Array(
        2000...Calendar.current.component(.year, from: Date()))  // Year range

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                ZStack {
                    Theme.backgroundColor.edgesIgnoringSafeArea(.all)
                    VStack(spacing: 16) {
                        // Profile Picture and Name Section
                        VStack(spacing: 8) {
                            ZStack(alignment: .bottomTrailing) {
                                // Profile Image
                                if let selectedImage = selectedImage {
                                    Image(uiImage: selectedImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 110, height: 110)
                                        .clipShape(Circle())
                                        .shadow(radius: 5)
                                } else {
                                    Image("face-id")  // Default image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 110, height: 110)
                                        .clipShape(Circle())
                                        .shadow(radius: 5)
                                }

                                // Edit Pen Icon
                                Button(action: {
                                    isImagePickerPresented = true
                                }) {
                                    Image(systemName: "pencil.circle.fill")
                                        .resizable()
                                        .foregroundColor(Theme.primaryColor)
                                        .frame(width: 30, height: 30)
                                        .background(
                                            Color.white.clipShape(Circle())
                                        )
                                        .offset(x: 5, y: 5)
                                }
                            }

                            // Editable Name
                            ZStack(alignment: .leading) {
                                TextField("", text: $name)
                                    .foregroundColor(Theme.onPrimaryColor)
                                    .font(.title)
                                    .multilineTextAlignment(.center)
                                    .textFieldStyle(PlainTextFieldStyle())
                            }
                            // Editable Name
                            ZStack(alignment: .center) {
                                TextField("", text: $email)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .textFieldStyle(PlainTextFieldStyle())
                            }
                        }
                        .padding(.top, 16)
                        // Biography Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Biography")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(Theme.onPrimaryColor)

                            TextEditor(text: $biography)
                                .frame(height: 150)  // Adjust height as needed
                                .foregroundColor(Theme.onPrimaryColor)
                                .padding(4)
                                .font(.system(size: 14))
                                .scrollContentBackground(.hidden)
                                .background(Color(hex: "343434").opacity(0.6))
                                .cornerRadius(8)
                                .padding(.top, 4)
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        // Experience Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Experience")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(Theme.onPrimaryColor)

                            // Company Name TextField
                            ZStack(alignment: .leading) {
                                if companyName.isEmpty {
                                    Text("Company Name")
                                        .foregroundColor(Theme.onPrimaryColor)
                                        .padding(.horizontal, 10)
                                        .font(.system(size: 16))
                                }
                                TextField("", text: $companyName)
                                    .foregroundColor(Theme.onPrimaryColor)
                                    .padding(14)
                                    .background(
                                        Color(hex: "343434").opacity(0.6)
                                    )
                                    .cornerRadius(8)
                                    .font(.system(size: 14))
                                    .textFieldStyle(PlainTextFieldStyle())
                            }

                            // Position TextField
                            ZStack(alignment: .leading) {
                                if companyName.isEmpty {
                                    Text("Position")
                                        .foregroundColor(Theme.onPrimaryColor)
                                        .padding(.horizontal, 10)
                                        .font(.system(size: 16))
                                }
                                TextField("", text: $companyName)
                                    .foregroundColor(Theme.onPrimaryColor)
                                    .padding(14)
                                    .background(
                                        Color(hex: "343434").opacity(0.6)
                                    )
                                    .cornerRadius(8)
                                    .font(.system(size: 14))
                                    .textFieldStyle(PlainTextFieldStyle())
                            }

                            // Company Branch TextField
                            ZStack(alignment: .leading) {
                                if companyName.isEmpty {
                                    Text("Company Branch (City, State)")
                                        .foregroundColor(Theme.onPrimaryColor)
                                        .padding(.horizontal, 10)
                                        .font(.system(size: 16))
                                }
                                TextField("", text: $companyName)
                                    .foregroundColor(Theme.onPrimaryColor)
                                    .padding(14)
                                    .background(
                                        Color(hex: "343434").opacity(0.6)
                                    )
                                    .cornerRadius(8)
                                    .font(.system(size: 14))
                                    .textFieldStyle(PlainTextFieldStyle())
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Select Start and End Dates")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(Theme.onPrimaryColor)

                            // Start Date Picker
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Start Date")
                                    .foregroundColor(Theme.onPrimaryColor)
                                    .font(.headline)

                                HStack {
                                    Picker("Month", selection: $startMonth) {
                                        ForEach(0..<months.count, id: \.self) {
                                            index in
                                            Text(months[index]).tag(index)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())  // Use MenuPickerStyle for a dropdown
                                    .frame(maxWidth: .infinity)

                                    Picker("Year", selection: $startYear) {
                                        ForEach(yearRange, id: \.self) { year in
                                            Text(String(year)).tag(year)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())  // Use MenuPickerStyle for a dropdown
                                    .frame(maxWidth: .infinity)
                                }
                                .padding(14)
                                .background(Color(hex: "343434").opacity(0.6))
                                .cornerRadius(8)
                            }

                            // End Date Picker
                            VStack(alignment: .leading, spacing: 4) {
                                Text("End Date")
                                    .foregroundColor(Theme.onPrimaryColor)
                                    .font(.headline)

                                HStack {
                                    Picker("Month", selection: $endMonth) {
                                        ForEach(0..<months.count, id: \.self) {
                                            index in
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
                        .padding(.horizontal)
                        .padding(.top, 8)
                        CustomButton(
                            title: "SAVE",
                            backgroundColor: Theme.primaryColor,
                            action: {
                                Task {
                                    await nameChanges()
                                    await bioChanges()
                                }
                            },
                            width: geometry.size.width * 0.8,
                            height: 50,
                            cornerRadius: 6
                        )
                        .padding(.horizontal, -15)
                        .padding(.top, 8)
                        .padding(.bottom, 8)
                    }
                    .padding()
                }
            }
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
