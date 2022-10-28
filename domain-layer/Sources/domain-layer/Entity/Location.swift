//
//  File.swift
//  
//
//  Created by Kurt Jacobs on 2022/10/11.
//

import Foundation

public struct Location: Codable {
    public var id: String
    public var latitude: Double
    public var longitude: Double
    public var date: Date
    public var city: String
    public var country: String
    public var locale: String
    
    public init(id: String, latitude: Double, longitude: Double, date: Date, city: String, country: String, locale: String) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.date = date
        self.city = city
        self.country = country
        self.locale = locale
    }
}
