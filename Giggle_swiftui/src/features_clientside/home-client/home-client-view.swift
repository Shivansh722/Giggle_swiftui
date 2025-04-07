import SwiftUI
import WebKit

// Define a Job struct (unchanged)
struct Job: Identifiable {
    let id: String
    let title: String
    let location: String
    let salary: String
    let companyName: String
    let jobTrait: String
    let jobType: String
}

struct WebClientHomeView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.isOpaque = false // Make webview transparent
        webView.backgroundColor = .clear // Set clear background
        webView.scrollView.backgroundColor = .clear
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: url))
    }
}

// HomeClientView
struct HomeClientView: View {
    @ObservedObject var gigManager = GigManager.shared // Shared Gig Manager
    @StateObject private var appService = AppService() // Instantiate AppService
    @State private var showGigLister = false
    @State private var navigateToLogin = false // State for navigation after logout
    
    var body: some View {
        ZStack {
            Theme.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack {
                // Custom Header with Logout Button
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Hey")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Theme.primaryColor)
//                        Text("Shivansh")
//                            .font(.title)
//                            .fontWeight(.bold)
//                            .foregroundColor(Theme.onPrimaryColor)
                    }
                    .padding()
                    
                    Spacer()
                    
                    Button(action: {
                        Task {
                            let userDefault = UserDefaults.standard
                            userDefault.set("", forKey: "status")
                            let status = UserDefaults.standard.string(forKey: "status")
                            print(status!)
                            RegisterViewModel(service: AppService()).isLoading = false
                            navigateToLogin = true
                        }
                    }) {
                        Text("Logout")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(Theme.primaryColor)
                            .cornerRadius(8)
                    }
                    .padding(.trailing)
                }
                
                ScrollView {
                    VStack(spacing: 10) {
                        // Display newly added gigs
                        ForEach(gigManager.gigs) { gig in
                            JobCardView2(jobs: [
                                "$id": gig.id.uuidString,
                                "job_title": gig.jobRole,
                                "companyName": gig.companyName,
                                "location": gig.location,
                                "salary": gig.hoursPerWeek,
                                "job_trait": gig.specialization,
                                "job_type": gig.isRemote ? "Remote" : "On-Site"
                            ], flnID: "asdf")
                        }
                    }
                    .padding(.bottom, 80)
                    .opacity(1.0)
                }
            }
            
            // Show empty state if no gigs
            if gigManager.gigs.isEmpty {
                VStack {
                    WebClientHomeView(url: Bundle.main.url(forResource: "empty-jobs", withExtension: "gif") ?? URL.desktopDirectory)
                    .frame(width: 300, height: 300)

                    Text("Post your Gigs here!")
                        .font(.system(size: 23))
                        .fontWeight(.bold)
                        .foregroundColor(Theme.onPrimaryColor)
                }
                .position(
                    x: UIScreen.main.bounds.width / 2,
                    y: UIScreen.main.bounds.height / 2 - 50
                )
                .padding(.bottom, 50)
            }
            
            // Floating Action Button
            VStack {
                Spacer()
                Button(action: {
                    showGigLister = true
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .padding()
                        .background(Theme.primaryColor)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
                .padding(.bottom, 20)
            }
            
            // Navigation to Login Screen after Logout
            NavigationLink(
                destination: RegisterView(), // Replace with your actual login view
                isActive: $navigateToLogin
            ) {
                EmptyView()
            }
        }
        .sheet(isPresented: $showGigLister) {
            GigDetailsScreen(gigManager: gigManager)
        }
        .navigationBarBackButtonHidden(true)
        .onChange(of: gigManager.gigs) { newGigs in
            print("Gigs updated: \(newGigs.count) gigs") // Debug log
        }
    }
}

// Preview
struct HomeClientView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeClientView()
        }
    }
}
