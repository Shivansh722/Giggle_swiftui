import Appwrite
import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct WorkPitcher: View {
    @StateObject private var uploadManager = ResumeUploadManager(
        apiEndpoint: "https://cloud.appwrite.io/v1",
        projectIdentifier: "677299c0003044510787",
        storageBucketId: "67863b500019e5de0dd8"
    )

    @State private var isFilePickerPresented = false
    @State private var isProcessingComplete = false

    var body: some View {
            ZStack {
                Theme.backgroundColor
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Text("Upload Resume")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)

                    List {
                        if !uploadManager.selectedResumes.isEmpty {
                            Section(header: Text("Selected Resumes").foregroundColor(.white)) {
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
                            Section(header: Text("Uploaded Resumes").foregroundColor(.white)) {
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
                            isFilePickerPresented = true
                        }) {
                            Text("Add Resume")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }

                        Button(action: {
                            uploadManager.uploadallFiles()
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
                                || uploadManager.selectedResumes.isEmpty)
                    }
                    .padding()
                }
                .sheet(isPresented: $isFilePickerPresented) {
                    DocumentPicker { url in
                        if let url = url {
                            uploadManager.addSelectedResume(fileURL: url)
                        }
                    }
                }
                .background(
                                    NavigationLink(
                                        destination: LocationClientiew(),
                                        isActive: $uploadManager.navigationTrigger
                                    ) {
                                        EmptyView()
                                    }
                                )
            }
    }
}

#Preview {
    ResumeUpload()
}
