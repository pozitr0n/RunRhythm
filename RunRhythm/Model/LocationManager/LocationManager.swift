//
//  LocationManager.swift
//  RunRhythm
//
//  Created by Raman Kozar on 04/11/2024.
//
import SwiftUI
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private var locationManager = CLLocationManager()
    
    // Current speed
    @Published var speed: Double = 0.0
    
    override init() {
        
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        print("LocationManager initialized and started updating location.")
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        
        // Update speed in m/s, excluding negative values
        self.speed = max(location.speed, 0)
        print("Speed updated: \(self.speed) m/s")
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            print("Location permission granted.")
        case .denied, .restricted:
            print("Location permission denied.")
        default:
            break
        }
        
    }
    
}
