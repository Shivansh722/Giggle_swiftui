import SwiftUI
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    
    @Published var currentLocation: CLLocation? // Published location property to be observed by the view
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        checkLocationAuthorization()  // Check location authorization status when initialized
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            // Request permission if it's not determined yet
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            print("Location access denied")
        case .authorizedWhenInUse, .authorizedAlways:
            // Permission already granted, no need to request again
            break
        @unknown default:
            break
        }
    }
    
    func requestLocationPermission() {
        // Request permission when needed
        locationManager.requestWhenInUseAuthorization()
    }
    
    func fetchLocation() {
        // Fetch location once when called
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways {
            locationManager.requestLocation() // Fetch location once
        } else {
            requestLocationPermission() // Request permission if not granted
        }
    }
    
    // Handle authorization changes
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            // Fetch location once authorization is granted
            locationManager.requestLocation()
        case .denied, .restricted:
            print("Location access denied")
        case .notDetermined:
            // Do nothing, wait for user action
            break
        @unknown default:
            break
        }
    }
    
    // Handle location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.first else { return }
        DispatchQueue.main.async { // Ensure UI updates on main thread
            self.currentLocation = newLocation
            print("New Location: \(newLocation.coordinate.latitude), \(newLocation.coordinate.longitude)") // For debugging
        }
        // No need to stop updates explicitly since requestLocation() only fetches once
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
