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
    let maxTemperature: Double
    let minTemperature: Double
    let condition: ConditionDTO
    
    enum CodingKeys: String, CodingKey {
        case maxTemperature = "maxtemp_c"
        case minTemperature = "mintemp_c"
        case condition
    }
}

struct HourDTO: Decodable {
    let time: String
    let temperature: Double
    let condition: ConditionDTO
    
    enum CodingKeys: String, CodingKey {
        case time
        case condition
        case temperature = "temp_c"
    }
}
