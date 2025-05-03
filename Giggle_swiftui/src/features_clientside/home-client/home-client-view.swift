import SwiftUI
import WebKit
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

struct HomeClientView: View {
    @EnvironmentObject var viewModel: RegisterViewModel
    @ObservedObject var gigManager = GigManager.shared
    @StateObject private var appService = AppService()
    @State private var showGigLister = false
    @State private var navigateToLogin = false
    @StateObject var getClientJob = ClientHandlerUserInfo(appService: AppService())
    @State private var jobresult: [[String: Any]] = []
    @State private var flnID: String? = nil
    @State private var showDisabledAlert = false
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Hey")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.primaryColor)
            }
            .padding()
            
            Spacer()
            
            Button(action: logout) {
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
    }
    
    private var emptyStateView: some View {
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
    
    private var floatingActionButton: some View {
        VStack {
            Spacer()
            Image(systemName: "plus")
                .font(.system(size: 30))
                .foregroundColor(.white)
                .padding()
                .background(Theme.primaryColor)
                .clipShape(Circle())
                .shadow(radius: 5)
                .padding(.bottom, 20)
                .onTapGesture {
                    if jobresult.isEmpty {
                        showGigLister = true
                    } else {
                        showDisabledAlert = true
                    }
                }
                .alert("You already have a job posted.", isPresented: $showDisabledAlert) {
                    Button("OK", role: .cancel) { }
                }
        }
    }
    
    private var jobCardsView: some View {
        ForEach(jobresult.indices, id: \.self) { index in
            JobCardView2(
                jobs: jobresult[index],
                flnID: flnID,
                onDelete: { jobresult.remove(at: index) }
            )
            .transition(.asymmetric(
                insertion: .move(edge: .leading).combined(with: .opacity),
                removal: .move(edge: .trailing).combined(with: .opacity)
            )
            .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(Double(index) * 0.05)))
        }
    }
    
    private var gigCardsView: some View {
        ForEach(gigManager.gigs) { gig in
            JobCardView2(
                jobs: [
                    "$id": gig.id.uuidString,
                    "job_title": gig.jobRole,
                    "companyName": gig.companyName,
                    "location": gig.location,
                    "salary": gig.hoursPerWeek,
                    "job_trait": gig.specialization,
                    "job_type": gig.isRemote ? "Remote" : "On-Site"
                ],
                flnID: "asdf",
                onDelete: {}
            )
        }
    }

    var body: some View {
        ZStack {
            Theme.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack {
                headerView
                
                ScrollView {
                    VStack {
                        if jobresult.isEmpty {
                            EmptyView()
                        } else {
                            jobCardsView
                        }
                        
                        gigCardsView
                            .padding(.bottom, 80)
                            .opacity(1.0)
                    }
                }
            }
            
            if gigManager.gigs.isEmpty && jobresult.isEmpty {
                emptyStateView
            }
            
            floatingActionButton
            
            NavigationLink(
                destination: RegisterView(),
                isActive: $navigateToLogin
            ) { EmptyView() }
        }
        .onAppear(perform: loadJobs)
        .sheet(isPresented: $showGigLister) {
            GigDetailsScreen(gigManager: gigManager)
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func loadJobs() {
        Task {
            do {
                let result = try await getClientJob.fetchClientJob()
                jobresult = result
            } catch {
                print(error)
            }
        }
    }
    
    private func logout() {
        Task {
            viewModel.isLoggedIn = false
            UserDefaults.standard.removeObject(forKey: "status")
            navigateToLogin = true
        }
    }
}
