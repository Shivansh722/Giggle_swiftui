import Appwrite
import Foundation
import SwiftUI
import UniformTypeIdentifiers
import PhotosUI

struct WorkPitcher: View {
    @StateObject private var uploadManager = ResumeUploadManager(
        apiEndpoint: "https://cloud.appwrite.io/v1",
        projectIdentifier: "67da77af003e5e94f856",
        storageBucketId: "67da7d55000bf31fb062"
    )

    @State private var isFilePickerPresented = false
    @State private var isPhotoPickerPresented = false
    @State private var showPickerChoice = false
    @State private var navigationTrue: Bool = false

    var body: some View {
        ZStack {
            Theme.backgroundColor
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("Upload Work Files & Images")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)

                List {
                    if !uploadManager.selectedResumes.isEmpty {
                        Section(header: Text("Selected Files").foregroundColor(.white)) {
                            ForEach(uploadManager.selectedResumes) { resume in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(resume.fileName)
                                            .font(.headline)
                                            .foregroundColor(.white)
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
                        Section(header: Text("Uploaded Files").foregroundColor(.white)) {
                            ForEach(uploadManager.uploadedResumes) { resume in
                                VStack(alignment: .leading) {
                                    Text(resume.fileName)
                                        .font(.headline)
                                        .foregroundColor(.white)
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
                        showPickerChoice = true
                    }) {
                        Text("Add File or Image")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }

                    Button(action: {
                        // Trigger upload and navigation when button is clicked
                        Task {
                            await uploadManager.uploadallFiles() // Assuming this is async
                            navigationTrue = true // Navigate after upload completes
                        }
                    }) {
                        Text("Upload All")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                uploadManager.isProcessingUpload
                                    ? Color.gray : Color.green
                            )
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .disabled(
                        uploadManager.isProcessingUpload
                            || uploadManager.selectedResumes.isEmpty
                    )
                }
                .padding()
            }
            .actionSheet(isPresented: $showPickerChoice) {
                ActionSheet(
                    title: Text("Select Source"),
                    buttons: [
                        .default(Text("Photos")) {
                            isPhotoPickerPresented = true
                        },
                        .default(Text("Files")) {
                            isFilePickerPresented = true
                        },
                        .cancel()
                    ]
                )
            }
            .sheet(isPresented: $isFilePickerPresented) {
                DocumentPicker { url in
                    if let url = url {
                        uploadManager.addSelectedResume(fileURL: url)
                    }
                }
            }
            .sheet(isPresented: $isPhotoPickerPresented) {
                PhotoPicker { url in
                    if let url = url {
                        uploadManager.addSelectedResume(fileURL: url) // Just add, no upload yet
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
