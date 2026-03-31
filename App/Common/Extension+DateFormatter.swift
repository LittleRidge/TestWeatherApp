//
//  Extension+DateFormatter.swift
//  TestWeatherApp
//
//  Created by Евгений Сергеев on 31.03.2026.
//

import Foundation

extension DateFormatter {
    
    static let apiDateTime: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm"
        df.locale = Locale(identifier: "en_US_POSIX")
        return df
    }()
    
    static let hour: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        return df
    }()
    
    static let apiDate: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        df.timeZone = TimeZone(secondsFromGMT: 0)
        df.locale = Locale(identifier: "en_US_POSIX")
        return df
    }()
    
    static let weekdayShort: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "E"
        df.locale = Locale.current
        return df
    }()
}
