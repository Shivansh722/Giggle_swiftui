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
    @Environment(\.dismiss) var dismiss
    @State private var showAppliedAlert = false
    let fln: String?
    let jobId: String
    let jobs: [String: Any]
    var base64Image: String?
    @State var isApplied: Bool = false
    @State var flnapply: Bool = true
    @StateObject var checkApplied = SaveUserInfo(appService: AppService())
    
    var body: some View {
        ZStack(alignment: .bottom) { // Changed alignment to .bottom
            ScrollView {
                VStack(spacing: 0) {
                    ZStack(alignment: .bottom) {
                        LinearGradient(
                            gradient: Gradient(colors: [Color.red.opacity(0.18), Color.gray.opacity(0.12)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .edgesIgnoringSafeArea(.top) // Still ignore top safe area for the gradient

                        Circle()
                            .fill(Color.red.opacity(0.18))
                            .frame(width: 180, height: 180)
                            .blur(radius: 40)
                            .offset(y: -40)

                        VStack(spacing: 12) {
                            GeometryReader { geometry in
                                Color.clear.frame(height: geometry.safeAreaInsets.top)
                            }
                            .frame(height: 10) // Use GeometryReader to get safe area inset height
                            HStack {
                                Button(action: {
                                    dismiss()
                                }) {
                                    Image(systemName: "chevron.left")
                                        .foregroundColor(Theme.onPrimaryColor)
                                        .imageScale(.large)
                                }
                                Spacer()
                            }
                            .padding(.top) // Add padding for the back button
                            
                            if let base64 = base64Image,
                               let data = Data(base64Encoded: base64),
                               let uiImage = UIImage(data: data)
                            {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                                    )
                                    .shadow(color: Color.black.opacity(0.2), radius: 4)
                            } else {
                                Image(systemName: "building.2.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60, height: 60)
                                    .padding(20)
                                    .background(Color.gray.opacity(0.2))
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                                    )
                                    .shadow(color: Color.black.opacity(0.2), radius: 4)
                            }

                            Text("\(jobs["job_title"]!)")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(Theme.onPrimaryColor)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)

                            HStack(spacing: 6) {
                                Text("\(jobs["companyName"]!)")
                                    .fontWeight(.medium)
                                    .foregroundColor(.gray)
                                Text("•")
                                    .foregroundColor(.gray)
                                Text("\(jobs["location"]!)")
                                    .foregroundColor(.gray)
                                Text("•")
                                    .foregroundColor(.gray)
                                Text("2 days ago") // Example, replace with actual data if available
                                    .foregroundColor(.gray)
                            }
                            .font(.subheadline)
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal)
                    }
                    // .frame(height: 280) // Remove fixed height for the header ZStack
                    // .edgesIgnoringSafeArea(.top) // Remove this modifier from ZStack

                    // --- Rest of the scrollable content ---
                    VStack(spacing: 16) {
                        // Required Giggle Grade Section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
//                                Image(systemName: "star.fill")
//                                    .foregroundColor(.yellow)
                                Text("Required Giggle Grade")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Theme.onPrimaryColor)
                                Spacer()
                                
                                Text("\(jobs["giggle_grade"]!)")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(Theme.secondaryColor)
                                    .padding(16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.blue.opacity(0.2))
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.blue.opacity(0.5), lineWidth: 2)
                                    )
                            }
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.black.opacity(0.3))
                        )
                        .padding(.horizontal)
                        
                        // Job Description Section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "doc.text")
                                    .foregroundColor(.gray)
                                Text("Job Description")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Theme.onPrimaryColor)
                                Spacer()
                            }
                            
                            Text("\(jobs["jobDescription"]!)")
                                .foregroundColor(Theme.onPrimaryColor)
                                .font(.system(size: 15))
                                .lineSpacing(4)
                                .padding(.top, 4)
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.black.opacity(0.3))
                        )
                        .padding(.horizontal)
                        
                        // Requirements Section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "checkmark.circle")
                                    .foregroundColor(.gray)
                                Text("Requirements")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Theme.onPrimaryColor)
                                Spacer()
                            }
                            
                            VStack(alignment: .leading, spacing: 10) {
                                ForEach(getRequirements(), id: \.self) { requirement in
                                    HStack(alignment: .top, spacing: 8) {
                                        Text("•")
                                            .foregroundColor(.gray)
                                        Text("\(requirement)")
                                            .foregroundColor(Theme.onPrimaryColor)
                                            .font(.system(size: 15))
                                            .lineSpacing(4)
                                    }
                                }
                            }
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.black.opacity(0.3))
                        )
                        .padding(.horizontal)
                        
                        // Location Section with MapKit
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "mappin.and.ellipse")
                                    .foregroundColor(.gray)
                                Text("Location")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Theme.onPrimaryColor)
                                Spacer()
                            }
                            
                            Text("\(jobs["location"]!)")
                                .foregroundColor(Theme.onPrimaryColor)
                                .font(.system(size: 15))
                                .padding(.top, 2)
                            
                            MapView(location: "Overlook Avenue, Belleville, NJ, USA")
                                .frame(height: 180)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                                .shadow(color: Color.black.opacity(0.1), radius: 2)
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.black.opacity(0.3))
                        )
                        .padding(.horizontal)
                        
                        // Information Section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "info.circle")
                                    .foregroundColor(.gray)
                                Text("Information")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Theme.onPrimaryColor)
                                Spacer()
                            }
                            
                            VStack(spacing: 12) {
                                InfoRow(title: "Position", value: "\(jobs["position"]!)")
                                InfoRow(title: "Qualification", value: "\(jobs["qualification"]!)")
                                InfoRow(title: "Experience", value: "\(jobs["experience"]!)")
                                InfoRow(title: "Job Type", value: "\(jobs["job_type"]!)")
                            }
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.black.opacity(0.3))
                        )
                        .padding(.horizontal)
                        
                        // Facilities and Others Section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "building.2")
                                    .foregroundColor(.gray)
                                Text("Facilities and Others")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Theme.onPrimaryColor)
                                Spacer()
                            }
                            
                            VStack(alignment: .leading, spacing: 10) {
                                ForEach(getFacilities(), id: \.self) { facility in
                                    HStack(alignment: .top, spacing: 8) {
                                        Text("•")
                                            .foregroundColor(.gray)
                                        Text("\(facility)")
                                            .foregroundColor(Theme.onPrimaryColor)
                                            .font(.system(size: 15))
                                            .lineSpacing(4)
                                    }
                                }
                            }
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.black.opacity(0.3))
                        )
                        .padding(.horizontal)
                        
                        Spacer(minLength: 20)
                    }
                    .padding(.top, 26)
                }
            }
            .background(Theme.backgroundColor.edgesIgnoringSafeArea(.all)) // Apply background to ScrollView's parent
            .edgesIgnoringSafeArea(.top) // Allow ScrollView content to go under status bar

            // Apply Button Section (Now outside ScrollView, at the bottom of ZStack)
            VStack(spacing: 0) { // Use spacing 0 to avoid extra space
                Divider()
                    .background(Color.white.opacity(0.3))

                HStack {
                    if fln == nil {
                        CustomButton(
                            title: "Please give FLN to Apply",
                            backgroundColor: Color.gray,
                            action: {
                                // Action remains the same
                                isApplied = true // Example state change
                                showAppliedAlert = true
                            },
                            width: 283,
                            height: 50,
                            cornerRadius: 10
                        )
                        .disabled(flnapply)
                        .shadow(color: Color.black.opacity(0.2), radius: 3)
                    } else {
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
                            cornerRadius: 10
                        )
                        .disabled(isApplied)
                        .shadow(color: Color.black.opacity(0.2), radius: 3)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10) // Add padding above the button
                .padding(.bottom) // Add padding below the button (respects safe area)
            }
            .background(Theme.backgroundColor) // Give the button container a background
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        // Remove .navigationBarBackground modifier as it's less relevant now
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
    
    private func getFacilities() -> [String] {
        guard let requirementsData = jobs["facilities"] else {
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

// Helper component for information rows
struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(title)
                .foregroundColor(.gray)
                .font(.system(size: 15, weight: .medium))
                .frame(width: 100, alignment: .leading)
            
            Spacer()
            
            Text(value)
                .foregroundColor(Theme.onPrimaryColor)
                .font(.system(size: 15))
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

// Extension to customize the navigation bar background
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
