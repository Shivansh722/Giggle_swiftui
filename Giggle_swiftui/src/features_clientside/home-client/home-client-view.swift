import SwiftUI

// Gig model
struct Gig: Identifiable {
    let id = UUID()
    var companyName: String
    var category: String
    var hoursPerWeek: String
    var location: String
    var isRemote: Bool
    var postedDate: Date

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}

// Gig Manager to handle gig data
class GigManager: ObservableObject {
    @Published var gigs: [Gig] = []
    @Published var userName: String = "User"
}

// Main Home Screen
struct HomeClientView: View {
    @StateObject private var gigManager = GigManager()

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = UIColor(Theme.primaryContrastColor)

        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(
            Theme.onPrimaryColor)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(Theme.onPrimaryColor)
        ]

        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(
            Theme.primaryColor)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(Theme.primaryColor)
        ]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Hi")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.primaryColor)
                    Text(gigManager.userName)
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

            NavigationLink(
                destination: ListYourGigsScreen(gigManager: gigManager)
            ) {
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

            if gigManager.gigs.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("You haven't created any gigs yet!")
                        .font(.subheadline)
                        .foregroundColor(Theme.onPrimaryColor)
                    Text(
                        "Tap the '+' icon above to create your first gig and start earning."
                    )
                    .font(.caption)
                    .foregroundColor(Theme.onPrimaryColor.opacity(0.7))
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Theme.primaryContrastColor)
                .cornerRadius(10)
                .padding(.horizontal)
            } else {
                ScrollView {
                    ForEach(gigManager.gigs) { gig in
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "building.2.crop.circle")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(Theme.primaryColor)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(gig.companyName)
                                        .font(.headline)
                                        .foregroundColor(Theme.onPrimaryColor)
                                    Text(gig.category)
                                        .font(.subheadline)
                                        .foregroundColor(
                                            Theme.onPrimaryColor.opacity(0.7))
                                }

                                Spacer()

                                VStack(alignment: .trailing) {
                                    Text("\(gig.hoursPerWeek) hrs/week")
                                        .font(.subheadline)
                                        .foregroundColor(Theme.onPrimaryColor)
                                    Text(gig.isRemote ? "Remote" : "On-site")
                                        .font(.caption)
                                        .foregroundColor(
                                            Theme.onPrimaryColor.opacity(0.7))
                                }
                            }

                            Divider()
                                .background(Theme.onPrimaryColor.opacity(0.2))

                            HStack {
                                Image(systemName: "mappin.circle")
                                    .foregroundColor(Theme.primaryColor)
                                Text(gig.location)
                                    .font(.subheadline)
                                    .foregroundColor(Theme.onPrimaryColor)

                                Spacer()

                                Image(systemName: "calendar")
                                    .foregroundColor(Theme.primaryColor)
                                Text(
                                    "Posted: \(gig.postedDate, formatter: Gig.dateFormatter)"
                                )
                                .font(.subheadline)
                                .foregroundColor(Theme.onPrimaryColor)
                            }
                        }
                        .padding()
                        .background(Theme.primaryContrastColor)
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                }
            }

            Spacer()
        }
        .background(Theme.backgroundColor.edgesIgnoringSafeArea(.all))
        .navigationBarBackButtonHidden(true)
    }
}

// Gig Listing Screen
struct ListYourGigsScreen: View {
    @ObservedObject var gigManager: GigManager
    @State private var companyName = ""
    @State private var category = ""
    @State private var hoursPerWeek = ""
    @State private var location = ""
    @State private var isRemote = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Theme.backgroundColor.edgesIgnoringSafeArea(.all)
            VStack(spacing: 20) {
                // Title text above the form
                Text("List Your Gig")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                Form {
                    Section(header: Text("Gig Details")) {
                        TextField("Company Name", text: $companyName)
                        TextField("Category", text: $category)
                        TextField("Hours per Week", text: $hoursPerWeek)
                            .keyboardType(.numberPad)
                        TextField("Location", text: $location)
                        Toggle("Remote Work", isOn: $isRemote)
                    }
                    
                    Button("Save Gig") {
                        let newGig = Gig(
                            companyName: companyName,
                            category: category,
                            hoursPerWeek: hoursPerWeek,
                            location: location,
                            isRemote: isRemote,
                            postedDate: Date()
                        )
                        gigManager.gigs.append(newGig)
                        dismiss()
                    }
                    .disabled(companyName.isEmpty || category.isEmpty || hoursPerWeek.isEmpty || location.isEmpty)
                }
                .scrollContentBackground(.hidden)
                .background(Theme.backgroundColor)
                
                // Cancel button below the form
                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(.red)
                .padding(.bottom, 20)
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    HomeClientView()
}
