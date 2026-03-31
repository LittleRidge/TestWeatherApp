//
//  GeocodingService.swift
//  TestWeatherApp
//
//  Created by Евгений Сергеев on 31.03.2026.
//

import CoreLocation

protocol GeocodingServiceProtocol {
    func getCity(from location: CLLocation) async -> String
}

final class GeocodingService: GeocodingServiceProtocol {
    
    private let geocoder = CLGeocoder()
    
    func getCity(from location: CLLocation) async -> String {
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            let placemark = placemarks.first
            
            return placemark?.locality
            ?? placemark?.subAdministrativeArea
            ?? placemark?.administrativeArea
            ?? Constants.defaultLocation.cityName
            
        } catch {
            return Constants.defaultLocation.cityName
        }
    }
}
