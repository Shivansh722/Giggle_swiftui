import SwiftUI

struct GuestHomeView: View {
    @State private var showLoginAlert = false
    @State private var navigateToRegister = false
    @State private var contentOpacity: Double = 0
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                // Home Tab
                ZStack {
                    Theme.backgroundColor.edgesIgnoringSafeArea(.all)
                    VStack {
                        // Header with fade-in animation
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Welcome")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Theme.primaryColor)
                                Text("Guest")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Theme.onPrimaryColor)
                            }
                            .padding()
                            .opacity(contentOpacity)
                            .animation(.easeIn(duration: 0.5), value: contentOpacity)
                            
                            Spacer()
                            
                            Button(action: {
                                showLoginAlert = true
                            }) {
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(Color.gray)
                                    .padding()
                                    .opacity(contentOpacity)
                                    .animation(.easeIn(duration: 0.5).delay(0.1), value: contentOpacity)
                            }
                        }
                        
                        ScrollView {
                            Image("desk")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .opacity(contentOpacity)
                                .animation(.easeIn(duration: 0.5).delay(0.2), value: contentOpacity)
                            
                            Text("Recommendations")
                                .font(.system(size: 24))
                                .fontWeight(.bold)
                                .foregroundColor(Theme.onPrimaryColor)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                                .padding(.top, -62)
                                .opacity(contentOpacity)
                                .animation(.easeIn(duration: 0.5).delay(0.3), value: contentOpacity)
                            
                            // Sample job cards for demonstration
                            LazyVStack(spacing: 8) {
                                ForEach(0..<3) { index in
                                    JobCardView(
                                        jobs: [
                                            "$id": "sample\(index)",
                                            "job_title": "Sample Job \(index + 1)",
                                            "companyName": "Demo Company",
                                            "location": "Remote",
                                            "salary": "2000",
                                            "job_trait": "Technical",
                                            "job_type": "Full-time",
                                            "$createdAt": "2024-03-25T12:00:00.000+00:00"
                                        ],
                                        flnID: nil
                                    )
                                    .onTapGesture {
                                        showLoginAlert = true
                                    }
                                }
                            }
                            .padding(.top, -24)
                        }
                    }
                }
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
                .onAppear {
                    selectedTab = 0
                    withAnimation {
                        contentOpacity = 1
                    }
                }
                
                // Search Tab
                ZStack {
                    Theme.backgroundColor.edgesIgnoringSafeArea(.all)
                    Button(action: {
                        showLoginAlert = true
                    }) {
                        Text("Please login to use search features")
                            .foregroundColor(Theme.onPrimaryColor)
                    }
                }
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                .tag(1)
                
                // Notifications Tab
                ZStack {
                    Theme.backgroundColor.edgesIgnoringSafeArea(.all)
                    Button(action: {
                        showLoginAlert = true
                    }) {
                        Text("Please login to view notifications")
                            .foregroundColor(Theme.onPrimaryColor)
                    }
                }
                .tabItem {
                    Image(systemName: "bell.fill")
                    Text("Notifications")
                }
                .tag(2)
            }
            .accentColor(Theme.primaryColor)
            
            NavigationLink(destination: RegisterView(), isActive: $navigateToRegister) {
                EmptyView()
            }
        }
        .alert("Login Required", isPresented: $showLoginAlert) {
            Button("Register Now", role: .none) {
                navigateToRegister = true
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Please register or login to access all features")
        }
    }
}