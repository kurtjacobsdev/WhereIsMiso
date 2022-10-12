//
//  AppDependencies.swift
//  WhereIsMiso
//
//  Created by Kurt Jacobs on 2022/10/12.
//

import Foundation
import domain_layer
import data_layer
import ui_layer

public class AppDependencies: MainCoordinatorDependencies {
    // Repositories
    public var firebaseFirestoreRepository: FirebaseFirestoreRepository = FirebaseFirestoreRepository()
    
    // Workers
    public var currentLocationWorker: CurrentLocationWorker = CoreLocationCurrentLocationWorker()
    public var locationServicesAuthorizerWorker: LocationServicesAuthorizerWorker = CoreLocationLocationServicesAuthorizerWorker()
    public var loginWorker: LoginWorker = FirebaseLoginWorker()
    public var userInfoWorker: UserInfoWorker = FirebaseUserInfoWorker()
    public lazy var locationWorker: LocationWorker = FirebaseLocationWorker(repository: firebaseFirestoreRepository)
    public lazy var appleLocationWorker: LocationWorker = InMemoryLocationWorker()
    
    // Use Cases
    public lazy var checkinUseCase: CheckinUseCase = CheckinInteractor(currentLocationWorker: currentLocationWorker,
                                                                       locationServicesAuthorizerWorker: locationServicesAuthorizerWorker,
                                                                       locationWorker: locationWorker,
                                                                       appleLocationWorker: appleLocationWorker, userInfoWorker: userInfoWorker)
    public lazy var loginUseCase: LoginUseCase = LoginInteractor(loginWorker: loginWorker, userInfoWorker: userInfoWorker)
    public lazy var locationListingUseCase: LocationListingUseCase = LocationListingInteractor(locationWorker: locationWorker,
                                                                                               userInfoWorker: userInfoWorker,
                                                                                               appleLocationWorker: appleLocationWorker)
    public lazy var mainViewUseCase: MainViewUseCase = MainViewInteractor(locationWorker: locationWorker,
                                                                          appleLocationWorker: appleLocationWorker,
                                                                          userInfoWorker: userInfoWorker)
    
    public init() {
        
    }
}
