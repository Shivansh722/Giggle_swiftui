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
    @State private var isSkipped = false
    @State private var navigate = false

    var body: some View {
        ZStack {
            Theme.backgroundColor
                .edgesIgnoringSafeArea(.all)

            VStack(alignment: .leading) {
                HStack {
                    HStack() {
                        Text("Upload")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Theme.primaryColor)
                        Text("Resume")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Theme.onPrimaryColor)
                    }
                    .padding(.leading, 24)
                    .padding(.top, 6)
                    Spacer()
                    Button(action: {
                        Task{
                            let resume = """
                            Amritesh Kumar, Email: amriteshk778@gmail.com, Phone: 9158188174, GitHub: github.com/AMRITESH240304. 
                            Education: B.Tech in CSE - Software Engineering, S.R.M Institute of Science and Technology (09/2022 – present), Chennai, India. 
                            Skills: Development - FastAPI, Express.js, Node.js, MongoDB + VectorDB, LangChain, AWS Bedrock, CrewAI, SwiftUI, Next.js. 
                            Programming Languages: Python, Swift, JavaScript, C++. 
                            """
                            FormManager.shared.formData.resume = resume
                        }
                        navigate = true
                    }) {
                        Text("Skip")
                            .font(.headline)
                            .foregroundColor(Theme.onPrimaryColor)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(Theme.primaryColor)
                            .cornerRadius(8)
                    }
                    .padding(.trailing, 24)
                    .padding(.top, 6)
                }

                // Info Container
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "info.circle")
                        .foregroundColor(Theme.secondaryColor)
                        .font(.system(size: 20))
                    Text("We’ll extract your name, education, experience and other details from your resume to pre-fill your profile.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
                .cornerRadius(8)
                .padding(.bottom, 12)

                List {
                    if !uploadManager.selectedResumes.isEmpty {
                        Section(header: Text("Selected Resumes").foregroundColor(Theme.onPrimaryColor)) {
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
                        Section(header: Text("Uploaded Resumes").foregroundColor(Theme.onPrimaryColor)) {
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
                .padding([.leading, .trailing, .bottom])

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
                            .background(Color.clear)
                            .overlay(RoundedRectangle(cornerRadius: 8)
                                .stroke(Theme.onPrimaryColor, lineWidth: 1))
                            .foregroundColor(Theme.onPrimaryColor)
                            .cornerRadius(8)
                    }

                    Button(action: {
                        uploadManager.uploadAllSelectedResumes()
                    }) {
                        if uploadManager.isProcessingUpload {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Theme.onPrimaryColor))
                        } else {
                            Text("Upload All")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(uploadManager.selectedResumes.isEmpty ? Color.gray : Theme.primaryColor)
                    .foregroundColor(Theme.onPrimaryColor)
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
        .navigationBarHidden(true)
    }
}

#Preview {
    ResumeUpload()
}
