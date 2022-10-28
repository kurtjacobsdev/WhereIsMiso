//
//  File.swift
//  
//
//  Created by Kurt Jacobs on 2022/10/12.
//

import Foundation
import domain_layer

public class InMemoryLocationWorker: LocationWorker {
    private var locations: [Location] = []
    
    public init() { }
    
    public func get() async throws -> [Location] {
        locations = readFromDisk()
        return locations
    }
    
    public func save(location: Location) async throws {
        locations.append(location)
        writeToDisk()
    }
    
    private func writeToDisk() {
        let data = try? JSONEncoder().encode(locations)
        UserDefaults.standard.set(data, forKey: "locations")
    }
    
    private func readFromDisk() -> [Location] {
        guard let data = UserDefaults.standard.data(forKey: "locations"),
              let locations = try? JSONDecoder().decode([Location].self, from: data) else { return [] }
        return locations
    }
}
