import SwiftUI
import MapKit

/// UIViewRepresentable to integrate MKMapView
struct MapView: UIViewRepresentable {
    let location: String
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { placemarks, error in
            if let placemark = placemarks?.first, let location = placemark.location {
                let coordinate = location.coordinate
                let region = MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
                uiView.setRegion(region, animated: true)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "Location"
                uiView.addAnnotation(annotation)
            }
        }
    }
}

struct GigInfoView: View {
    // State to control the alert
    @State private var showAppliedAlert = false
    let jobId: String
    let jobs:[String: Any]
    
    var body: some View {
        NavigationView { // Use NavigationView for older SwiftUI versions
            ScrollView {
                VStack(spacing: 0) {
                    // Header with Logo and Job Title
                    VStack {
                        Image("mcD") // Replace with actual image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 84, height: 84)
                        Text("\(jobs["job_title"]!)")
                            .font(.title2)
                            .foregroundColor(.white)
                        HStack {
                            Text("Google")
                                .foregroundColor(.gray)
                            Text("•")
                                .foregroundColor(.gray)
                            Text("California")
                                .foregroundColor(.gray)
                            Text("•")
                                .foregroundColor(.gray)
                            Text("1 day ago")
                                .foregroundColor(.gray)
                        }
                        .font(.caption)
                    }
                    .padding()
                    
                    // Job Description Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Job Description")
                            .font(.system(size: 20, weight: .bold, design: .default))
                            .foregroundColor(.white)
                        Text("Sed ut perspiciatis unde omnis iste natus error sit voluptatum rem aperiam, eaque ipsa quae ab illo inventore explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit.")
                            .foregroundColor(.white)
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .multilineTextAlignment(.leading)
                            .padding(.leading)
                            .padding(.trailing)
                    }
                    .padding()
                    
                    // Requirements Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Requirements")
                            .font(.system(size: 20, weight: .bold, design: .default))
                            .foregroundColor(.white)
                        VStack(alignment: .leading, spacing: 10) {
                            Text("• Sed ut perspiciatis unde omnis iste natus error")
                            Text("• Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur adipiscing velit.")
                            Text("• Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit.")
                            Text("• Ut enim ad minim veniam, quis nostrud exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodo consequat.")
                        }
                        .foregroundColor(.white)
                        .font(.system(size: 12, weight: .regular, design: .default))
                        .multilineTextAlignment(.leading)
                        .padding(.leading)
                        .padding(.trailing)
                    }
                    .foregroundColor(.white)
                    .padding()
                    
                    // Location Section with MapKit
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Location")
                            .font(.system(size: 20, weight: .bold, design: .default))
                            .foregroundColor(.white)
                        Text("\(jobs["location"]!)")
                            .foregroundColor(.white)
                            .font(.system(size: 12, weight: .regular, design: .default))
                        MapView(location: "Overlook Avenue, Belleville, NJ, USA")
                            .frame(height: 150)
                            .cornerRadius(10)
                    }
                    .padding()
                    
                    // Informations Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Informations")
                            .font(.system(size: 20, weight: .bold, design: .default))
                            .foregroundColor(.white)
                        HStack {
                            Text("Position")
                                .foregroundColor(.gray)
                            Spacer()
                            Text("Senior Designer")
                                .foregroundColor(.white)
                        }
                        HStack {
                            Text("Qualification")
                                .foregroundColor(.gray)
                            Spacer()
                            Text("Bachelor's Degree")
                                .foregroundColor(.white)
                        }
                        HStack {
                            Text("Experience")
                                .foregroundColor(.gray)
                            Spacer()
                            Text("3 Years")
                                .foregroundColor(.white)
                        }
                        HStack {
                            Text("Job Type")
                                .foregroundColor(.gray)
                            Spacer()
                            Text("Full-Time")
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    
                    // Facilities and Others Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Facilities and Others")
                            .font(.system(size: 20, weight: .bold, design: .default))
                            .foregroundColor(.white)
                        VStack(alignment: .leading, spacing: 4) { // Ensure leading alignment
                            Text("• Medical")
                            Text("• Dental")
                            Text("• Technical Certification")
                            Text("• Meal Allowance")
                            Text("• Transport Allowance")
                            Text("• Regular Hours")
                            Text("• Work on Fridays")
                        }
                        .foregroundColor(.white)
                        .font(.system(size: 12, weight: .regular, design: .default))
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading) // Force leading alignment
                        .padding(.leading, 4)
                        .padding(.trailing, 16)
                    }
                    .padding()
                    
                    // Apply Now Button
                    HStack(alignment: .center) {
                        Spacer()
                        CustomButton(
                            title: "APPLY NOW",
                            backgroundColor: Theme.primaryColor,
                            action: {
                                // Trigger the alert
                                Task{
                                    try await JobPost(appService: AppService()).applyJob(jobId)
                                }
                                showAppliedAlert = true
                                // Later, you can add backend logic here, e.g.:
                                // applyToGig(userId: "user123", gigId: "gig456")
                            },
                            width: 283,
                            height: 50
                        )
                        Spacer()
                    }
                    .padding()
                    .padding(.bottom, 20)
                }
            }
            .background(Theme.backgroundColor.ignoresSafeArea()) // Extend background to safe areas
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // Back action
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.white)
                }
            }
            // Ensure navigation bar matches the theme
            .navigationBarBackground {
                Theme.backgroundColor
            }
            // Alert for successful application
            .alert(isPresented: $showAppliedAlert) {
                Alert(
                    title: Text("Application Submitted"),
                    message: Text("Successfully applied for the job!"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

// Extension to customize the navigation bar background (for older SwiftUI versions)
extension View {
    func navigationBarBackground<Background: View>(@ViewBuilder _ background: () -> Background) -> some View {
        self.background(
            background()
                .frame(height: 0)
                .frame(maxHeight: .infinity, alignment: .top)
                .ignoresSafeArea()
        )
    }
}

