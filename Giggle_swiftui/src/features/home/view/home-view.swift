import SwiftUI

struct HomeView: View {
    @ObservedObject var formManager = FormManager.shared
    init() {
        // Set the tab bar appearance globally when the view is initialized
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()  // Use default background style
        appearance.backgroundColor = UIColor(Theme.primaryContrastColor) // Set background color of the tab bar
        
        // Normal state appearance
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Theme.onPrimaryColor) // Icon color for normal (unselected) state
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(Theme.onPrimaryColor)] // Text color for normal state
        
        // Selected state appearance
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Theme.primaryColor) // Icon color for selected state
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(Theme.primaryColor)] // Text color for selected state
        
        // Apply this appearance globally
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView {
            // Home Tab
            GeometryReader { geometry in
                ZStack {
                    Theme.backgroundColor
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        // Top section with Greeting and Profile icon
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
                            
                            
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color.gray)
                                .padding()
                        }
                        Spacer()
                        
                        ZStack {
                            // Image
                            Image("desk")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width * 1.0, height: geometry.size.height / 2)
                                .position(x: geometry.size.width / 2, y: geometry.size.height / 8)
                            
                            // Overlapping Custom Button
                            VStack {
                                Spacer()
                                Text("Take FLN")
                                    .font(.headline)
                                    .foregroundColor(Theme.secondaryColor)
                                    .padding(.leading, geometry.size.width * 0.02)
                                    .padding(.bottom, geometry.size.height * -0.08)
                                Text("To start applying for gigs you need to take the FLN test first.")
                                    .font(.system(size: 16))
                                    .foregroundColor(Theme.tertiaryColor)
                                    .padding(.top, geometry.size.height * 0.02)
                                    .padding(.bottom, geometry.size.height * -0.06)
                                    .multilineTextAlignment(.center)
                                
                                CustomButton(
                                    title: "NEXT",
                                    backgroundColor: Theme.primaryColor,
                                    action: {
                                        // Add Button Action Here
                                    },
                                    width: geometry.size.width * 0.5,
                                    height: 50
                                )
                                .padding(.top, geometry.size.height * 0.08)
                                .padding(.horizontal, geometry.size.width * 0.18)
                            }
                        }
                        
                        VStack {
                            Text("Recommendations")
                                .font(.system(size: 24))
                                .fontWeight(.bold)
                                .foregroundColor(Theme.onPrimaryColor)
                                .padding(.horizontal, geometry.size.width * -0.45)
                            
                            JobCardView()
                                .padding(.bottom, geometry.size.height * 0.02)
                            JobCardView()
                        }
                        .padding(.top, geometry.size.height * -0.6)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            
            // Search Tab
            GeometryReader { geometry in
                ZStack {
                    Theme.backgroundColor
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Text("Search View")
                            .font(.largeTitle)
                            .foregroundColor(Theme.onPrimaryColor) // Text color for Search tab
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Search")
            }
            
            // Notifications Tab
            GeometryReader { geometry in
                ZStack {
                    Theme.backgroundColor
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Text("Notifications View")
                            .font(.largeTitle)
                            .foregroundColor(Theme.onPrimaryColor) // Text color for Notifications tab
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
            .tabItem {
                Image(systemName: "bell.fill")
                Text("Notifications")
            }
        }.navigationBarBackButtonHidden(true)
            .accentColor(Theme.primaryColor) // Custom accent color for selected tab items
    }
}

#Preview {
    HomeView()
}
