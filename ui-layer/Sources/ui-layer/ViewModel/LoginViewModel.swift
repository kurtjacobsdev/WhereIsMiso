//
//  File.swift
//  
//
//  Created by Kurt Jacobs on 2022/10/11.
//

import Foundation
import domain_layer

public protocol LoginViewModelDependencies {
    var loginUseCase: LoginUseCase { get }
}

class LoginViewModel {
    private var dependencies: LoginViewModelDependencies
    @Published var isLoggingIn: Bool = false
    
    init(dependencies: LoginViewModelDependencies) {
        self.dependencies = dependencies
    }
    
    func login(email: String, password: String) async throws {
        isLoggingIn = true
        try await dependencies.loginUseCase.login(email: email, password: password)
        isLoggingIn = false
    }
    
    func logout() throws {
        try dependencies.loginUseCase.logout()
    }
    
    func isLoggedIn() -> Bool {
        return dependencies.loginUseCase.isLoggedIn()
    }
    
    func isMiso() -> Bool {
        return dependencies.loginUseCase.isMiso()
    }
}
