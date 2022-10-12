//
//  File.swift
//  
//
//  Created by Kurt Jacobs on 2022/10/11.
//

import Foundation

public class LocationListingInteractor: LocationListingUseCase {
    private var locationWorker: LocationWorker
    private var appleLocationWorker: LocationWorker
    private var userInfoWorker: UserInfoWorker
    
    public init(locationWorker: LocationWorker, userInfoWorker: UserInfoWorker, appleLocationWorker: LocationWorker) {
        self.locationWorker = locationWorker
        self.userInfoWorker = userInfoWorker
        self.appleLocationWorker = appleLocationWorker
    }
    
    public func getLocations() async throws -> [Location] {
        if userInfoWorker.isMiso() || !userInfoWorker.isLoggedIn() {
            return try await locationWorker.get().sorted(by: { $0.date > $1.date })
        } else {
            let miso = try await locationWorker.get().sorted(by: { $0.date > $1.date })
            let apple = try await appleLocationWorker.get().sorted(by: { $0.date > $1.date })
            return apple + miso
        }
    }
    
    public func isLoggedIn() -> Bool {
        return userInfoWorker.isLoggedIn()
    }
}
