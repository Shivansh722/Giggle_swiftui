import SwiftUI
import CoreLocation
import MapKit

struct LocationView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var isLocationPicked = false
    @State private var showLocationEditIcon = false
    @State private var navigateToEduView1 = false
    @State private var address: String = "Fetching address..."
    
    // Add FocusState for potential future text fields
    @FocusState private var focusedField: Field?
    enum Field {
        case example // Placeholder for future fields
    }
    
    var body: some View {
        ZStack {
            Theme.backgroundColor
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Header and Progress
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text("Location")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.primaryColor)
                            Text("Details")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.onPrimaryColor)
                        }
                        .padding(.leading, 30)
                    }
                    Spacer()
                }
                .padding(.top, 20)

                ProgressView(value: 40, total: 100)
                    .accentColor(Theme.primaryColor)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 20)

                // Image and Text (Hide image when location is picked)
                if !isLocationPicked {
                    Image("local")
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, 120)
                        .padding(.top, 50)
                }

                Text("Discover the best Gigs for you with Giggle!")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.onPrimaryColor)
                    .padding(.top, 12)

                Text("With Giggle, you can fund your own dates—no need to call your dad!")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(Theme.onPrimaryColor)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 35)
                    .padding(.top, 12)

                // Map Preview
                if let location = locationManager.currentLocation {
                    ZStack(alignment: .topTrailing) {
                        Map(coordinateRegion: $region, showsUserLocation: true)
                            .frame(height: 200)
                            .cornerRadius(10)
                            .padding(.horizontal, 30)
                            .padding(.top, 20)
                    }

                    Text("Current Location: \(address)")
                        .font(.subheadline)
                        .foregroundColor(Theme.onPrimaryColor)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                        .padding(.top, 10)
                }

                Spacer() // Pushes the button to the bottom

                // Navigation and Button
                NavigationLink(
                    destination: eduView2(),
                    isActive: $navigateToEduView1
                ) {
                    EmptyView()
                }

                Button(action: {
                    if !isLocationPicked {
                        locationManager.fetchLocation()
                    } else {
                        print("Proceed to the next screen or step")
                        navigateToEduView1 = true
                    }
                }) {
                    Text(isLocationPicked ? "NEXT" : "PICK YOUR CURRENT LOCATION")
                        .font(.headline)
                        .foregroundColor(Theme.onPrimaryColor)
                        .frame(width: 320, height: 50)
                        .background(Theme.primaryColor)
                        .cornerRadius(6)
                }
                .frame(maxWidth: .infinity, alignment: .center) // Center the button
                .padding(.bottom, 20)
            }
            
            // Progress Indicator Overlay
            if !isLocationPicked && locationManager.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .progressViewStyle(CircularProgressViewStyle(tint: Theme.secondaryColor))
                    .frame(width: 120, height: 120)
                    .cornerRadius(10)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onTapGesture {
            focusedField = nil // Dismiss keyboard on tap (for future fields)
        }
        .onChange(of: locationManager.currentLocation) { newLocation in
            if let newLocation = newLocation {
                region.center = newLocation.coordinate
                isLocationPicked = true
                showLocationEditIcon = true
                updateAddress(from: newLocation)
            }
        }
    }
    
    // Function to reverse geocode location to address
    private func updateAddress(from location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Reverse geocoding failed: \(error.localizedDescription)")
                address = "Unable to fetch address"
                return
            }
            
            if let placemark = placemarks?.first {
                let addressComponents = [
                    placemark.subThoroughfare, // e.g., house number
                    placemark.thoroughfare,    // e.g., street name
                    placemark.locality,        // e.g., city
                    placemark.administrativeArea, // e.g., state
                    placemark.postalCode,      // e.g., ZIP code
                    placemark.country          // e.g., country
                ].compactMap { $0 }.joined(separator: ", ")
                
                address = addressComponents.isEmpty ? "Unknown address" : addressComponents
            } else {
                address = "Unknown address"
            }
        }
    }
}

#Preview {
    LocationView()
}
