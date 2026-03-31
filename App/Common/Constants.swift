//
//  Constants.swift
//  TestWeatherApp
//
//  Created by Евгений Сергеев on 31.03.2026.
//

import CoreLocation

struct Constants {
    
    static let baseURL = "https://api.weatherapi.com/v1"
    
    struct Location {
        let latitude: Double
        let longitude: Double
        let cityName: String
        
        var clLocation: CLLocation {
            CLLocation(latitude: latitude, longitude: longitude)
        }
    }
    
    static let defaultLocation = Location(
        latitude: 55.7558,
        longitude: 37.6173,
        cityName: "Moscow"
    )
    
    enum API {
        static let key = "fa8b3df74d4042b9aa7135114252304"
    }
    
    enum RequestPath {
        static let current = "/current.json"
        static let forecast = "/forecast.json"
    }
}
