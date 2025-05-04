import SwiftUI
import WebKit
import Popovers

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
    @State private var isPopoverPresented = false
    @State private var showDeleteConfirmation: Bool = false // Add this state variable
    @State private var isDeleting: Bool = false // Add this to track deletion process
    
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
            
            VStack {
                Button(action: {
                    isPopoverPresented.toggle()
                }) {
                    Image(systemName: "ellipsis")
                        .resizable()
                        .foregroundStyle(Theme.onPrimaryColor)
                        .scaledToFit()
                        .frame(width: 25, height: 19)
                        .padding(8)
                }
                Templates.Menu(present: $isPopoverPresented) {
                    Templates.MenuButton(title: "Logout") {
                        Task {
                            logout()
                        }
                    }
                    .foregroundStyle(.red)
                    Templates.MenuButton(title: "Delete Account") {
                        showDeleteConfirmation = true
                    }
                    .foregroundStyle(.red)
                } label: { _ in
                    Color.clear
                        .frame(width: 0, height: 0)
                }
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
        .alert(isPresented: $showDeleteConfirmation) {
            Alert(
                title: Text("Delete Account"),
                message: Text("Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently lost."),
                primaryButton: .destructive(Text("Delete")) {
                    isDeleting = true
                    Task {
                        do {
                            try await appService.deleteUserAccount()
                            // After successful deletion, navigate to login screen
                            DispatchQueue.main.async {
                                viewModel.isLoggedIn = false
                                UserDefaults.standard.removeObject(forKey: "status")
                                isDeleting = false
                                navigateToLogin = true
                            }
                        } catch {
                            // Handle error
                            DispatchQueue.main.async {
                                isDeleting = false
                                // You could add another alert here to show the error
                            }
                            print("Error deleting account: \(error.localizedDescription)")
                        }
                    }
                },
                secondaryButton: .cancel()
            )
        }
        // Add a loading overlay when deletion is in progress
        .overlay(
            Group {
                if isDeleting {
                    ZStack {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                        
                        VStack(spacing: 16) {
                            ProgressView()
                                .scaleEffect(1.5)
                                .tint(Theme.primaryColor)
                            
                            Text("Deleting account...")
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                        .padding(24)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(hex: "343434"))
                        )
                        .shadow(radius: 10)
                    }
                }
            }
        )

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
