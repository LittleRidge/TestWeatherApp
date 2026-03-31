//
//  MainViewModel.swift
//  TestWeatherApp
//
//  Created by Евгений Сергеев on 31.03.2026.
//

import Foundation
import CoreLocation

final class MainViewModel {
    
    private let locationService: LocationServiceProtocol
    private let geocodingService: GeocodingServiceProtocol
    private let weatherService: WeatherServiceProtocol
    
    var onStateChange: ((MainViewState) -> Void)?
    
    init(
        locationService: LocationServiceProtocol = LocationService(),
        geocodingService: GeocodingServiceProtocol = GeocodingService(),
        weatherService: WeatherServiceProtocol = WeatherService()
    ) {
        self.locationService = locationService
        self.geocodingService = geocodingService
        self.weatherService = weatherService
        
        if let locService = locationService as? LocationService {
            locService.setAuthorizationChangeHandler { [weak self] in
                self?.load()
            }
        }
    }
    
    func load() {
        onStateChange?(.loading)
        
        locationService.requestLocation { [weak self] location in
            guard let self else { return }
            
            Task {
                do {
                    async let cityTask = self.geocodingService.getCity(from: location)
                    async let weatherTask = self.weatherService.getWeather(for: location)
                    
                    let city = await cityTask
                    let (current, forecastDays) = try await weatherTask
                    
                    var hourly: [HourlyForecastModel] = []
                    
                    let now = Date()
                    
                    if forecastDays.count >= 1 {
                        let today = forecastDays[0]
                        for hour in today.hour {
                            if let hourDate = DateFormatter.apiDateTime.date(from: hour.time), hourDate >= now {
                                hourly.append(HourlyForecastModel(
                                    time: DateFormatter.hour.string(from: hourDate),
                                    temperature: "\(Int(hour.temperature))°",
                                    iconURL: URL(string: "https:\(hour.condition.icon)")
                                ))
                            }
                        }
                    }
                    
                    if forecastDays.count >= 2 {
                        let tomorrow = forecastDays[1]
                        for hour in tomorrow.hour {
                            if let hourDate = DateFormatter.apiDateTime.date(from: hour.time) {
                                hourly.append(HourlyForecastModel(
                                    time: DateFormatter.hour.string(from: hourDate),
                                    temperature: "\(Int(hour.temperature))°",
                                    iconURL: hour.condition.icon.asIconURL
                                ))
                            }
                        }
                    }
                    
                    let daily: [DailyForecastModel] = forecastDays.map { day in
                        let date = DateFormatter.apiDate.date(from: day.date) ?? Date()
                        let dayName = DateFormatter.weekdayShort.string(from: date)
                        
                        return DailyForecastModel(
                            day: dayName,
                            minTemperature: "\(Int(day.day.minTemperature))°",
                            maxTemperature: "\(Int(day.day.maxTemperature))°",
                            iconURL: day.day.condition.icon.asIconURL
                        )
                    }
                    
                    let temp = "\(Int(current.temperature))°"
                    let condition = current.condition.text
                                        
                    await MainActor.run {
                        self.onStateChange?(
                            .loaded(
                                city: city,
                                temperature: temp,
                                condition: condition,
                                hourly: hourly,
                                daily: daily
                            )
                        )
                    }
                    
                } catch {
                    await MainActor.run {
                        self.onStateChange?(.error)
                    }
                }
            }
        }
    }    
}

enum MainViewState {
    case loading
    case loaded(
        city: String,
        temperature: String,
        condition: String,
        hourly: [HourlyForecastModel],
        daily: [DailyForecastModel]
    )
    case error
}
