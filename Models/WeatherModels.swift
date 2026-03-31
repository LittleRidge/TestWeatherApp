//
//  WeatherModels.swift
//  TestWeatherApp
//
//  Created by Евгений Сергеев on 31.03.2026.
//

import Foundation

struct CurrentWeatherResponse: Decodable {
    let location: LocationDTO
    let current: CurrentDTO
}

struct LocationDTO: Decodable {
    let name: String
}

struct CurrentDTO: Decodable {
    let temperature: Double
    let condition: ConditionDTO
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp_c"
        case condition
    }
}

struct ConditionDTO: Decodable {
    let text: String
    let icon: String
}
