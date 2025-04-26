// HomeView.swift (updated)
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
    @State private var GiggleGrade: String? = ""
    @State private var jobresult: [[String: Any]] = []
    @State private var contentOpacity: Double = 0  // For fade-in animation

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
            // Home Tab
            ZStack {
                Theme.backgroundColor.edgesIgnoringSafeArea(.all)
                VStack {
                    // Header with fade-in animation
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
                        .opacity(contentOpacity)
                        .animation(.easeIn(duration: 0.5), value: contentOpacity)
                        
                        Spacer()
                        
                        NavigationLink(destination: ProfileScreen()) {
                            if let profileImage = GlobalData.shared.profileImage {
                                Image(uiImage: profileImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                    .padding()
                                    .opacity(contentOpacity)
                                    .animation(.easeIn(duration: 0.5).delay(0.1), value: contentOpacity)
                            } else {
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(Color.gray)
                                    .padding()
                                    .opacity(contentOpacity)
                                    .animation(.easeIn(duration: 0.5).delay(0.1), value: contentOpacity)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    ScrollView {
                        ZStack {
                            if isLoading || flnID == nil {
                                Image("desk")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: .infinity, maxHeight: 300)
                                    .opacity(contentOpacity)
                                    .animation(.easeIn(duration: 0.5).delay(0.2), value: contentOpacity)
                            }
                            
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
                                            width: 200,
                                            height: 50,
                                            cornerRadius: 6
                                        )
                                        NavigationLink(destination: FluencyIntroView(), isActive: $navigateToLiteracy) {
                                            EmptyView()
                                        }
                                        Spacer()
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.top, 5)
                                } else {
                                    FLNGradeCardView(grade: GiggleGrade, lastUpdate: updatedAt!)
                                }
                            }
                        }
                        
                        Text("Recommendations")
                            .font(.system(size: 24))
                            .fontWeight(.bold)
                            .foregroundColor(Theme.onPrimaryColor)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .padding(.top, 8)
                            .opacity(contentOpacity)
                            .animation(.easeIn(duration: 0.5).delay(0.3), value: contentOpacity)
                        
                        // Job cards with gentle transitions
                        ForEach(jobresult.indices, id: \.self) { index in
                            JobCardView(jobs: jobresult[index], flnID: flnID)
                                .transition(.asymmetric(
                                    insertion: .move(edge: .leading).combined(with: .opacity),
                                    removal: .move(edge: .trailing).combined(with: .opacity)
                                ))
                                .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(Double(index) * 0.05))
                        }
                    }
                }
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            .onAppear {
                withAnimation {
                    contentOpacity = 1
                }
                Task {
                    await fetchUser()
                    do {
                        let result = try await jobs.get_job_post()
                        withAnimation(.easeInOut) {
                            jobresult = result
                        }
                    } catch {
                        print("Failed to fetch job posts: \(error.localizedDescription)")
                    }
                }
            }
            
            // Search Tab
            SearchScreen(jobresult: jobresult, flnID: flnID)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            
            // Notifications Tab
            NotificationScreen(jobs: jobresult)
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
        (updatedAt, GiggleGrade) = await flnInfo.getUserFlnUpdatedAt()
        isLoading = false
    }
}
struct FLNGradeCardView: View {
    let grade: String?
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
                Text(grade ?? "")
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
        .frame(maxWidth: .infinity, maxHeight: 160)
        .padding(.horizontal)
    }
}
