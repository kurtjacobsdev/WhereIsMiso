//
//  File.swift
//  
//
//  Created by Kurt Jacobs on 2022/10/12.
//

import Foundation

public class MainViewInteractor: MainViewUseCase {
    private var locationWorker: LocationWorker
    private var appleLocationWorker: LocationWorker
    private var userInfoWorker: UserInfoWorker
    
    public init(locationWorker: LocationWorker, appleLocationWorker: LocationWorker, userInfoWorker: UserInfoWorker) {
        self.locationWorker = locationWorker
        self.appleLocationWorker = appleLocationWorker
        self.userInfoWorker = userInfoWorker
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
}
