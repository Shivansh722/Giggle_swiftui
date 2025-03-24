import SwiftUI

struct JobCardView: View {
    let jobs: [String: Any]
    let flnID: String?
    @StateObject var fetchImage = JobPost(appService: AppService())
    @State private var base64Image: String?
    @State private var isLoadingImage = false
    @State private var imageError: String?
    @State private var showSnackbar: Bool = false // State for snackbar visibility
    
    private var isLocked: Bool {
        flnID == nil
    }
    
    // Mask salary for locked jobs
    private func maskedSalary(_ salary: String) -> String {
        if isLocked {
            guard salary.count > 3 else { return salary }
            let prefix = String(salary.dropLast(3))
            return "\(prefix)xxx"
        }
        return salary
    }
    
    var body: some View {
        ZStack {
            // NavigationLink for the job card
            NavigationLink(
                destination: GigInfoView(jobId: "\(jobs["$id"]!)", jobs: jobs, base64Image: base64Image),
                isActive: .constant(!isLocked) // Disable navigation when locked
            ) {
                VStack {
                    VStack(spacing: 16) {
                        HStack(alignment: .center) {
                            HStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(Color.purple.opacity(0.2))
                                        .frame(width: 48, height: 48)
                                    
                                    if isLoadingImage {
                                        ProgressView()
                                            .frame(width: 24, height: 24)
                                    } else if let base64 = base64Image,
                                              let data = Data(base64Encoded: base64),
                                              let uiImage = UIImage(data: data) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                            .foregroundColor(.black)
                                    } else {
                                        Image("mcD")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                            .foregroundColor(.black)
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("\(jobs["job_title"]!)")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.white)
                                    
                                    Text("\(jobs["companyName"]!) · ")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color.gray) +
                                    Text("\(jobs["location"]!)")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color.gray)
                                }
                            }
                            
                            Spacer()
                        }
                        
                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text(maskedSalary("\(jobs["salary"]!)"))
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                            Text("/Mo")
                                .font(.system(size: 16))
                                .foregroundColor(Color.gray)
                        }
                        .padding(.top, -8)
                        
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
                    .padding()
                    .background(Theme.backgroundColor)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0, y: 4)
                    .padding(.horizontal, 16)
                    .overlay(
                        Group {
                            if isLocked {
                                VStack {
                                    HStack {
                                        Spacer()
                                        HStack(spacing: 4) {
                                            Image(systemName: "lock.fill")
                                                .foregroundColor(.white)
                                                .frame(width: 16, height: 16)
                                            Text("Locked")
                                                .font(.system(size: 12, weight: .medium))
                                                .foregroundColor(.white)
                                        }
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.red.opacity(0.5))
                                        .cornerRadius(12)
                                    }
                                    .padding(.trailing, 18)
                                    Spacer()
                                }
                                .padding(8)
                            }
                        }
                    )
                    .opacity(isLocked ? 0.7 : 1.0) // Add opacity when locked
                }
                .onTapGesture {
                    if isLocked {
                        showSnackbar = true // Show snackbar when locked tile is tapped
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showSnackbar = false // Hide after 2 seconds
                        }
                    }
                }
                .disabled(isLocked) // Disable interaction when locked
                .onAppear {
                    Task {
                        do {
                            let base64 = try await fetchImage.fetchImage("\(jobs["$id"]!)")
                            self.base64Image = base64
                            self.isLoadingImage = false
                        } catch {
                            self.imageError = error.localizedDescription
                            self.isLoadingImage = false
                        }
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            // Snackbar overlay
        }
    }
}

// Preview
#Preview {
    let sampleJobs: [String: Any] = [
        "$id": "123",
        "job_title": "Software Engineer",
        "companyName": "Tech Corp",
        "location": "San Francisco, CA",
        "salary": "$12000",
        "job_trait": "Remote",
        "job_type": "Full-time"
    ]
    
    VStack {
        JobCardView(jobs: sampleJobs, flnID: "someID") // Unlocked
        JobCardView(jobs: sampleJobs, flnID: nil)     // Locked
    }
    .preferredColorScheme(.dark)
}
