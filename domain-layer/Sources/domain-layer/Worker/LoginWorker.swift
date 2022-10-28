//
//  File.swift
//  
//
//  Created by Kurt Jacobs on 2022/10/11.
//

import Foundation

public protocol LoginWorker {
    func login(email: String, password: String) async throws
    func logout() throws
}
