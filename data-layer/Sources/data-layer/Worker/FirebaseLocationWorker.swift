//
//  File.swift
//  
//
//  Created by Kurt Jacobs on 2022/10/11.
//

import Foundation
import domain_layer

public class FirebaseLocationWorker: LocationWorker {
    private var repository: DataRepository
    
    public init(repository: DataRepository) {
        self.repository = repository
    }
    
    public func get() async throws -> [Location] {
        let locations: [LocationDTO] = try await repository.getDocuments(collection: .location)
        return locations.map { $0.entity() }
    }
    
    public func save(location: Location) async throws {
        try await repository.updateDocument(collection: .location, document: location.dto())
    }
    
    public func delete(location: Location) async throws {
        try await repository.deleteDocument(collection: .location, document: location.dto())
    }
}
