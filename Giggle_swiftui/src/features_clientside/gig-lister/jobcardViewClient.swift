import SwiftUI

struct JobCardView2: View {
    let jobs: [String: Any]
    let flnID: String?
    let onDelete: () -> Void
    
    @State private var base64Image: String?
    @State private var isLoadingImage = false
    @State private var imageError: String?
    @State private var showDeleteConfirmation = false
    @StateObject private var deleteJob = ClientHandlerUserInfo(appService: AppService())

    private var jobTitle: String {
        String(jobs["job_title"]! as! String)
    }
    
    private var companyInfo: Text {
        Text("\(jobs["companyName"]!) . ")
            .font(.system(size: 14))
            .foregroundColor(Color.gray) +
        Text("\(jobs["location"]!)")
            .font(.system(size: 14))
            .foregroundColor(Color.gray)
    }
    
    private var salaryInfo: some View {
        HStack(alignment: .firstTextBaseline, spacing: 4) {
            Text("$\(jobs["salary"]!)")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            Text("/Mo")
                .font(.system(size: 16))
                .foregroundColor(Color.gray)
        }
    }
    
    private var jobTags: some View {
        HStack {
            HStack(spacing: 8) {
                Text("\(jobs["job_trait"]!)")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(16)

                Text("\(jobs["job_type"]!)")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(16)
            }
            Spacer()
            Text("2 days ago")
                .font(.system(size: 14))
                .foregroundColor(Color.gray)
        }
    }

    var body: some View {
        VStack {
            VStack(spacing: 16) {
                // Header Section
                HStack(alignment: .center) {
                    HStack(spacing: 12) {
                        ZStack {
                            if isLoadingImage {
                                ProgressView()
                                    .frame(width: 24, height: 24)
                            } else if let base64 = base64Image,
                                      let data = Data(base64Encoded: base64),
                                      let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(jobTitle)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                            companyInfo
                        }
                        
                        Spacer()
                        
                        Button(action: { showDeleteConfirmation = true }) {
                            Image(systemName: "trash")
                        }
                        .buttonStyle(.bordered)
                        .tint(.red)
                        .alert("Delete Item", isPresented: $showDeleteConfirmation) {
                            Button("Cancel", role: .cancel) { }
                            Button("Delete", role: .destructive) {
                                Task {
                                    try await deleteJob.deleteClientJob(jobs["$id"] as? String ?? "")
                                    onDelete()
                                }
                            }
                        } message: {
                            Text("Are you sure you want to delete this item?")
                        }
                    }
                }
                
                salaryInfo
                    .padding(.top, -8)
                
                jobTags
            }
            .padding()
            .background(Theme.backgroundColor)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0, y: 4)
            .padding(.horizontal, 16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
