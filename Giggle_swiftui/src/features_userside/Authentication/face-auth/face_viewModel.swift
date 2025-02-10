//
//  face_viewModel.swift
//  Giggle_swiftui
//
//  Created by user@91 on 07/01/25.
//
import SwiftUI
import AVFoundation
class CameraViewModel: ObservableObject {
    private var session = AVCaptureSession()
    @Published var previewLayer: AVCaptureVideoPreviewLayer?

    func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    self?.setupSession()
                }
            }
        default:
            print("Permission denied")
        }
    }

    private func setupSession() {
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else { return }
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            if session.canAddInput(input) {
                session.addInput(input)
            }

            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.videoGravity = .resizeAspectFill
            self.previewLayer = previewLayer

        } catch {
            print("Error setting up camera input: \(error.localizedDescription)")
        }
    }

    func startSession() {
        session.startRunning()
    }

    func stopSession() {
        session.stopRunning()
    }
}




