import Appwrite
import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct ResumeUpload: View {
    @StateObject private var uploadManager = ResumeUploadManager(
        apiEndpoint: "https://cloud.appwrite.io/v1",
        projectIdentifier: "67da77af003e5e94f856",
        storageBucketId: "67da7d55000bf31fb062"
    )

    @State private var isFilePickerPresented = false
    @State private var isProcessingComplete = false
    @State private var isSkipped = false  // State to trigger navigation when skipping
    @State private var navigate = false

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

                NavigationLink(
                    destination: UserInfoView(),
                    isActive: $navigate
                ) {
                    EmptyView()
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
                        uploadManager.uploadAllSelectedResumes()
                    }) {
                        if uploadManager.isProcessingUpload {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Upload All")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(uploadManager.selectedResumes.isEmpty ? Color.gray : Color.green) // Dynamically change color
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .disabled(uploadManager.isProcessingUpload || uploadManager.selectedResumes.isEmpty)
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
                    destination: UserInfoView(),
                    isActive: $uploadManager.navigationTrigger
                ) {
                    EmptyView()
                }
            )
        }
        .navigationBarHidden(true) // Hide navigation bar completely
    }
}

#Preview {
    ResumeUpload()
}
