import SwiftUI

import SwiftUI

// Define a Job struct
struct Job: Identifiable {
    let id: String
    let title: String
    let location: String
    let salary: String
    let jobTrait: String
    let jobType: String
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
                    
                    NavigationLink(destination: ProfileScreen()) {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color.gray)
                            .padding()
                    }
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
                        .background(Color.red)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
                .padding(.bottom, 20)
            }
        }
        .sheet(isPresented: $showGigLister) {
            GigDetailsScreen(gigManager: gigManager)
        }
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
