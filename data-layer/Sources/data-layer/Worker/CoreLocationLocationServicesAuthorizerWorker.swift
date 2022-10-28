//
//  File.swift
//  
//
//  Created by Kurt Jacobs on 2022/10/11.
//

import Foundation
import domain_layer
import AsyncLocationKit
import Combine

public class CoreLocationLocationServicesAuthorizerWorker: NSObject, LocationServicesAuthorizerWorker {
    private var locationManager = AsyncLocationManager(desiredAccuracy: .bestAccuracy)
    
    public override init() { }
    
    public func requestAuthorization() async -> Bool {
        let status = await locationManager.requestAuthorizationWhenInUse()
        return status == .authorizedWhenInUse
    }
}
