//
//  WeatherResponse.swift
//  TestWeatherApp
//
//  Created by Евгений Сергеев on 31.03.2026.
//

struct ForecastResponse: Decodable {
    let forecast: ForecastDTO
}

struct ForecastDTO: Decodable {
    let forecastday: [ForecastDayDTO]
}

struct ForecastDayDTO: Decodable {
    let date: String
    let day: DayDTO
    let hour: [HourDTO]
}

struct DayDTO: Decodable {
    let maxTemperature: Int
    let minTemperature: Int
    let condition: ConditionDTO
    
    enum CodingKeys: String, CodingKey {
        case maxTemperature = "maxtemp_c"
        case minTemperature = "mintemp_c"
        case condition
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        condition = try container.decode(ConditionDTO.self, forKey: .condition)
        
        let maxTemperatureInDouble = try container.decode(Double.self, forKey: .maxTemperature)
        maxTemperature = Int(maxTemperatureInDouble)
        
        let minTemperatureInDouble = try container.decode(Double.self, forKey: .minTemperature)
        minTemperature = Int(minTemperatureInDouble)
    }
}

struct HourDTO: Decodable {
    let time: String
    let temperature: Int
    let condition: ConditionDTO
    
    enum CodingKeys: String, CodingKey {
        case time
        case condition
        case temperature = "temp_c"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        time = try container.decode(String.self, forKey: .time)
        condition = try container.decode(ConditionDTO.self, forKey: .condition)
        
        let tempDouble = try container.decode(Double.self, forKey: .temperature)
        temperature = Int(tempDouble)
    }
}
