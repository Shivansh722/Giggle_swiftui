import SwiftUI

struct GuestJobCardView: View {
    let jobs: [String: Any]
    @StateObject var fetchImage = JobPost(appService: AppService())
    @State private var base64Image: String?
    @State private var isLoadingImage = false
    @State private var imageError: String?
    @State private var cardHover = false
    @State private var showLoginAlert = false
    @State private var navigateToRegister = false
    
    // Computed property to format the date
    private var relativePostTime: String {
        let createdAtString = jobs["$createdAt"]!

        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        guard let createdAtDate = isoFormatter.date(from: "\(createdAtString)") else {
            isoFormatter.formatOptions = [.withInternetDateTime]
            guard let fallbackDate = isoFormatter.date(from: "\(createdAtString)") else {
                 return "Recently"
            }
            return formatRelativeDate(fallbackDate)
        }
        
        return formatRelativeDate(createdAtDate)
    }
    
    private func formatRelativeDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }

    var body: some View {
        Button(action: {
            showLoginAlert = true
        }) {
            VStack {
                VStack(spacing: 18) {
                    HStack(alignment: .center, spacing: 14) {
                        ZStack {
                            if isLoadingImage {
                                Circle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 48, height: 48)
                                
                                ProgressView()
                                    .frame(width: 24, height: 24)
                            } else if let base64 = base64Image,
                                    let data = Data(base64Encoded: base64),
                                    let uiImage = UIImage(data: data)
                            {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 48, height: 48)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                                    .shadow(color: Color.black.opacity(0.1), radius: 2)
                            } else {
                                Circle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 48, height: 48)
                                
                                Image(systemName: "building.2.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            let jobTitle = jobs["job_title"] as? String ?? "Job Title"
                            HStack(alignment: .firstTextBaseline) {
                                Text(jobTitle)
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Theme.onPrimaryColor)
                                    .lineLimit(2)
                                
                                Spacer()

                                Text(relativePostTime)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(Color.gray.opacity(0.9))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Color.gray.opacity(0.15))
                                    .cornerRadius(12)
                                    .fixedSize(horizontal: true, vertical: false)
                            }
                            
                            HStack(spacing: 4) {
                                Text("\(jobs["companyName"]!)")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color.gray.opacity(0.9))
                                
                                Text("•")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color.gray.opacity(0.7))
                                
                                Text("\(jobs["location"]!)")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color.gray.opacity(0.9))
                                    .lineLimit(1)
                            }
                        }
                    }
                    
                    Divider()
                        .background(Color.white.opacity(0.1))
                        .padding(.vertical, 2)
                    
                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Monthly Salary")
                                .font(.system(size: 12))
                                .foregroundColor(Color.gray.opacity(0.8))
                            
                            HStack(alignment: .firstTextBaseline, spacing: 2) {
                                Text("$\(jobs["salary"]!)")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(Theme.onPrimaryColor)
                                
                                Text("/month")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color.gray)
                                    .padding(.leading, 2)
                            }
                        }
                        
                        Spacer()
                    }
                    
                    HStack(spacing: 10) {
                        Text("\(jobs["job_trait"]!)")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                            .padding(.vertical, 6)
                            .padding(.horizontal, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(hex: "4A4E69"))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                    )
                            )
                        Text("\(jobs["job_type"]!)")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                            .padding(.vertical, 6)
                            .padding(.horizontal, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(hex: "2C2F3F"))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                    )
                            )
                        
                        Spacer()
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Theme.backgroundColor,
                                    Theme.backgroundColor.opacity(0.95)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(cardHover ? 0.2 : 0.1), lineWidth: 1)
                )
                .shadow(
                    color: Color.black.opacity(cardHover ? 0.3 : 0.2),
                    radius: cardHover ? 15 : 10,
                    x: 0,
                    y: cardHover ? 6 : 4
                )
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .scaleEffect(cardHover ? 1.02 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: cardHover)
                .onHover { hovering in
                    self.cardHover = hovering
                }
                
                ZStack {
                    Circle()
                        .fill(Color.red.opacity(0.9))
                        .frame(width: 32, height: 32)
                        .shadow(color: Color.black.opacity(0.3), radius: 3)
                    
                    Image(systemName: "lock.fill")
                        .resizable()
                        .frame(width: 14, height: 14)
                        .foregroundColor(Theme.onPrimaryColor)
                }
                .offset(x: 0, y: -20)
                .zIndex(1)
            }
            .onAppear {
                if base64Image == nil && !isLoadingImage {
                    isLoadingImage = true
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
        .alert("Login Required", isPresented: $showLoginAlert) {
            Button("Register Now", role: .none) {
                navigateToRegister = true
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Please register or login to access all features")
        }
        
        NavigationLink(destination: RegisterView(), isActive: $navigateToRegister) {
            EmptyView()
        }
    }
}