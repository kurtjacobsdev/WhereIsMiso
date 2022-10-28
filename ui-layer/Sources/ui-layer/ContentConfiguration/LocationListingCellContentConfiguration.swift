//
//  File.swift
//  
//
//  Created by Kurt Jacobs on 2022/10/12.
//

import Foundation
import domain_layer

struct LocationListingCellConfiguration {
    let locale: String
    let coordinates: String
    let date: String
    let countryWithCity: String
    
    init(locale: String, coordinates: String, date: String, countryWithCity: String) {
        self.locale = locale
        self.coordinates = coordinates
        self.date = date
        self.countryWithCity = countryWithCity
    }
}

extension Location {
    func configuration() -> LocationListingCellConfiguration {
        let countryWithCity = LocationListingCellDisplayFormatter.countryWithCity(country: country, city: city)
        let coordinates = LocationListingCellDisplayFormatter.coordinates(latitude: latitude, longitude: longitude)
        let date = LocationListingCellDisplayFormatter.dateString(date: date)
        return LocationListingCellConfiguration(locale: locale, coordinates: coordinates, date: date, countryWithCity: countryWithCity)
    }
}
