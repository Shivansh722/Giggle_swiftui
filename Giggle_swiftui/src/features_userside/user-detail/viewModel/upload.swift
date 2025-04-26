import Appwrite
import Foundation
import PDFKit
import SwiftUI
import UniformTypeIdentifiers

class ResumeUploadManager: ObservableObject {
    @Published var uploadedResumes: [ResumeFile] = []  // Uploaded resumes
    @Published var selectedResumes: [ResumeFile] = []  // Resumes selected but not yet uploaded
    @Published var isProcessingUpload = false  // Tracks upload status
    @Published var uploadProgressValue: Double = 0.0  // Progress of the upload
    @Published var navigationTrigger = false
    let userDetailAutoView = UserDetailAutoView()

    private let appwriteClient: Client
    private let appwriteStorage: Storage
    private let appwriteBucketId: String

    init(apiEndpoint: String, projectIdentifier: String, storageBucketId: String) {
        self.appwriteClient = Client()
            .setEndpoint(apiEndpoint)
            .setProject(projectIdentifier)
        self.appwriteStorage = Storage(appwriteClient)
        self.appwriteBucketId = storageBucketId
    }

    func addSelectedResume(fileURL: URL) {
        let resumeName = fileURL.lastPathComponent
        let resumeSize = calculateFileSize(fileURL: fileURL)
        selectedResumes.append(
            ResumeFile(
                id: UUID(),
                fileName: resumeName,
                fileSize: resumeSize,
                fileURL: fileURL // Store the URL object instead of path string
            )
        )
    }

    func uploadAllSelectedResumes() {
        guard !isProcessingUpload else { return }
        isProcessingUpload = true
        uploadProgressValue = 0.0

        Task {
            for resume in selectedResumes {
                FormManager.shared.formData.resumeIds.append(resume.id.uuidString)
                do {
                    // Start accessing the security-scoped resource
                    let didStartAccessing = resume.fileURL.startAccessingSecurityScopedResource()
                    defer {
                        // Stop accessing when done (even if an error occurs)
                        if didStartAccessing {
                            resume.fileURL.stopAccessingSecurityScopedResource()
                        }
                    }

                    guard let inputResume = try? InputFile.fromPath(resume.fileURL.path) else {
                        print("Failed to create InputFile for \(resume.fileName)")
                        continue
                    }

                    let uploadedResume = try await appwriteStorage.createFile(
                        bucketId: appwriteBucketId,
                        fileId: resume.id.uuidString,
                        file: inputResume,
                        onProgress: { progress in
                            DispatchQueue.main.async {
                                self.uploadProgressValue = progress.progress
                            }
                        }
                    )

                    DispatchQueue.main.async {
                        print("Uploaded: \(uploadedResume)")
                        self.uploadedResumes.append(resume)
                        self.extractTextFromPDF(resume: resume)
                    }
                } catch {
                    print("Failed to upload \(resume.fileName): \(error.localizedDescription)")
                }
            }

            DispatchQueue.main.async {
                self.selectedResumes.removeAll()
                
            }
        }
    }

    func updateResume() async throws {
        for resume in selectedResumes {
            FormManager.shared.formData.resumeIds.append(resume.id.uuidString)
            do {
                // Start accessing the security-scoped resource
                let didStartAccessing = resume.fileURL.startAccessingSecurityScopedResource()
                defer {
                    if didStartAccessing {
                        resume.fileURL.stopAccessingSecurityScopedResource()
                    }
                }

                guard let inputResume = try? InputFile.fromPath(resume.fileURL.path) else {
                    print("Failed to create InputFile for \(resume.fileName)")
                    continue
                }

                let uploadedResume = try await appwriteStorage.createFile(
                    bucketId: appwriteBucketId,
                    fileId: resume.id.uuidString,
                    file: inputResume
                )
                
                extractTextFromPDF(resume: resume)

                print("upload things", uploadedResume.id)
                try await SaveUserInfo(appService: AppService()).updateUserInfoResume()
            } catch {
                print(error)
            }
        }
    }

    func uploadallFiles() {
        guard !isProcessingUpload else { return }
        isProcessingUpload = true
        uploadProgressValue = 0.0

        Task {
            for resume in selectedResumes {
                ClientFormManager.shared.clientData.photos.append(resume.id.uuidString)
                do {
                    // Start accessing the security-scoped resource
                    let didStartAccessing = resume.fileURL.startAccessingSecurityScopedResource()
                    defer {
                        if didStartAccessing {
                            resume.fileURL.stopAccessingSecurityScopedResource()
                        }
                    }

                    guard let inputResume = try? InputFile.fromPath(resume.fileURL.path) else {
                        print("Failed to create InputFile for \(resume.fileName)")
                        continue
                    }

                    let uploadedResume = try await appwriteStorage.createFile(
                        bucketId: appwriteBucketId,
                        fileId: resume.id.uuidString,
                        file: inputResume,
                        onProgress: { progress in
                            DispatchQueue.main.async {
                                self.uploadProgressValue = progress.progress
                            }
                        }
                    )

                    DispatchQueue.main.async {
                        print("Uploaded: \(uploadedResume)")
                        self.uploadedResumes.append(resume)
                        self.navigationTrigger = true
                    }
                } catch {
                    print("Failed to upload \(resume.fileName): \(error.localizedDescription)")
                }
            }
        }
    }

    func removeSelectedResume(_ resume: ResumeFile) {
        selectedResumes.removeAll { $0.id == resume.id }
    }

    func extractTextFromPDF(resume: ResumeFile) {
        // Start accessing the security-scoped resource for PDF extraction
        let didStartAccessing = resume.fileURL.startAccessingSecurityScopedResource()
        defer {
            if didStartAccessing {
                resume.fileURL.stopAccessingSecurityScopedResource()
            }
        }

        guard let pdfDocument = PDFDocument(url: resume.fileURL) else {
            print("Failed to open PDF document: \(resume.fileName)")
            return
        }

        var fullText = ""
        for pageIndex in 0..<pdfDocument.pageCount {
            if let page = pdfDocument.page(at: pageIndex),
               let pageText = page.string {
                fullText += pageText + "\n"
            }
        }

        DispatchQueue.main.async { [self] in
            print("Extracted text for \(resume.fileName): \(fullText)")
            FormManager.shared.formData.resume = fullText
            Task {
                let generatedText = await userDetailAutoView.generateTextForPrompt(promptText: fullText)
                userDetailAutoView.storeResumeToUserDefaults(jsonString: generatedText)
                DispatchQueue.main.async {
                    UserPreference.shared.shouldLoadUserDetailsAutomatically = true
                    self.isProcessingUpload = false
                    self.navigationTrigger = true
                }
            }
        }
    }

    private func calculateFileSize(fileURL: URL) -> Int {
        // Start accessing the security-scoped resource for file size calculation
        let didStartAccessing = fileURL.startAccessingSecurityScopedResource()
        defer {
            if didStartAccessing {
                fileURL.stopAccessingSecurityScopedResource()
            }
        }

        do {
            let fileAttributes = try fileURL.resourceValues(forKeys: [.fileSizeKey])
            return fileAttributes.fileSize ?? 0
        } catch {
            print("Failed to calculate file size: \(error)")
            return 0
        }
    }
}

struct ResumeFile: Identifiable {
    let id: UUID
    let fileName: String
    let fileSize: Int  // File size in bytes
    let fileURL: URL   // Changed from localPath: String to fileURL: URL
}
