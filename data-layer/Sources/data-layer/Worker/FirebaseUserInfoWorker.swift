//
//  File.swift
//  
//
//  Created by Kurt Jacobs on 2022/10/11.
//

import Foundation
import FirebaseAuth
import domain_layer

public class FirebaseUserInfoWorker: UserInfoWorker {
    private var misoUID = "8PJFgBItzJXdBqjWpzKhhcilFEC2"
    
    public init() {}
    
    public func isLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    public func isMiso() -> Bool {
        Auth.auth().currentUser?.uid == misoUID
    }
}
