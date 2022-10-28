//
//  File.swift
//  
//
//  Created by Kurt Jacobs on 2022/10/11.
//

import Foundation

public protocol UserInfoWorker {
    func isLoggedIn() -> Bool
    func isMiso() -> Bool
}
