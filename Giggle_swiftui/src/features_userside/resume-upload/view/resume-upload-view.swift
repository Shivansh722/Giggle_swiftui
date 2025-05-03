//
//  resume-upload-view.swift
//  Giggle_swiftui
//
//  Created by rjk on 14/01/25.
//

import SwiftUI
import Appwrite

struct ResumeUploadView: View {
    @StateObject private var viewModel = ResumeUploadViewModel(
        endpoint: "https://[APPWRITE_ENDPOINT]",
        projectId: "[PROJECT_ID]",
        bucketId: "[BUCKET_ID]"
    )
    @State private var showDocumentPicker = false

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 30) {
                // Title
                Text("Resume & Portfolio")
                    .font(.headline)
                    .foregroundColor(Theme.onPrimaryColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 20)
                
                // Resume or CV Section
                VStack(spacing: 16) {
                    ZStack(alignment: .bottom) {
                        VStack(spacing: 16) {
                            Text("Upload your CV or Resume and use it when you are applying for gigs")
                                .foregroundColor(Color(hex: "95969D"))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 30)
                                .padding(.top, 40)

                            if viewModel.files.isEmpty {
                                Text("Upload a PDF/JPEG/PNG")
                                    .foregroundColor(Color(hex: "424242"))
                                    .padding()
                                    .frame(maxWidth: geometry.size.width * 0.7, maxHeight: geometry.size.height * 0.1)
                                    .background(RoundedRectangle(cornerRadius: 12).foregroundColor(Theme.onPrimaryColor))
                                    .padding(.top, 35)
                            } else {
                                ForEach(viewModel.files) { file in
                                    HStack {
                                        Image(systemName: "doc.richtext")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 24, height: 24)
                                            .foregroundColor(.red)
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(file.name)
                                                .font(.body)
                                                .lineLimit(1)
                                            Text("\(file.size) KB")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        
                                        Spacer()
                                        
                                        Button(action: { viewModel.removeFile(file) }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.red)
                                        }
                                    }
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 12).foregroundColor(Theme.onPrimaryColor))
                                    .frame(maxWidth: geometry.size.width * 0.7)
                                    .padding(.top, 35)
                                }
                            }
                            
                            Button(action: {
                                showDocumentPicker = true
                            }) {
                                Text(viewModel.files.isEmpty ? "Upload" : "Add More")
                                    .padding()
                                    .frame(maxWidth: geometry.size.width * 0.5)
                                    .background(Theme.primaryColor)
                                    .foregroundColor(Theme.onPrimaryColor)
                                    .cornerRadius(8)
                                    .padding(.vertical, 20)
                            }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 24)
                                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [12]))
                                        .foregroundColor(Theme.secondaryColor))
                    }
                }
                .sheet(isPresented: $showDocumentPicker) {
                    DocumentPicker { url in
                        guard let url = url else { return }
                        viewModel.selectedFilePath = url.path
                        viewModel.selectedFileName = url.lastPathComponent
                        viewModel.startUpload()
                    }
                }
                
                // Portfolio Section
                VStack(spacing: 16) {
                    Text("Portfolio (Optional)")
                        .font(.headline)
                        .foregroundColor(Theme.onPrimaryColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Enter your portfolio link:")
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "A2A2A2"))
                        
                        TextField("", text: $viewModel.portfolioLink, prompt: Text("e.g., https://myportfolio.com").foregroundStyle(.gray))
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(hex: "A2A2A2"), lineWidth: 1)
                            )
                            .autocapitalization(.none)
                            .keyboardType(.URL)
                    }
                    
                    HStack {
                        Button(action: {}) {
                            Text("Add Photos")
                                .padding()
                                .foregroundColor(Theme.onPrimaryColor)
                                .fontWeight(Font.Weight.medium)
                                .frame(maxWidth: .infinity)
                                .background(RoundedRectangle(cornerRadius: 16)
                                    .stroke(style: StrokeStyle(lineWidth: 1))
                                )
                                
                                .foregroundColor(Color(hex: "A2A2A2"))
                        }
                        Button(action: {}) {
                            Text("Add PDF")
                                .padding()
                                .foregroundColor(Theme.onPrimaryColor)
                                .fontWeight(Font.Weight.medium)
                                .frame(maxWidth: .infinity)
                                .background(RoundedRectangle(cornerRadius: 16)
                                    .stroke(style: StrokeStyle(lineWidth: 1))
                                )
                            
                                .foregroundColor(Color(hex: "A2A2A2"))
                        }
                    }
                    .padding(.top,5)
                }
                .padding(.top, 20)
                
                Button(action: {}) {
                    Text("Save")
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Theme.primaryColor)
                        .foregroundColor(Theme.onPrimaryColor)
                        .cornerRadius(8)
                }
                .padding(.top, 15)
            }
            .padding()
            .background(Theme.backgroundColor.edgesIgnoringSafeArea(.all))
        }
    }
}



#Preview {
    ResumeUploadView()
}
