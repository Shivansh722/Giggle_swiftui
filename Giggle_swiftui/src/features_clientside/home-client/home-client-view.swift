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
   /* @ObservedObject var formManager = FormManager()*/ // Assuming FormManager handles user data
    
    let jobs: [Job] = [
        Job(id: "1", title: "Software Engineer", location: "New York", salary: "$5000", jobTrait: "Remote", jobType: "Full-Time"),
        Job(id: "2", title: "Product Manager", location: "San Francisco", salary: "$6000", jobTrait: "Leadership", jobType: "Contract"),
        Job(id: "3", title: "Data Scientist", location: "Austin", salary: "$7000", jobTrait: "AI", jobType: "Part-Time")
    ]
    
    var body: some View {
        ZStack {
            Theme.backgroundColor
                .edgesIgnoringSafeArea(.all)
            
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
                        ForEach(jobs) { job in
                            JobCardView(jobs: [
                                "$id": job.id,
                                "job_title": job.title,
                                "location": job.location,
                                "salary": job.salary,
                                "job_trait": job.jobTrait,
                                "job_type": job.jobType
                            ], flnID: "asdf")
                        }
                    }
                    .padding(.bottom, 80)
                }
            }
            
            // Floating Action Button
            VStack {
                Spacer()
                Button(action: {
                    print("Add Job Button Pressed")
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
