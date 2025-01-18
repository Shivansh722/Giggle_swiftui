//
//  resume-upload-view-model.swift
//  Giggle_swiftui
//
//  Created by rjk on 18/01/25.
//

import SwiftUI
import Appwrite
import UniformTypeIdentifiers

class ResumeUploadViewModel: ObservableObject {
    @Published var files: [UploadedFile] = [] // List of uploaded files
    @Published var isUploading = false // Tracks upload status
    @Published var uploadProgress: Double = 0.0 // Progress of the upload
    @Published var selectedFileName: String = "" // Name of the selected file
    @Published var selectedFilePath: String? = nil // Path of the selected file
    @Published var portfolioLink: String = ""
    
    private let client: Client
    private let storage: Storage
    private let bucketId: String
    
    init(endpoint: String, projectId: String, bucketId: String) {
        self.client = Client()
            .setEndpoint(endpoint)
            .setProject(projectId)
        self.storage = Storage(client)
        self.bucketId = bucketId
    }
    
    func startUpload() {
        guard let filePath = selectedFilePath, !isUploading else { return }
        
        isUploading = true
        uploadProgress = 0.0
        
        let fileName = URL(fileURLWithPath: filePath).lastPathComponent
        
        guard let inputFile = try? InputFile.fromPath(filePath) else {
            print("Failed to create InputFile from the path.")
            isUploading = false
            return
        }
        
        Task {
            do {
                let file = try await storage.createFile(
                    bucketId: bucketId,
                    fileId: "unique()",
                    file: inputFile,
                    onProgress: { progress in
                        DispatchQueue.main.async {
                            // Update progress based on the `progress` property
                            self.uploadProgress = progress.progress
                        }
                    }
                )
                
                DispatchQueue.main.async {
                    print("Upload successful: \(file)")
                    self.files.append(UploadedFile(name: fileName, size: 0))
                    self.isUploading = false
                }
            } catch {
                DispatchQueue.main.async {
                    print("Upload failed: \(error.localizedDescription)")
                    self.isUploading = false
                }
            }
        }
    }



    func removeFile(_ file: UploadedFile) {
        files.removeAll { $0.id == file.id }
    }
}

struct UploadedFile: Identifiable {
    let id = UUID() // Unique identifier for each uploaded file
    let name: String // File name
    let size: Int // File size in KB
}
