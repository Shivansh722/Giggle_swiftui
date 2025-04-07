import SwiftUI

struct JobCardView: View {
    let jobs: [String: Any]
    let flnID: String?
    @StateObject var fetchImage = JobPost(appService: AppService())
    @State private var base64Image: String?
    @State private var isLoadingImage = false
    @State private var imageError: String?

    var body: some View {
        NavigationLink(
            destination: GigInfoView(fln: flnID ?? nil,jobId: "\(jobs["$id"]!)", jobs: jobs,base64Image:base64Image)
        ) {
            VStack {
                // Card View
                VStack(spacing: 16) {
                    HStack(alignment: .center) {
                        // Logo and Text
                        HStack(spacing: 12) {
                            ZStack {

                                if isLoadingImage {
                                    ProgressView()
                                        .frame(width: 24, height: 24)
                                } else if let base64 = base64Image,
                                    let data = Data(base64Encoded: base64),
                                    let uiImage = UIImage(data: data)
                                {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                        .foregroundColor(.black)
                                        .scaledToFill()
                                } else {
                                    Image(systemName: "person.crop.circle")  // Fallback image
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                        .foregroundColor(.black)
                                }
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                let keysString = jobs["job_title"]!
                                Text("\(keysString)")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                    Text("\(jobs["companyName"]!) . ")
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
                        Text("$\(jobs["salary"]!)")
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

                if flnID == nil {
                    Image(systemName: "lock.fill")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(.red)
                        .padding(8)
                        .background(Color.white.opacity(0.8))
                        .clipShape(Circle())
                        .offset(x: 0, y: -10)
                }
            }
            .onAppear {
                DispatchQueue.main.async{
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
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct JobDetailView: View {
    let jobId: String
    let jobs: [String: Any]

    var body: some View {
        Text("Job ID: \(jobId)")
            .font(.largeTitle)
            .padding()
    }
}
