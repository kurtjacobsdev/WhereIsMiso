//
//  File.swift
//  
//
//  Created by Kurt Jacobs on 2022/10/11.
//

import Foundation

public class LoginInteractor: LoginUseCase {
    private var loginWorker: LoginWorker
    private var userInfoWorker: UserInfoWorker
    
    public init(loginWorker: LoginWorker, userInfoWorker: UserInfoWorker) {
        self.loginWorker = loginWorker
        self.userInfoWorker = userInfoWorker
    }
    
    public func login(email: String, password: String) async throws {
        try await loginWorker.login(email: email, password: password)
    }
    
    public func logout() throws {
        try loginWorker.logout()
    }
    
    public func isLoggedIn() -> Bool {
        return userInfoWorker.isLoggedIn()
    }
    
    public func isMiso() -> Bool {
        return userInfoWorker.isMiso()
    }
}
