import SwiftUI
import CoreLocation
import MapKit

struct LocationClientiew: View {
    @StateObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @State private var isLocationPicked = false
    @State private var showLocationEditIcon = false
    @State private var navigateToEduView1 = false
    @State private var address: String = "Fetching address..."
    @StateObject var saveClientInfo = ClientHandlerUserInfo(appService: AppService())

    var body: some View {
        ZStack {
            Theme.backgroundColor
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    // Header
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
                            .padding(.leading, 30) // Fixed padding
                        }
                        Spacer()
                    }
                    .padding(.top, 20) // Fixed padding

                    ProgressView(value: 20, total: 100)
                        .accentColor(Theme.primaryColor)
                        .padding(.horizontal, 30) // Fixed padding
                        .padding(.bottom, 20)

                    // Show "local" image only if location isn't picked
                    if !isLocationPicked {
                        Image("local")
                            .resizable()
                            .scaledToFit()
                            .padding(.horizontal, 120) // Fixed padding (approx 40% of typical 375pt width)
                            .padding(.top, 70) // Fixed padding (approx 9% of typical 812pt height)
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
                                .padding(.horizontal, 30) // Fixed padding
                                .padding(.top, 20)

                        }

                        Text("Current Location: \(address)")
                            .font(.subheadline)
                            .foregroundColor(Theme.onPrimaryColor)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30) // Fixed padding
                            .padding(.top, 10)
                    }

                    Spacer()

                    NavigationLink(
                        destination: HomeClientView(),
                        isActive: $navigateToEduView1
                    ) {
                        EmptyView()
                    }

                    Button(action: {
                        if !isLocationPicked {
                            locationManager.fetchLocation()
                        } else {
                            print("Proceed to the next screen or step")
                            Task {
                                setLocation()
                                await saveClientInfo.saveClientInfo()
                                let userDefault = UserDefaults.standard
                                userDefault.set(FormManager.shared.formData.userId, forKey: "userID")
                                userDefault.set("completed client", forKey: "status")
                                let status = UserDefaults.standard.string(forKey: "status")
                                print(status!)
                                navigateToEduView1 = true
                            }
                        }
                    }) {
                        Text(isLocationPicked ? "NEXT" : "PICK YOUR CURRENT LOCATION")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 320, height: 50)
                            .background(Theme.primaryColor)
                            .cornerRadius(6)
                    }
                    .frame(maxWidth: .infinity, alignment: .center) // Center the button
                    .padding(.bottom, 20)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationBarBackButtonHidden(true)
        .onChange(of: locationManager.currentLocation) { newLocation in
            if let newLocation = newLocation {
                region.center = newLocation.coordinate
                isLocationPicked = true
                showLocationEditIcon = true
                updateAddress(from: newLocation)
            }
        }
    }
    
    private func setLocation() {
        if let location = locationManager.currentLocation {
            ClientFormManager.shared.clientData.location = "\(location.coordinate.latitude), \(location.coordinate.longitude)"
        }
    }
    
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
                    placemark.subThoroughfare,
                    placemark.thoroughfare,
                    placemark.locality,
                    placemark.administrativeArea,
                    placemark.postalCode,
                    placemark.country
                ].compactMap { $0 }.joined(separator: ", ")
                
                address = addressComponents.isEmpty ? "Unknown address" : addressComponents
            } else {
                address = "Unknown address"
            }
        }
    }
}

#Preview {
    LocationClientiew()
}
