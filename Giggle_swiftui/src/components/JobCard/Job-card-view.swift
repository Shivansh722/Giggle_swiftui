import SwiftUI

struct JobCardView: View {
    let jobs: [String: Any]
    let flnID: String?
    
    var body: some View {
        NavigationLink(destination: JobDetailView(jobId: "\(jobs["$id"]!)")) {
            VStack {
                // Card View
                VStack(spacing: 16) {
                    HStack(alignment: .center) {
                        // Logo and Text
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(Color.purple.opacity(0.2))
                                    .frame(width: 48, height: 48)
                                
                                Image("mcD")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.black)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                let keysString = jobs["job_title"]!
                                Text("\(keysString)")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                let location = jobs["location"]!
                                Text("\(jobs["location"]!)")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color.gray)
                            }
                        }
                        
                        Spacer()
                        
                        // Bookmark Icon
                        Button(action: {}) {
                            Image(systemName: "bookmark")
                                .resizable()
                                .frame(width: 20, height: 30)
                                .foregroundColor(Color.gray)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("\(jobs["salary"]!)")
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
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct JobDetailView: View {
    let jobId: String
    
    var body: some View {
        Text("Job ID: \(jobId)")
            .font(.largeTitle)
            .padding()
    }
}

