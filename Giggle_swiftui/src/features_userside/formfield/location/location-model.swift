import SwiftUI
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    
    @Published var currentLocation: CLLocation?
    @Published var isLoading: Bool = false // Added for progress indicator
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        checkLocationAuthorization()
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            print("Location access denied")
        case .authorizedWhenInUse, .authorizedAlways:
            break
        @unknown default:
            break
        }
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func fetchLocation() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways {
            isLoading = true // Start loading
            locationManager.requestLocation()
        } else {
            requestLocationPermission()
        }
    }
    
    // Handle authorization changes
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            isLoading = true // Start loading when authorized
            locationManager.requestLocation()
        case .denied, .restricted:
            print("Location access denied")
            isLoading = false // Stop loading if denied
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
    
    // Handle location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.first else { return }
        DispatchQueue.main.async {
            self.currentLocation = newLocation
            self.isLoading = false // Stop loading when location is fetched
            print("New Location: \(newLocation.coordinate.latitude), \(newLocation.coordinate.longitude)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
        DispatchQueue.main.async {
            self.isLoading = false // Stop loading on error
        }
    }
}
