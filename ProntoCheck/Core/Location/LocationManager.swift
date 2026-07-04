//
//  LocationManager.swift
//  ProntoCheck
//
//  Created by luisr on 04/07/26.
//


import Foundation
import CoreLocation
import Combine

/// Handles location permissions, location updates, and geofence validation.
final class LocationManager: NSObject, ObservableObject {

    private let manager = CLLocationManager()

    @Published private(set) var location: CLLocation?
    @Published private(set) var authorizationStatus: CLAuthorizationStatus = .notDetermined

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func start() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func stop() {
        manager.stopUpdatingLocation()
    }

    func isInside(
        center: CLLocationCoordinate2D,
        radius: CLLocationDistance
    ) -> Bool {
        guard let location else { return false }

        let accessPointLocation = CLLocation(
            latitude: center.latitude,
            longitude: center.longitude
        )

        return location.distance(from: accessPointLocation) <= radius
    }
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus

        if authorizationStatus == .authorizedWhenInUse ||
            authorizationStatus == .authorizedAlways {
            manager.startUpdatingLocation()
        }
    }

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        location = locations.last
    }
}