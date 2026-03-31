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
    let temperature: Int
    let condition: ConditionDTO
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp_c"
        case condition
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        condition = try container.decode(ConditionDTO.self, forKey: .condition)
        
        let temperatureInDouble = try container.decode(Double.self, forKey: .temperature)
        temperature = Int(temperatureInDouble)
    }
}

struct ConditionDTO: Decodable {
    let text: String
    let icon: String
}
