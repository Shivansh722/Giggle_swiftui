//
//  location-client.swift
//  Giggle_swiftui
//
//  Created by user@91 on 11/02/25.
//

import SwiftUI
import CoreLocation
import MapKit

struct LocationClientiew: View {
    @StateObject private var locationManager = LocationManager() // Create an instance of LocationManager
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // Default to San Francisco
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @State private var isLocationPicked = false // Track if location is picked
    @State private var showLocationEditIcon = false // Track if edit icon should be shown
    @State private var navigateToEduView1 = false
    @StateObject var saveClientInfo = ClientHandlerUserInfo(appService: AppService())

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
                            ZStack(alignment: .topTrailing) {
                                Map(coordinateRegion: $region, showsUserLocation: true)
                                    .frame(height: 200)
                                    .cornerRadius(10)
                                    .padding(.horizontal, geometry.size.width * 0.08)
                                    .padding(.top, 20)

                                // Edit Icon
                                if isLocationPicked {
                                    Button(action: {
                                        // Reset location and region
                                        isLocationPicked = false
                                        region.center = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194) // Reset to default
                                        locationManager.startUpdatingLocation() // Allow user to pick location again
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
                                .padding(.top, 20)
                        }

                        NavigationLink(
                            destination: HomeClientView(),
                            isActive: $navigateToEduView1
                        ) {
                            EmptyView()
                        }

                        // Use Spacer to push the button to the bottom
                        Spacer()

                        CustomButton(
                            title: isLocationPicked ? "NEXT" : "PICK YOUR CURRENT LOCATION",
                            backgroundColor: Theme.primaryColor,
                            action: {
                                if !isLocationPicked {
                                    locationManager.requestLocationPermission() // Request permission if not granted
                                    locationManager.startUpdatingLocation()  // Start location updates after button press
                                } else {
                                    // Proceed to the next step
                                    print("Proceed to the next screen or step")
//                                    navigateToEduView1 = true
                                    
                                        Task{
                                            await saveClientInfo.saveClientInfo()
                                            navigateToEduView1 = true
                                        }
                                }
                            },
                            width: 320,
                            height: 50,
                            cornerRadius: 6
                        )
                        .padding(.top, 8)
                        .padding(.bottom, 20) // Add bottom padding to ensure the button isn't too close to the edge
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensure the VStack takes up the full space
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onChange(of: locationManager.currentLocation) { newLocation in
            if let newLocation = newLocation {
                // Update the map region to center on the new location
                region.center = newLocation.coordinate
                // Mark that the location has been picked
                isLocationPicked = true
                showLocationEditIcon = true
            }
        }
    }
    
    private func setLocation(){
        ClientFormManager.shared.clientData.location = "37.3347302 , -122.0089189"
    }
}

#Preview {
    LocationClientiew()
}
