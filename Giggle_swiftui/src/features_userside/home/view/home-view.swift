import SwiftUI

struct HomeView: View {
    @ObservedObject var formManager = FormManager.shared
    @ObservedObject var jobTitleManager = JobTitleManager.shared
    @StateObject var saveUserInfo = SaveUserInfo(appService: AppService())
    @StateObject var flnInfo = FLNInfo(appService: AppService())
    @StateObject var jobs = JobPost(appService: AppService())

    @State private var flnID: String? = nil
    @State private var updatedAt: String? = nil
    @State private var isLoading = true
    @State private var navigateToLiteracy = false
    @State private var jobresult: [[String: Any]] = []
    @State private var searchText: String = ""
    @State private var filteredJobs: [[String: Any]] = []

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = UIColor(Theme.primaryContrastColor)
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Theme.onPrimaryColor)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(Theme.onPrimaryColor)]
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Theme.primaryColor)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(Theme.primaryColor)]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView {
            GeometryReader { geometry in
                ZStack {
                    Theme.backgroundColor.edgesIgnoringSafeArea(.all)
                    VStack {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Hi")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Theme.primaryColor)
                                Text(formManager.formData.name)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Theme.onPrimaryColor)
                            }
                            .padding()
                            Spacer()
                            NavigationLink(destination: ProfileScreen()) {
                                if let profileImage = GlobalData.shared.profileImage {
                                    Image(uiImage: profileImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                        .padding()
                                } else {
                                    Image(systemName: "person.crop.circle")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(Color.gray)
                                        .padding()
                                }
                            }
                        }
                        Spacer()

                        ZStack {
                            Image("desk")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width, height: geometry.size.height / 2)
                                .position(x: geometry.size.width / 2, y: geometry.size.height / 8)
                            
                            VStack {
                                if isLoading {
                                    ProgressView()
                                        .onAppear {
                                            Task {
                                                await fetchFlnID()
                                            }
                                        }
                                } else if flnID == nil {
                                    VStack(spacing: 16) {
                                        Text("Take FLN")
                                            .font(.headline)
                                            .foregroundColor(Theme.secondaryColor)
                                        Text("To start applying for gigs you need to take the FLN test first.")
                                            .font(.system(size: 16))
                                            .foregroundColor(Theme.tertiaryColor)
                                            .multilineTextAlignment(.center)
                                            .padding(.horizontal, 24)
                                        CustomButton(
                                            title: "NEXT",
                                            backgroundColor: Theme.primaryColor,
                                            action: { navigateToLiteracy = true },
                                            width: geometry.size.width * 0.5,
                                            height: 50
                                        )
                                        .padding(.leading, 65)
                                        NavigationLink(destination: FlnIntroView(), isActive: $navigateToLiteracy) {
                                            EmptyView()
                                        }
                                        Spacer()
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.top, 5)
                                } else {
                                    FLNGradeCardView(grade: "G+", lastUpdate: updatedAt!)
                                        .padding(.bottom, 170)
                                }
                            }
                        }

                        VStack {
                            Text("Recommendations")
                                .font(.system(size: 24))
                                .fontWeight(.bold)
                                .foregroundColor(Theme.onPrimaryColor)
                                .padding(.horizontal, geometry.size.width * -0.45)
                                .padding(.top, 40)
                            ScrollView {
                                ForEach(jobresult.indices, id: \.self) { index in
                                    JobCardView(jobs: jobresult[index], flnID: flnID)
                                }
                            }.padding(.top, 20)
                        }
                        .padding(.top, flnID != nil ? 20 : 40)
                        .padding(.top, geometry.size.height * -0.3)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            .onAppear {
                Task {
                    await fetchUser()
                    do {
                        let result = try await jobs.get_job_post()
                        jobresult = result
                        filteredJobs = result
                        // Verify sync
                        let singletonTitles = Set(jobTitleManager.jobPosts.map { $0.jobTitle })
                        let jobresultTitles = Set(jobresult.compactMap { $0["job_title"] as? String })
                    } catch {
                        print("Failed to fetch job posts: \(error.localizedDescription)")
                    }
                }
            }
            
            GeometryReader { geometry in
                ZStack {
                    Theme.backgroundColor.edgesIgnoringSafeArea(.all)
                    VStack(spacing: 20) {
                        ZStack(alignment: .leading) {
                            Text("Search Gigs")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.onPrimaryColor)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.leading, 16)
                        
                        CustomTextField(placeholder: "Search by job title...", isSecure: false, text: $searchText, icon: "magnifyingglass")
                        
                        ScrollView {
                            if filteredJobs.isEmpty && !searchText.isEmpty {
                                Text("No jobs found matching '\(searchText)'")
                                    .foregroundColor(Theme.onPrimaryColor)
                                    .padding()
                            } else {
                                ForEach(filteredJobs.indices, id: \.self) { index in
                                    JobCardView(jobs: filteredJobs[index], flnID: flnID)
                                        .padding(.horizontal)
                                        .padding(.bottom, 10)
                                        .onAppear {
                                            print("Rendering job: \(filteredJobs[index]["job_title"] ?? "unknown")")
                                        }
                                }
                            }
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Search")
            }
            .onAppear {
                filteredJobs = jobresult // Initialize with all jobs
                print("Search tab appeared - jobs: \(filteredJobs.count)")
            }
            
            GeometryReader { geometry in
                ZStack {
                    NotificationScreen(jobs:jobresult)
                }
            }
            .tabItem {
                Image(systemName: "bell.fill")
                Text("Notifications")
            }
        }
        .navigationBarBackButtonHidden(true)
        .accentColor(Theme.primaryColor)
    }

    func fetchUser() async {
        await saveUserInfo.fetchUser(userId: formManager.formData.userId)
    }

    func fetchFlnID() async {
        flnID = await flnInfo.getFlnInfo()
        updatedAt = await flnInfo.getUserFlnUpdatedAt()
        isLoading = false
    }
    
    func filterJobs(searchText: String) {
        Task { @MainActor in
            if searchText.isEmpty {
                filteredJobs = jobresult
            } else {
                // Filter titles from singleton
                let filteredTitles = jobTitleManager.jobPosts.filter { job in
                    job.jobTitle.lowercased().contains(searchText.lowercased())
                }
                
                // Ensure jobresult has the full data
                if jobresult.isEmpty {
                    do {
                        jobresult = try await jobs.get_job_post()
                    } catch {
                        print("Error refetching jobs: \(error)")
                        return
                    }
                }
                
                // Match filtered titles with jobresult dictionaries
                filteredJobs = jobresult.filter { jobDict in
                    guard let jobTitle = jobDict["job_title"] as? String else { return false }
                    return filteredTitles.contains { $0.jobTitle == jobTitle }
                }
                
            }
        }
    }
}

struct FLNGradeCardView: View {
    let grade: String
    let lastUpdate: String
    @State private var navigate: Bool = false
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color.white, lineWidth: 1)
                .cornerRadius(20)
            VStack(alignment: .leading, spacing: 10) {
                Text("Your FLN Grade:")
                    .font(.headline)
                    .foregroundColor(.white)
                Text(grade)
                    .font(.title2)
                    .bold()
                    .foregroundColor(Color.yellow)
                HStack(alignment: .center, spacing: 10) {
                    Button(action: {
                        navigate = true
                    }) {
                        Text("SCORE")
                            .font(.headline)
                            .frame(maxWidth: .infinity, maxHeight: 10)
                            .padding()
                            .background(Theme.primaryColor)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("Last Update")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(lastUpdate)
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    NavigationLink(destination: FLNScoreView(), isActive: $navigate) {
                        EmptyView()
                    }
                }
            }
            .padding()
        }
        .frame(width: .infinity, height: 150)
        .padding(.horizontal)
    }
}
