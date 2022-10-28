//
//  File.swift
//  
//
//  Created by Kurt Jacobs on 2022/10/11.
//

import Foundation

public protocol CurrentLocationWorker {
    func get() async throws -> CurrentLocationEntity?
}
