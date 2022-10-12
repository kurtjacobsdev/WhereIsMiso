//
//  File.swift
//  
//
//  Created by Kurt Jacobs on 2022/10/11.
//

import Foundation
import Combine

public protocol LocationServicesAuthorizerWorker {
    func requestAuthorization() async -> Bool
}
