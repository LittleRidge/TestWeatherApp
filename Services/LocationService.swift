//
//  LocationService.swift
//  TestWeatherApp
//
//  Created by Евгений Сергеев on 31.03.2026.
//

import CoreLocation
import UIKit

protocol LocationServiceProtocol {
    func requestLocation(completion: @escaping (CLLocation) -> Void)
}

final class LocationService: NSObject, LocationServiceProtocol {
    
    private let manager = CLLocationManager()
    private var completion: ((CLLocation) -> Void)?
    private var onAuthorizationChanged: (() -> Void)?
    
    private var previousStatus: CLAuthorizationStatus
    
    override init() {
        self.previousStatus = manager.authorizationStatus
        super.init()
        manager.delegate = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func requestLocation(completion: @escaping (CLLocation) -> Void) {
        self.completion = completion
        
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        default:
            completion(Self.defaultLocation)
        }
    }
    
    func setAuthorizationChangeHandler(_ handler: @escaping () -> Void) {
        self.onAuthorizationChanged = handler
    }
    
    // MARK: - App lifecycle
    
    @objc private func appDidBecomeActive() {
        let currentStatus = manager.authorizationStatus
        
        if currentStatus != previousStatus {
            previousStatus = currentStatus
            
            // вызовем обработчик
            onAuthorizationChanged?()
            
            // если разрешено, запросим локацию
            if currentStatus == .authorizedWhenInUse || currentStatus == .authorizedAlways {
                manager.requestLocation()
            } else {
                // иначе fallback
                completion?(Self.defaultLocation)
                completion = nil
            }
        }
    }
    
    private static var defaultLocation: CLLocation {
        Constants.defaultLocation.clLocation
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationService: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let currentStatus = manager.authorizationStatus
        if currentStatus != previousStatus {
            previousStatus = currentStatus
            onAuthorizationChanged?()
            
            if currentStatus == .authorizedWhenInUse || currentStatus == .authorizedAlways {
                manager.requestLocation()
            } else {
                completion?(Self.defaultLocation)
                completion = nil
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        completion?(location)
        completion = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        completion?(Self.defaultLocation)
        completion = nil
    }
}
