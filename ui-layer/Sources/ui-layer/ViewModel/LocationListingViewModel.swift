//
//  File.swift
//  
//
//  Created by Kurt Jacobs on 2022/10/10.
//

import Foundation
import Combine
import domain_layer

public protocol LocationListingViewModelDependencies {
    var locationListingUseCase: LocationListingUseCase { get }
}

class LocationListingViewModel {
    private var dependencies: LocationListingViewModelDependencies
    @Published var locations: [LocationListingCellConfiguration] = []
    @Published var isLoading: Bool = false
    
    init(dependencies: LocationListingViewModelDependencies) {
        self.dependencies = dependencies
    }
    
    func refresh() async throws {
        locations = []
        isLoading = true
        do {
            locations = try await dependencies.locationListingUseCase.getLocations().map { $0.configuration() }
        } catch {
            print(error)
        }
        isLoading = false
    }
    
    func isLoggedIn() -> Bool {
        return dependencies.locationListingUseCase.isLoggedIn()
    }
}
