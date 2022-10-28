//
//  File.swift
//  
//
//  Created by Kurt Jacobs on 2022/10/11.
//

import Foundation
import FirebaseFirestore
import domain_layer

public struct LocationDTO: DataRepositoryDocument {
    public var documentId: String
    public var latitude: Double
    public var longitude: Double
    public var date: Date
    public var city: String
    public var country: String
    public var locale: String
}

extension LocationDTO {
    func entity() -> domain_layer.Location {
        return Location(id: documentId,
                        latitude: latitude,
                        longitude: longitude,
                        date: date,
                        city: city,
                        country: country,
                        locale: locale)
    }
}

extension Location {
    func dto() -> LocationDTO {
        return LocationDTO(documentId: id,
                           latitude: latitude,
                           longitude: longitude,
                           date: date,
                           city: city,
                           country: country,
                           locale: locale)
    }
}
