//
//  File.swift
//  
//
//  Created by Kurt Jacobs on 2022/10/10.
//

import UIKit

public enum MainCoordinatorRoute {
    case main
    case checkin
    case login
    case locationListing
}

public protocol MainCoordinatorDependencies: CheckinViewModelDependencies,
                                             LoginViewModelDependencies,
                                             LocationListingViewModelDependencies,
                                             MainViewViewModelDependencies { }

public class MainCoordinator {
    private var dependencies: MainCoordinatorDependencies
    public private (set) var navigationController = UINavigationController()
    private var mainViewController: MainViewController?
    private var locationListingViewController: LocationListingViewController?
    private var locationListingViewModel: LocationListingViewModel?
    private var mainViewViewModel: MainViewViewModel?
    
    public init(dependencies: MainCoordinatorDependencies) {
        self.dependencies = dependencies
    }
    
    public func start() {
        navigate(route: .main)
    }
    
    public func navigate(route: MainCoordinatorRoute) {
        switch route {
        case .main:
            let viewModel = MainViewViewModel(dependencies: dependencies)
            mainViewViewModel = viewModel
            let mainViewController = MainViewController(viewModel: viewModel)
            mainViewController.delegate = self
            self.mainViewController = mainViewController
            navigationController = UINavigationController(rootViewController: mainViewController)
        case .checkin:
            let checkinViewController = CheckinViewController(viewModel: CheckinViewModel(dependencies: dependencies))
            checkinViewController.delegate = self
            let navigationController = UINavigationController(rootViewController: checkinViewController)
            navigationController.modalPresentationStyle = .overFullScreen
            self.locationListingViewController?.present(navigationController, animated: true)
        case .login:
            let loginViewController = LoginViewController(viewModel: LoginViewModel(dependencies: dependencies))
            loginViewController.delegate = self
            let navigationController = UINavigationController(rootViewController: loginViewController)
            navigationController.modalPresentationStyle = .overFullScreen
            self.locationListingViewController?.present(navigationController, animated: true)
        case .locationListing:
            guard let mainViewController = mainViewController else { return }
            let locationListingViewModel = LocationListingViewModel(dependencies: dependencies)
            self.locationListingViewModel = locationListingViewModel
            let locationViewController = LocationListingViewController(viewModel: locationListingViewModel)
            self.locationListingViewController = locationViewController
            locationViewController.delegate = self
            
            let locationNavController = UINavigationController(rootViewController: locationViewController)
            mainViewController.present(locationNavController, animated: false)
        }
    }
}

extension MainCoordinator: MainViewControllerDelegate {
    public func mainViewControllerDidAppear() {
        navigate(route: .locationListing)
    }
    
    public func didRequestRefresh() {
        locationListingViewController?.refreshControls()
        Task {
            try await locationListingViewModel?.refresh()
            try await mainViewViewModel?.refresh()
        }
    }
    
    public func didSelectMiso() {
        guard let _ = self.locationListingViewController else { return }
        navigate(route: .login)
    }
}

extension MainCoordinator: LocationListingViewControllerDelegate {
    public func didSelectSettings() {
        
    }
    
    public func didSelectCheckin() {
        guard let _ = self.locationListingViewController else { return }
        navigate(route: .checkin)
    }
}

extension MainCoordinator: CheckinViewControllerDelegate {
    public func didCompleteCheckin() {
        Task {
            try await locationListingViewModel?.refresh()
            try await mainViewViewModel?.refresh()
        }
    }
}

extension MainCoordinator: LoginViewControllerDelegate {
    public func didCompleteLogin() {
        locationListingViewController?.refreshControls()
        Task {
            try await locationListingViewModel?.refresh()
            try await mainViewViewModel?.refresh()
        }
    }
    
    public func didCompleteLogout() {
        locationListingViewController?.refreshControls()
        Task {
            try await locationListingViewModel?.refresh()
            try await mainViewViewModel?.refresh()
        }
    }
}
