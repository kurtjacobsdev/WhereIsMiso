//
//  File.swift
//  
//
//  Created by Kurt Jacobs on 2022/10/10.
//

import Foundation
import Combine
import domain_layer

public protocol MainViewViewModelDependencies {
    var mainViewUseCase: MainViewUseCase { get }
}

class MainViewViewModel {
    private var dependencies: MainViewViewModelDependencies
    @Published var pins: [MainViewMapPinContentConfiguration] = []
    @Published var isLoading: Bool = false
    
    init(dependencies: MainViewViewModelDependencies) {
        self.dependencies = dependencies
    }
    
    func refresh() async throws {
        isLoading = true
        pins = try await dependencies.mainViewUseCase.getLocations().map { $0.configuration() }
        isLoading = false
    }
}
