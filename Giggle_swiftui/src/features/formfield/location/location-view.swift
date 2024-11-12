import SwiftUI
import CoreLocation
import MapKit

struct LocationView: View {
    @StateObject private var locationManager = LocationManager() // Create an instance of LocationManager
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // Default to San Francisco
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Theme.backgroundColor
                    .edgesIgnoringSafeArea(.all)
                ScrollView {
                    VStack {
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
                                .padding(.leading, geometry.size.width * 0.08)
                            }
                            Spacer()
                        }
                        .padding(.top, geometry.size.height * 0.02)

                        ProgressView(value: 20, total: 100)
                            .accentColor(Theme.primaryColor)
                            .padding(.horizontal, geometry.size.width * 0.08)
                            .padding(.bottom, 20)

                        Image("local")
                            .resizable()
                            .scaledToFit()
                            .padding(.horizontal, geometry.size.width * 0.4)
                            .padding(.top, geometry.size.height * 0.09)

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

                        // Map Preview: Show the map with the user's current location if available
                        if let location = locationManager.currentLocation {
                            Map(coordinateRegion: $region, showsUserLocation: true)
                                .frame(height: 200)
                                .cornerRadius(10)
                                .padding(.horizontal, geometry.size.width * 0.08)
                                .padding(.top, 20)

                            Text("Current Location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                                .font(.subheadline)
                                .foregroundColor(Theme.onPrimaryColor)
                                .padding(.top, 20)
                        }

                        CustomButton(title: "PICK YOUR CURRENT LOCATION", backgroundColor: Theme.primaryColor, action: {
                            locationManager.requestLocationPermission() // Call method to request permission
                            locationManager.startUpdatingLocation()  // Start location updates after button press
                        }, width: 320, height: 50, cornerRadius: 6)
                        .padding(.top, 280)
                    }
                    .padding(.bottom, 20) // Ensure bottom padding for the last element
                }
            }
        }
        .onChange(of: locationManager.currentLocation) { newLocation in
            if let newLocation = newLocation {
                // Update the map region to center on the new location
                region.center = newLocation.coordinate
            }
        }
    }
}
