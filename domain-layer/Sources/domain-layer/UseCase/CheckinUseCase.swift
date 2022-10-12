//
//  File.swift
//  
//
//  Created by Kurt Jacobs on 2022/10/11.
//

import Foundation

public protocol CheckinUseCase {
    func requestLocationServicesAuthorization() async -> Bool
    func requestCurrentLocation() async throws -> CurrentLocationEntity?
    func checkIn(at location: Location) async throws
}
