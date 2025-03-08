import SwiftUI

struct HomeView: View {
    @ObservedObject var formManager = FormManager.shared
    @StateObject var saveUserInfo = SaveUserInfo(appService: AppService())
    @StateObject var flnInfo = FLNInfo(appService: AppService())
    @StateObject var jobs = JobPost(appService:AppService())

    @State private var flnID: String? = nil
    @State private var isLoading = true
    @State private var navigateToLiteracy = false
    @State private var jobresult:[[String:Any]] = []

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = UIColor(Theme.primaryContrastColor)
        
        // Normal state
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Theme.onPrimaryColor)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(Theme.onPrimaryColor)]
        
        // Selected state
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
                        // Header with Greeting & Profile
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
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(Color.gray)
                                    .padding()
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
                                        
                                        NavigationLink(destination: LiteracyView(), isActive: $navigateToLiteracy) {
                                            EmptyView()
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.top, 40)
                                } else {
                                    FLNGradeCardView(grade: "G+", lastUpdate: "Saturday, 26 Oct")
                                            .padding(.bottom, 250)

                                }
                            }
                        }
                        Spacer()

                        VStack {
                            Text("Recommendations")
                                .font(.system(size: 24))
                                .fontWeight(.bold)
                                .foregroundColor(Theme.onPrimaryColor)
                                .padding(.horizontal, geometry.size.width * -0.45)
                            
//                            JobCardView(jobs: job)
//                                .padding(.bottom, geometry.size.height * 0.02)
//                            JobCardView(jobs: job)
                            ScrollView{
                                ForEach(jobresult.indices, id: \.self) { index in
                                    JobCardView(jobs: jobresult[index])
                                }
                            }
                        }
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
                    let result = try await jobs.get_job_post()
                    jobresult = result
                    for job in jobresult{
//                        JobCardView(jobs: job)
                    }
                    
                }
            }
            
            GeometryReader { geometry in
                ZStack {
                    Theme.backgroundColor.edgesIgnoringSafeArea(.all)
                    VStack {
                        Text("Search View")
                            .font(.largeTitle)
                            .foregroundColor(Theme.onPrimaryColor)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Search")
            }
            
            GeometryReader { geometry in
                ZStack {
                    Theme.backgroundColor.edgesIgnoringSafeArea(.all)
                    VStack {
                        Text("Notifications View")
                            .font(.largeTitle)
                            .foregroundColor(Theme.onPrimaryColor)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
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
        isLoading = false
    }
}

struct FLNGradeCardView: View {
    let grade: String
    let lastUpdate: String
    @State private var navigate:Bool = false
    
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
                    .foregroundColor(Color.yellow) // Adjust based on design
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
                    
                    NavigationLink(destination: FLNScoreView(), isActive: $navigate){
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

#Preview {
    HomeView()
}
