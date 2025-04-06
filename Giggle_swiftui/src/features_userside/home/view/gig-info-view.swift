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
    var base64Image: String?
    @State var isApplied: Bool = false
    @StateObject var checkApplied = SaveUserInfo(appService: AppService())
    
    var body: some View {
        NavigationView { // Use NavigationView for older SwiftUI versions
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 0) {
                        // Header with Logo and Job Title
                        VStack {
                            if let base64 = base64Image,
                               let data = Data(base64Encoded: base64),
                               let uiImage = UIImage(data: data)
                            {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .frame(width: 84, height: 84)
                                    .clipShape(Circle())
                                    .foregroundColor(.black)
                            } else {
                                Image(systemName: "person.crop.circle")  // Fallback image
                                    .resizable()
                                    .frame(width: 84, height: 84)
                                    .foregroundColor(.black)
                            }
                            Text("\(jobs["job_title"]!)")
                                .font(.system(size: 16))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            HStack {
                                Text("\(jobs["companyName"]!)")
                                    .foregroundColor(.gray)
                                Text("•")
                                    .foregroundColor(.gray)
                                Text("\(jobs["location"]!)")
                                    .foregroundColor(.gray)
                                Text("•")
                                    .foregroundColor(.gray)
                                Text("2 days ago")
                                    .foregroundColor(.gray)
                            }
                            .font(.caption)
                        }
                        .padding()
                        
                        // Job Description Section
                        VStack(alignment: .leading, spacing: 10) {
                            HStack{
                                Text("Job Description")
                                    .font(.system(size: 16, weight: .bold, design: .default))
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            Text("\(jobs["jobDescription"]!)")
                                .foregroundColor(.white)
                                .font(.system(size: 12, weight: .regular, design: .default))
                                .multilineTextAlignment(.leading)
                                .padding(.leading, 4)
                                .padding(.trailing)
                        }
                        .padding()
                        
                        // Requirements Section
                        VStack(alignment: .leading, spacing: 10) {
                            HStack{
                                Text("Requirements")
                                    .font(.system(size: 16, weight: .bold, design: .default))
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            
                            VStack(alignment: .leading, spacing: 10) {
                                ForEach(getRequirements(), id: \.self) { requirement in
                                    Text("• \(requirement)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 12, weight: .regular, design: .default))
                                        .multilineTextAlignment(.leading)
                                }
                            }
                            .padding(.leading, 4)
                            .padding(.trailing)
                        }
                        .foregroundColor(.white)
                        .padding()
                        
                        // Location Section with MapKit
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Location")
                                .font(.system(size: 16, weight: .bold, design: .default))
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
                            Text("Information")
                                .font(.system(size: 16, weight: .bold, design: .default))
                                .foregroundColor(.white)
                            HStack {
                                Text("Position")
                                    .foregroundColor(.gray)
                                    .font(Font.system(size: 12, weight: .bold, design: .default))
                                Spacer()
                                Text("\(jobs["position"]!)")
                                    .foregroundColor(.white)
                                    .font(Font.system(size: 12, weight: .regular, design: .default))
                            }
                            HStack {
                                Text("Qualification")
                                    .foregroundColor(.gray)
                                    .font(Font.system(size: 12, weight: .bold, design: .default))
                                Spacer()
                                Text("\(jobs["qualification"]!)")
                                    .foregroundColor(.white)
                                    .font(Font.system(size: 12, weight: .regular, design: .default))
                            }
                            HStack {
                                Text("Experience")
                                    .foregroundColor(.gray)
                                    .font(Font.system(size: 12, weight: .bold, design: .default))
                                Spacer()
                                Text("\(jobs["experience"]!)")
                                    .foregroundColor(.white)
                                    .font(Font.system(size: 12, weight: .regular, design: .default))
                            }
                            HStack {
                                Text("Job Type")
                                    .foregroundColor(.gray)
                                    .font(Font.system(size: 12, weight: .bold, design: .default))
                                Spacer()
                                Text("\(jobs["job_type"]!)")
                                    .foregroundColor(.white)
                                    .font(Font.system(size: 12, weight: .regular, design: .default))
                            }
                        }
                        .padding()
                        
                        // Facilities and Others Section
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Facilities and Others")
                                .font(.system(size: 16, weight: .bold, design: .default))
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
                        
                        Spacer()
                    }
                }
                VStack {
                    Divider()
                        .background(Color.white.opacity(0.3))

                    HStack {
                        CustomButton(
                            title: isApplied ? "APPLIED" : "APPLY NOW",
                            backgroundColor: isApplied ? Color.gray : Theme.primaryColor,
                            action: {
                                Task {
                                    try await JobPost(appService: AppService()).applyJob(jobId)
                                }
                                isApplied = true
                                showAppliedAlert = true
                            },
                            width: 283,
                            height: 50,
                            cornerRadius: 6
                        )
                        .disabled(isApplied)
                    }
                    .padding()
                }
                .background(Theme.backgroundColor)
            }
            .background(Theme.backgroundColor.ignoresSafeArea()) // Extend background to safe areas
            .navigationBarTitleDisplayMode(.inline)
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
            .onAppear {
                Task {
                    do {
                        let applied = try await checkApplied.jobAppliedCheck(jobId)
                        isApplied = applied
                    } catch {
                        print("Error checking application status: \(error)")
                        isApplied = false
                    }
                }
            }
        }
    }
    private func getRequirements() -> [String] {
            guard let requirementsData = jobs["requirements"] else {
                return ["No requirements available"]
            }
            
            // Try direct string array first
            if let requirements = requirementsData as? [String] {
                let cleaned = requirements.map { $0.replacingOccurrences(of: "\\n", with: "").replacingOccurrences(of: "\n", with: "") }
                print("Cleaned direct array: \(cleaned)")
                return cleaned
            }
            
            // Handle the AnyCodable-like wrapper case
            if let wrappedValue = String(describing: requirementsData)
                .replacingOccurrences(of: "Optional(AnyCodable(", with: "")
                .replacingOccurrences(of: "))", with: "")
                .trimmingCharacters(in: CharacterSet(charactersIn: "[]")) as? String {
                
                // Split the string into array, handling newlines and quotes
                let items = wrappedValue
                    .split(separator: ",")
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                    .map { $0.replacingOccurrences(of: "\"", with: "") }
                    .map { $0.replacingOccurrences(of: "\\n", with: "").replacingOccurrences(of: "\n", with: "") }
                
                print("Cleaned parsed items: \(items)")
                return items.isEmpty ? ["No requirements available"] : items
            }
            
            // Fallback to string conversion of entire object
            let fallback = String(describing: requirementsData).replacingOccurrences(of: "\\n", with: "").replacingOccurrences(of: "\n", with: "")
            print("Cleaned fallback: \(fallback)")
            return [fallback]
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

