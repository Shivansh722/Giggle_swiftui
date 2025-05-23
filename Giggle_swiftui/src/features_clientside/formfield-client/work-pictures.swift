import Appwrite
import Foundation
import SwiftUI
import UniformTypeIdentifiers
import PhotosUI

struct WorkPitcher: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var uploadManager = ResumeUploadManager(
        apiEndpoint: "https://cloud.appwrite.io/v1",
        projectIdentifier: "67da77af003e5e94f856",
        storageBucketId: "67da7d55000bf31fb062"
    )

    @State private var isPhotoPickerPresented = false
    @State private var navigationTrue: Bool = false

    var body: some View {
        ZStack {
            Theme.backgroundColor
                .edgesIgnoringSafeArea(.all)

            VStack {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Theme.onPrimaryColor)
                            .imageScale(.large)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                Text("Upload Your Company Logo")
                    .font(.title)
                    .bold()
                    .foregroundColor(Theme.onPrimaryColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                    .padding(.top, 10)

                List {
                    if !uploadManager.selectedResumes.isEmpty {
                        Section(header: Text("Selected Images").foregroundColor(Theme.onPrimaryColor)) {
                            ForEach(uploadManager.selectedResumes) { resume in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(resume.fileName)
                                            .font(.headline)
                                            .foregroundColor(Theme.onPrimaryColor)
                                        Text("\(resume.fileSize / 1024) KB")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Button(action: {
                                        uploadManager.removeSelectedResume(resume)
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                            .listRowBackground(Theme.backgroundColor)
                        }
                    }

                    if !uploadManager.uploadedResumes.isEmpty {
                        Section(header: Text("Uploaded Images").foregroundColor(Theme.onPrimaryColor)) {
                            ForEach(uploadManager.uploadedResumes) { resume in
                                VStack(alignment: .leading) {
                                    Text(resume.fileName)
                                        .font(.headline)
                                        .foregroundColor(Theme.onPrimaryColor)
                                    Text("\(resume.fileSize / 1024) KB")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                            .listRowBackground(Theme.backgroundColor)
                        }
                    }
                }
                .background(RoundedRectangle(cornerRadius: 24)
                                .stroke(style: StrokeStyle(lineWidth: 1, dash: [12]))
                                .foregroundColor(Theme.secondaryColor))
                .scrollContentBackground(.hidden)
                .background(Theme.backgroundColor)
                .cornerRadius(12)
                .padding()

                if uploadManager.isProcessingUpload {
                    ProgressView(
                        "Uploading...",
                        value: uploadManager.uploadProgressValue, total: 1.0
                    )
                    .padding()
                }

                VStack {
                    Button(action: {
                        isPhotoPickerPresented = true // Directly trigger photo picker
                    }) {
                        Text("Add Image")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.clear)
                            .overlay(RoundedRectangle(cornerRadius: 8)
                                .stroke(Theme.onPrimaryColor, lineWidth: 1))
                            .foregroundColor(Theme.onPrimaryColor)
                            .cornerRadius(8)
                    }

                    Button(action: {
                        // Trigger upload and navigation when button is clicked
                        Task {
                            await uploadManager.uploadallFiles()
                            navigationTrue = true
                        }
                    }) {
                        Text("Upload")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                uploadManager.isProcessingUpload
                                ? Color.gray : Theme.primaryColor
                            )
                            .foregroundColor(Theme.onPrimaryColor)
                            .cornerRadius(8)
                    }
                    .disabled(
                        uploadManager.isProcessingUpload
                            || uploadManager.selectedResumes.isEmpty
                    )
                }
                .padding()
            }
            .sheet(isPresented: $isPhotoPickerPresented) {
                PhotoPicker { url in
                    if let url = url {
                        uploadManager.addSelectedResume(fileURL: url) // Add image to selected list
                    }
                }
            }
            .background(
                NavigationLink(
                    destination: LocationClientiew(),
                    isActive: $navigationTrue
                ) {
                    EmptyView()
                }
            )
        }
    }
}

#Preview {
    WorkPitcher()
}
