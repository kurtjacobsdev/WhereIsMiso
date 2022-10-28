//
//  File.swift
//  
//
//  Created by Kurt Jacobs on 2022/10/11.
//

import Foundation

public struct CurrentLocationEntity {
    public var countryLocale: String
    public var countryName: String
    public var cityName: String
    public var latitudeCoordinate: Double
    public var longitudeCoordinate: Double
    
    public init(countryLocale: String, countryName: String, cityName: String, latitudeCoordinate: Double, longitudeCoordinate: Double) {
        self.countryLocale = countryLocale
        self.countryName = countryName
        self.cityName = cityName
        self.latitudeCoordinate = latitudeCoordinate
        self.longitudeCoordinate = longitudeCoordinate
    }
}
