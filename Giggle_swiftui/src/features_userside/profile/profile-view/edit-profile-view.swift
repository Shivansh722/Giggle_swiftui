import SwiftUI
import PhotosUI

struct edit_profile_view: View {
    @ObservedObject var viewModel: ProfileViewModel // Shared view model
    @State private var isImagePickerPresented = false
    
    // States for Experience Section (unchanged)
    @State private var companyName = ""
    @State private var position = ""
    @State private var companyBranch = ""
    
    @State private var startMonth = 0
    @State private var startYear = Calendar.current.component(.year, from: Date())
    @State private var endMonth = 0
    @State private var endYear = Calendar.current.component(.year, from: Date())

    let months = Calendar.current.monthSymbols
    let yearRange = Array(2000...Calendar.current.component(.year, from: Date()))

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                ZStack {
                    Theme.backgroundColor.edgesIgnoringSafeArea(.all)
                    VStack(spacing: 16) {
                        VStack(spacing: 8) {
                            ZStack(alignment: .bottomTrailing) {
                                if let selectedImage = viewModel.selectedImage {
                                    Image(uiImage: selectedImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 110, height: 110)
                                        .clipShape(Circle())
                                        .shadow(radius: 5)
                                } else {
                                    Image("face-id")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 110, height: 110)
                                        .clipShape(Circle())
                                        .shadow(radius: 5)
                                }

                                Button(action: {
                                    isImagePickerPresented = true
                                }) {
                                    Image(systemName: "pencil.circle.fill")
                                        .resizable()
                                        .foregroundColor(Theme.primaryColor)
                                        .frame(width: 30, height: 30)
                                        .background(Color.white.clipShape(Circle()))
                                        .offset(x: 5, y: 5)
                                }
                            }

                            ZStack(alignment: .leading) {
                                TextField("", text: $viewModel.name)
                                    .foregroundColor(Theme.onPrimaryColor)
                                    .font(.title)
                                    .multilineTextAlignment(.center)
                                    .textFieldStyle(PlainTextFieldStyle())
                            }
                            ZStack(alignment: .center) {
                                TextField("", text: $viewModel.email)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .textFieldStyle(PlainTextFieldStyle())
                            }
                        }
                        .padding(.top, 16)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Biography")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(Theme.onPrimaryColor)

                            TextEditor(text: $viewModel.biography)
                                .frame(height: 150)
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

                        // Experience Section (unchanged)
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Experience")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(Theme.onPrimaryColor)

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
                                    .background(Color(hex: "343434").opacity(0.6))
                                    .cornerRadius(8)
                                    .font(.system(size: 14))
                                    .textFieldStyle(PlainTextFieldStyle())
                            }

                            ZStack(alignment: .leading) {
                                if position.isEmpty {
                                    Text("Position")
                                        .foregroundColor(Theme.onPrimaryColor)
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

                            ZStack(alignment: .leading) {
                                if companyBranch.isEmpty {
                                    Text("Company Branch (City, State)")
                                        .foregroundColor(Theme.onPrimaryColor)
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
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)

                        // Date Pickers (unchanged)
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Select Start and End Dates")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(Theme.onPrimaryColor)

                            VStack(alignment: .leading, spacing: 4) {
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
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text("End Date")
                                    .foregroundColor(Theme.onPrimaryColor)
                                    .font(.headline)
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
                        .padding(.horizontal)
                        .padding(.top, 8)

                        CustomButton(
                            title: "SAVE",
                            backgroundColor: Theme.primaryColor,
                            action: {
                                // Save logic here if needed
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
                ImagePicker(image: $viewModel.selectedImage)
            }
        }
    }
}

// ImagePicker remains unchanged
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }
            provider.loadObject(ofClass: UIImage.self) { image, _ in
                DispatchQueue.main.async {
                    self.parent.image = image as? UIImage
                }
            }
        }
    }
}

#Preview {
    edit_profile_view(viewModel: ProfileViewModel())
}
