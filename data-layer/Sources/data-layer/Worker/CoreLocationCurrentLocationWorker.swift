//
//  File.swift
//  
//
//  Created by Kurt Jacobs on 2022/10/11.
//

import Foundation
import domain_layer
import AsyncLocationKit
import CoreLocation

public class CoreLocationCurrentLocationWorker: CurrentLocationWorker {
    private var locationManager = AsyncLocationManager(desiredAccuracy: .bestAccuracy)
    
    public init() { }
    
    public func get() async throws -> domain_layer.CurrentLocationEntity? {
        guard CLLocationManager.locationServicesEnabled() else {
            throw ConcreteCurrentLocationWorkerError.locationServicesDisabled
        }
    
        let location = try await locationManager.requestLocation()
        
        switch location {
        case let .didUpdateLocations(locations):
            guard let location = locations.first else {
                return nil
            }
            let coordinate = location.coordinate
            guard let placemark = try await location.placemark() else { return nil}
            return CurrentLocationEntity(countryLocale: placemark.isoCountryCode ?? "",
                                         countryName: placemark.country ?? "" ,
                                         cityName: placemark.locality ?? placemark.subLocality ?? "",
                                         latitudeCoordinate: coordinate.latitude,
                                         longitudeCoordinate: coordinate.longitude)
        default:
            return nil
        }
    }
}

enum ConcreteCurrentLocationWorkerError: Error {
    case locationServicesDisabled
}

private extension CLLocation {
    func placemark() async throws -> CLPlacemark? {
        let placemark = try await CLGeocoder().reverseGeocodeLocation(self)
        return placemark.first
    }
}
