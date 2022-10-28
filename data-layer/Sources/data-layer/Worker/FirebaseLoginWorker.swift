//
//  File.swift
//  
//
//  Created by Kurt Jacobs on 2022/10/11.
//

import Foundation
import domain_layer
import FirebaseAuth
import FirebaseCore

public class FirebaseLoginWorker: LoginWorker {
    public init() {}
    
    public func login(email: String, password: String) async throws {
         _ = try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    public func logout() throws {
        try Auth.auth().signOut()
    }
}
