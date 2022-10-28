//
//  File.swift
//  
//
//  Created by Kurt Jacobs on 2022/10/12.
//

import Foundation
import CoreLocation
import domain_layer

struct MainViewMapPinContentConfiguration {
    let coordinates: CLLocationCoordinate2D
    let title: String
    let subtitle: String
    
    init(coordinates: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinates = coordinates
        self.title = title
        self.subtitle = subtitle
    }
}

extension Location {
    func configuration() -> MainViewMapPinContentConfiguration {
        let date = LocationListingCellDisplayFormatter.dateString(date: Date())
        return MainViewMapPinContentConfiguration(coordinates: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), title: country, subtitle: date)
    }
}
