//
//  work-picture-upload-view.swift
//  Giggle_swiftui
//
//  Created by rjk on 14/01/25.
//

import SwiftUI
import UIKit

struct WorkPictureUploadView: View {
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage? = nil
    @State private var workPictures: [UIImage] = []

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 20) {  // Reduced spacing
                // Title
                Text("Upload Work Pictures")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 20)
                
                // Work Picture Upload Section
                VStack(spacing: 16) {
                    Text("Upload images of your past work to showcase your skills.")
                        .foregroundColor(Color(hex: "95969D"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)

                    if workPictures.isEmpty {
                        Text("Upload JPEG/PNG images")
                            .foregroundColor(Color(hex: "424242"))
                            .padding()
                            .frame(maxWidth: geometry.size.width * 0.7, maxHeight: geometry.size.height * 0.1)
                            .background(RoundedRectangle(cornerRadius: 12).foregroundColor(.white))
                            .padding(.top, 10)
                    } else {
                        ScrollView {
                            VStack(spacing: 10) {
                                ForEach(workPictures.indices, id: \.self) { index in
                                    HStack {
                                        Image(uiImage: workPictures[index])
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                            .cornerRadius(8)
                                        
                                        Text("Work Image \(index + 1)")
                                            .font(.body)
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            workPictures.remove(at: index)
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.red)
                                        }
                                    }
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 12).foregroundColor(.white))
                                    .frame(maxWidth: geometry.size.width * 0.7)
                                }
                            }
                        }
                        .frame(minHeight: 0, maxHeight: geometry.size.height * 0.5) // Prevents excessive white space
                        .padding(.top, 10)
                    }
                    
                    Button(action: {
                        showImagePicker = true
                    }) {
                        Text(workPictures.isEmpty ? "Upload" : "Add More")
                            .padding()
                            .frame(maxWidth: geometry.size.width * 0.5)
                            .background(Theme.primaryColor)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 24)
                                .stroke(style: StrokeStyle(lineWidth: 1, dash: [12]))
                                .foregroundColor(Theme.secondaryColor))
                
                Spacer()  // Pushes content up to avoid white space

                Button(action: {
                    print("Saved Work Pictures: \(workPictures.count)")
                }) {
                    Text("NEXT")
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Theme.primaryColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.bottom, 20) // Adds a slight bottom padding
            }
            .frame(maxHeight: .infinity, alignment: .top) // Ensures everything stays at the top
            .padding()
            .background(Theme.backgroundColor.edgesIgnoringSafeArea(.all))
        }
    }
}

#Preview {
    WorkPictureUploadView()
}
