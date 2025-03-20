import SwiftUI
import WebKit

// Define a Job struct
struct Job: Identifiable {
    let id: String
    let title: String
    let location: String
    let salary: String
    let jobTrait: String
    let jobType: String
}

struct WebClientHomeView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.isOpaque = false // Make webview transparent
        webView.backgroundColor = .clear // Set clear background
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

// HomeClientView
struct HomeClientView: View {
    @ObservedObject var gigManager = GigManager() // Shared Gig Manager
    @State private var showGigLister = false
    
    var body: some View {
        ZStack {
            Theme.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack {
                // Custom Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Hi")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Theme.primaryColor)
                        Text("Shivansh")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Theme.onPrimaryColor)
                    }
                    .padding()
                    
                    Spacer()
                    
//                    NavigationLink(destination: ProfileScreen()) {
//                        Image(systemName: "person.crop.circle")
//                            .resizable()
//                            .frame(width: 40, height: 40)
//                            .foregroundColor(Color.gray)
//                            .padding()
//                    }
                }
                
                ScrollView {
                    VStack(spacing: 10) {
                        // Display newly added gigs
                        ForEach(gigManager.gigs) { gig in
                            JobCardView(jobs: [
                                "$id": gig.id.uuidString,
                                "job_title": gig.companyName,
                                "location": gig.location,
                                "salary": "N/A", // Salary not available
                                "job_trait": gig.isRemote ? "Remote" : "On-Site",
                                "job_type": gig.category
                            ], flnID: "asdf")
                        }
                    }
                    .padding(.bottom, 80)
                    .opacity(1.0)
                }
            }
            if gigManager.gigs.isEmpty {
                            VStack {
                                WebClientHomeView(
                                    url: Bundle.main.url(forResource: "empty-screen", withExtension: "gif")
                                    ?? URL(fileURLWithPath: NSTemporaryDirectory())
                                )
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
                    showGigLister = true // Open the gig lister
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
        }
        .sheet(isPresented: $showGigLister) {
            GigDetailsScreen(gigManager: gigManager)
        }
        .navigationBarBackButtonHidden(true)
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
