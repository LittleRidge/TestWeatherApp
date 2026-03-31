//
//  Extension+String.swift
//  TestWeatherApp
//
//  Created by Евгений Сергеев on 31.03.2026.
//

import Foundation

extension String {
    var asIconURL: URL? {
        if self.hasPrefix("http") { return URL(string: self) }
        return URL(string: "https:\(self)")
    }
}
