//
//  Endpoint.swift
//  TestWeatherApp
//
//  Created by Евгений Сергеев on 31.03.2026.
//

import Foundation

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
}

extension Endpoint {
    
    var url: URL? {
        var components = URLComponents(string: baseURL)
        components?.path += path
        components?.queryItems = queryItems
        return components?.url
    }
}

enum WeatherEndpoint: Endpoint {
    
    case current(lat: Double, lon: Double)
    case forecast(lat: Double, lon: Double, days: Int)
    
    var baseURL: String { Constants.baseURL }
    
    var path: String {
        switch self {
        case .current:
            Constants.RequestPath.current
        case .forecast:
            Constants.RequestPath.forecast
        }
    }
    
    var queryItems: [URLQueryItem] {
        var items = baseQueryItems
        
        switch self {
        case .current:
            break
            
        case let .forecast(_, _, days):
            items.append(.init(name: "days", value: "\(days)"))
        }
        
        return items
    }
    
    private var baseQueryItems: [URLQueryItem] {
        switch self {
        case let .current(lat, lon),
            let .forecast(lat, lon, _):
            return [
                .init(name: "key", value: Constants.API.key),
                .init(name: "q", value: "\(lat),\(lon)")
            ]
        }
    }
}
