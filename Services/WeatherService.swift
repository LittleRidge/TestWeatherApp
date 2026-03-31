//
//  WeatherService.swift
//  TestWeatherApp
//
//  Created by Евгений Сергеев on 31.03.2026.
//

import CoreLocation

protocol WeatherServiceProtocol {
    func getWeather(for location: CLLocation) async throws -> (CurrentDTO, [ForecastDayDTO])
}

final class WeatherService: WeatherServiceProtocol {
    
    private let network: NetworkServiceProtocol
    
    init(network: NetworkServiceProtocol = NetworkService()) {
        self.network = network
    }
    
    func getWeather(for location: CLLocation) async throws -> (CurrentDTO, [ForecastDayDTO]) {
        
        async let currentResponse: CurrentWeatherResponse =
        network.request(
            WeatherEndpoint.current(
                lat: location.coordinate.latitude,
                lon: location.coordinate.longitude
            )
        )
        
        async let forecastResponse: ForecastResponse =
        network.request(
            WeatherEndpoint.forecast(
                lat: location.coordinate.latitude,
                lon: location.coordinate.longitude,
                days: 3
            )
        )
        
        let current = try await currentResponse.current
        let forecast = try await forecastResponse.forecast.forecastday
        
        return (current, forecast)
    }
}
