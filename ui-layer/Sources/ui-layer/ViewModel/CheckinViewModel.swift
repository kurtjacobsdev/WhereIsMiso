//
//  File.swift
//  
//
//  Created by Kurt Jacobs on 2022/10/10.
//

import Foundation
import Combine
import CoreLocation
import domain_layer

public protocol CheckinViewModelDependencies {
    var checkinUseCase: CheckinUseCase { get }
}

enum CheckinViewModelError: Error {
    case currentLocationNotFound
}

class CheckinViewModel {
    private var dependencies: CheckinViewModelDependencies
        
    @Published var isCheckingIn: Bool = false
    @Published var isUpdatingLocation: Bool = false
    @Published var currentLocation: CurrentLocationEntity?
    
    init(dependencies: CheckinViewModelDependencies) {
        self.dependencies = dependencies
    }
    
    func refresh() async throws {
        isUpdatingLocation = true
        currentLocation = try await dependencies.checkinUseCase.requestCurrentLocation()
        isUpdatingLocation = false
    }
    
    func requestAuthorization() async -> Bool {
        return await dependencies.checkinUseCase.requestLocationServicesAuthorization()
    }
    
    func checkIn() async throws {
        guard let currentLocation = currentLocation else { throw CheckinViewModelError.currentLocationNotFound }
        try await dependencies.checkinUseCase.checkIn(at: Location(id: "",
                                                                   latitude: currentLocation.latitudeCoordinate,
                                                                   longitude: currentLocation.longitudeCoordinate,
                                                                   date: Date(),
                                                                   city: currentLocation.cityName,
                                                                   country: currentLocation.countryName,
                                                                   locale: currentLocation.countryLocale))
    }
}
