//
//  File.swift
//  
//
//  Created by Kurt Jacobs on 2022/10/11.
//

import Foundation

public protocol LoginUseCase {
    func login(email: String, password: String) async throws
    func logout() throws
    func isLoggedIn() -> Bool
    func isMiso() -> Bool
}
