//
//  FilePickerView.swift
//  Giggle_swiftui
//
//  Created by rjk on 16/01/25.
//

import SwiftUI
import UniformTypeIdentifiers
import Foundation
import PhotosUI

struct DocumentPicker: UIViewControllerRepresentable {
    var onPick: (URL?) -> Void
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf, UTType.text, UTType.data])
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPicker
        
        init(_ parent: DocumentPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.onPick(urls.first)
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.onPick(nil)
        }
    }
}

struct PhotoPicker: UIViewControllerRepresentable {
    var onPick: (URL?) -> Void
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoPicker
        
        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider else {
                parent.onPick(nil)
                return
            }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { url, error in
                    if let url = url, error == nil {
                        // Create a copy in temporary directory since photo URLs are temporary
                        let fileManager = FileManager.default
                        let tempURL = fileManager.temporaryDirectory.appendingPathComponent(url.lastPathComponent)
                        do {
                            if fileManager.fileExists(atPath: tempURL.path) {
                                try fileManager.removeItem(at: tempURL)
                            }
                            try fileManager.copyItem(at: url, to: tempURL)
                            DispatchQueue.main.async {
                                self.parent.onPick(tempURL)
                            }
                        } catch {
                            print("Error copying image: \(error)")
                            DispatchQueue.main.async {
                                self.parent.onPick(nil)
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.parent.onPick(nil)
                        }
                    }
                }
            }
        }
    }
}
