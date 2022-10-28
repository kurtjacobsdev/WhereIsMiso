//
//  File.swift
//  
//
//  Created by Kurt Jacobs on 2022/10/11.
//

import Foundation

public class CheckinInteractor: CheckinUseCase {
    private var currentLocationWorker: CurrentLocationWorker
    private var locationServicesAuthorizerWorker: LocationServicesAuthorizerWorker
    private var locationWorker: LocationWorker
    private var appleLocationWorker: LocationWorker
    private var userInfoWorker: UserInfoWorker
    
    public init(currentLocationWorker: CurrentLocationWorker,
                locationServicesAuthorizerWorker: LocationServicesAuthorizerWorker,
                locationWorker: LocationWorker,
                appleLocationWorker: LocationWorker,
                userInfoWorker: UserInfoWorker) {
        self.currentLocationWorker = currentLocationWorker
        self.locationServicesAuthorizerWorker = locationServicesAuthorizerWorker
        self.locationWorker = locationWorker
        self.appleLocationWorker = appleLocationWorker
        self.userInfoWorker = userInfoWorker
    }
    
    public func requestLocationServicesAuthorization() async -> Bool {
        return await locationServicesAuthorizerWorker.requestAuthorization()
    }
    
    public func requestCurrentLocation() async throws -> CurrentLocationEntity? {
        return try await currentLocationWorker.get()
    }
    
    public func checkIn(at location: Location) async throws {
        if userInfoWorker.isMiso() && userInfoWorker.isLoggedIn() {
            try await locationWorker.save(location: location)
        } else {
            try await appleLocationWorker.save(location: location)
        }
    }
}
