//
//  File.swift
//  
//
//  Created by Kurt Jacobs on 2022/10/11.
//

import Foundation

class LocationListingCellDisplayFormatter {
    private static var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter
    }
    
    private static var coordinatesFormatter: NumberFormatter {
        let coordinatesFormatter = NumberFormatter()
        coordinatesFormatter.numberStyle = .decimal
        coordinatesFormatter.maximumFractionDigits = 2
        coordinatesFormatter.minimumFractionDigits = 2
        return coordinatesFormatter
    }
    
    static func dateString(date: Date) -> String {
        return dateFormatter.string(from: date) ?? ""
    }
    
    static func coordinates(latitude: Double, longitude: Double) -> String {
        let latitudeString = coordinatesFormatter.string(from: NSNumber(value: latitude)) ?? ""
        let longitudeString = coordinatesFormatter.string(from: NSNumber(value: longitude)) ?? ""
        
        return "Coordinates: \(latitudeString), \(longitudeString)"
    }
    
    static func countryWithCity(country: String, city: String) -> String {
        return "\(city), \(country)"
    }
}
