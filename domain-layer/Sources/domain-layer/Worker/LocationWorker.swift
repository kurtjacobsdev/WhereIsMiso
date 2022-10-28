//
//  File.swift
//  
//
//  Created by Kurt Jacobs on 2022/10/11.
//

import Foundation

public protocol LocationWorker {
    func get() async throws -> [Location]
    func save(location: Location) async throws
}
