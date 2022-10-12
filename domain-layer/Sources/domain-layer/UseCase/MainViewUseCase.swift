//
//  File.swift
//  
//
//  Created by Kurt Jacobs on 2022/10/12.
//

import Foundation

public protocol MainViewUseCase {
    func getLocations() async throws -> [Location]
}
