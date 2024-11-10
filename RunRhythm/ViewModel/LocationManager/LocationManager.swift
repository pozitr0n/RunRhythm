//
//  LocationManager.swift
//  RunRhythm
//
//  Created by Raman Kozar on 04/11/2024.
//
import Foundation
import CoreLocation

class LocationViewModel: NSObject, ObservableObject {
    
    let smoothingFactor = 0.8
    var lastSpeed: Double = 0
    
    private var locationManager: CLLocationManager?
    
    @Published var speed = Double.zero
    @Published var log: String?
    
    init(locationManager: CLLocationManager = CLLocationManager()) {
        
        super.init()
        self.locationManager = locationManager
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        
    }
    
}

extension LocationViewModel: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        switch manager.authorizationStatus {
        case .notDetermined:
            log = "Location authorization not determined"
        case .restricted:
            log = "Location authorization restricted"
        case .denied:
            log = "Location authorization denied"
        case .authorizedAlways:
            manager.startUpdatingLocation()
            manager.startUpdatingHeading()
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
            manager.startUpdatingHeading()
        @unknown default:
            log = "Unknown authorization status"
        }
        
    }
        
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        locations.forEach { location in
            
            let speed = location.speed >= 0 ? location.speed : 0
            lastSpeed = lastSpeed * smoothingFactor + speed * (1 - smoothingFactor)
            
            self.speed = lastSpeed
            
        }
        
    }
    
}
