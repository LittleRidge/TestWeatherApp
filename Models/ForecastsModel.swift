//
//  ForecastsModel.swift
//  TestWeatherApp
//
//  Created by Евгений Сергеев on 31.03.2026.
//

import Foundation

struct HourlyForecastModel: Hashable, Sendable {
    let id = UUID()
    let time: String
    let temperature: String
    let iconURL: URL?
    
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

struct DailyForecastModel: Hashable, Sendable {
    let id = UUID()
    let day: String
    let minTemperature: String
    let maxTemperature: String
    let iconURL: URL?
    
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
