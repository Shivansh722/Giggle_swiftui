//
//  face.swift
//  Giggle_swiftui
//
//  Created by user@91 on 07/01/25.
//

import SwiftUI
import AVFoundation


struct CameraView: View {
    @StateObject private var viewModel = CameraViewModel()
    @State private var isScanning = false

    var body: some View {
        ZStack {
            CameraPreviewView(previewLayer: viewModel.previewLayer)
                .edgesIgnoringSafeArea(.all)

            if isScanning {
                ScanningOverlayView()
            }

            VStack {
                            Spacer()
                            HStack {
                                Button(action: {
                                    isScanning = false
                                    viewModel.stopSession()
                                }) {
                                    Text("Cancel")
                                        .font(.headline)
                                        .frame(width: 100, height: 50)
                                        .background(Color.red)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }

                                Spacer()

                                Button(action: {
                                    isScanning.toggle()
                                    if isScanning {
                                        viewModel.startSession()
                                    }
                                }) {
                                    Text(isScanning ? "Stop" : "Start")
                                        .font(.headline)
                                        .frame(width: 100, height: 50)
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                            }
                            .padding()
                            .background(Color.black.opacity(0.5)) // Add a background to make buttons stand out
                        }
                        .padding(.horizontal)
                    }
                    .onAppear {
                        viewModel.checkPermissions()
                    }
    }
}

func generateRandomPosition() -> CGPoint {
    CGPoint(x: CGFloat.random(in: 100...300), y: CGFloat.random(in: 200...400))
}


struct ScanningOverlayView: View {
    var body: some View {
        ZStack {
            Color.clear
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.green, lineWidth: 3)
                        .frame(width: 200, height: 200)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.green.opacity(0.2))
                        )
                )

            ForEach(Array(0..<5), id: \.self) { _ in
                Circle()
                    .fill(Color.green)
                    .frame(width: 10, height: 10)
                    .position(generateRandomPosition())
                    .animation(.easeInOut(duration: 0.8).repeatForever(), value: UUID())
            }

        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct CameraPreviewView: UIViewRepresentable {
    let previewLayer: AVCaptureVideoPreviewLayer?

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        if let layer = previewLayer {
            layer.frame = UIScreen.main.bounds
            view.layer.addSublayer(layer)
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

#Preview { ScanningOverlayView() }
