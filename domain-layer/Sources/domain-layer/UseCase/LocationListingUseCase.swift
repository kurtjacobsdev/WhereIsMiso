//
//  File.swift
//  
//
//  Created by Kurt Jacobs on 2022/10/11.
//

import Foundation

public protocol LocationListingUseCase {
    func getLocations() async throws -> [Location]
    func isLoggedIn() -> Bool
}
