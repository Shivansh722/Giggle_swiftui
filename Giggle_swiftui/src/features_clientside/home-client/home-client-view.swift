import SwiftUI

struct HomeClientView: View {
    @ObservedObject var formManager = FormManager.shared
    
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
        NavigationView {
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
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color.gray)
                            .padding()
                    }
                }
                
                // Add the icon and text here
                NavigationLink(destination: ListYourGigsScreen()) {
                    VStack {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(Theme.primaryColor)
                        Text("List your gigs here")
                            .font(.headline)
                            .foregroundColor(Theme.onPrimaryColor)
                    }
                    .padding()
                }
                
                // Sample tile for first-time users
                VStack(alignment: .leading, spacing: 8) {
                    Text("You haven't created any gigs yet!")
                        .font(.subheadline)
                        .foregroundColor(Theme.onPrimaryColor)
                    Text("Tap the '+' icon above to create your first gig and start earning.")
                        .font(.caption)
                        .foregroundColor(Theme.onPrimaryColor.opacity(0.7))
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Theme.primaryContrastColor)
                .cornerRadius(10)
                .padding(.horizontal)
                
                // Sample gig vacancy tile
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        // Logo
                        Image(systemName: "building.2.crop.circle")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Theme.primaryColor)
                        
                        // Company Name
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Tech Innovators Inc.")
                                .font(.headline)
                                .foregroundColor(Theme.onPrimaryColor)
                            Text("Software Development")
                                .font(.subheadline)
                                .foregroundColor(Theme.onPrimaryColor.opacity(0.7))
                        }
                        
                        Spacer()
                        
                        // Hours/Week
                        VStack(alignment: .trailing) {
                            Text("20 hrs/week")
                                .font(.subheadline)
                                .foregroundColor(Theme.onPrimaryColor)
                            Text("Remote")
                                .font(.caption)
                                .foregroundColor(Theme.onPrimaryColor.opacity(0.7))
                        }
                    }
                    
                    Divider()
                        .background(Theme.onPrimaryColor.opacity(0.2))
                    
                    // Location and Date
                    HStack {
                        Image(systemName: "mappin.circle")
                            .foregroundColor(Theme.primaryColor)
                        Text("San Francisco, CA")
                            .font(.subheadline)
                            .foregroundColor(Theme.onPrimaryColor)
                        
                        Spacer()
                        
                        Image(systemName: "calendar")
                            .foregroundColor(Theme.primaryColor)
                        Text("Posted: 10 Feb 2024")
                            .font(.subheadline)
                            .foregroundColor(Theme.onPrimaryColor)
                    }
                }
                .padding()
                .background(Theme.primaryContrastColor)
                .cornerRadius(10)
                .padding(.horizontal)
                
                Spacer()
            }
            .background(Theme.backgroundColor.edgesIgnoringSafeArea(.all))
            .navigationBarBackButtonHidden(true)
        }
    }
}

// Placeholder for the next screen
struct ListYourGigsScreen: View {
    var body: some View {
        Text("This is where you list your gigs!")
            .font(.largeTitle)
            .foregroundColor(Theme.primaryColor)
            .padding()
    }
}

#Preview {
    HomeClientView()
}
