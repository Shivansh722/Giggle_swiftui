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

    var body: some View {
        GeometryReader { geometry in
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
                            .padding(.leading, geometry.size.width * 0.08)
                        }
                        Spacer()
                    }
                    .padding(.top, geometry.size.height * 0.02)

                    ProgressView(value: 20, total: 100)
                        .accentColor(Theme.primaryColor)
                        .padding(.horizontal, geometry.size.width * 0.08)
                        .padding(.bottom, 20)

                    // Image and Text
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

                    // Map Preview
                    if let location = locationManager.currentLocation {
                        ZStack(alignment: .topTrailing) {
                            Map(coordinateRegion: $region, showsUserLocation: true)
                                .frame(height: 200)
                                .cornerRadius(10)
                                .padding(.horizontal, geometry.size.width * 0.08)
                                .padding(.top, 20)

                            if isLocationPicked {
                                Button(action: {
                                    isLocationPicked = false
                                    region.center = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
                                    locationManager.fetchLocation() // Fetch a new location instead of continuous updates
                                }) {
                                    Image(systemName: "pencil.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.red)
                                        .padding()
                                }
                            }
                        }

                        Text("Current Location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                            .font(.subheadline)
                            .foregroundColor(Theme.onPrimaryColor)
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

                    CustomButton(
                        title: isLocationPicked ? "NEXT" : "PICK YOUR CURRENT LOCATION",
                        backgroundColor: Theme.primaryColor,
                        action: {
                            if !isLocationPicked {
                                locationManager.fetchLocation() // Fetch location once
                            } else {
                                print("Proceed to the next screen or step")
                                navigateToEduView1 = true
                            }
                        },
                        width: 320,
                        height: 50,
                        cornerRadius: 6
                    )
                    .padding(.bottom, 20)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onChange(of: locationManager.currentLocation) { newLocation in
            if let newLocation = newLocation {
                region.center = newLocation.coordinate
                isLocationPicked = true
                showLocationEditIcon = true
            }
        }
    }
}

#Preview {
    LocationView()
}
