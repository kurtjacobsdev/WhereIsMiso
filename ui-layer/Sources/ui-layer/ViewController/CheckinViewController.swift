//
//  File.swift
//  
//
//  Created by Kurt Jacobs on 2022/10/10.
//

import UIKit
import Combine
import ui_common
import MapKit

public protocol CheckinViewControllerDelegate: AnyObject {
    func didCompleteCheckin()
}

class CheckinViewController: UIViewController {
    weak var delegate: CheckinViewControllerDelegate?
    private var viewModel: CheckinViewModel
    private var checkinDisplayFormatter: CheckinDisplayFormatter
    private var checkinValueFormatter: CheckinValueFormatter
    private var cancelBag: Set<AnyCancellable> = []
    private var locationCard: CheckinLocationCard = CheckinLocationCard()
    private var mapView = MKMapView()
    private var checkinButton = AnimatedButton()
    
    init(viewModel: CheckinViewModel) {
        self.viewModel = viewModel
        self.checkinDisplayFormatter = CheckinDisplayFormatter()
        self.checkinValueFormatter = CheckinValueFormatter()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureConstraints()
        configureProperties()
        configureStyling()
        configureBindings()
        configureNavigationButtons()
        locationCard.startLoading()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            if await !viewModel.requestAuthorization() {
                let alert = UIAlertController(title: "Error Location Services Disabled", message: "Please Provide Location Services Access In Settings", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    self.close()
                }))
                present(alert, animated: true)
            }
            try await viewModel.refresh()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    private func configureNavigationButtons() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", image: nil, target: self, action: #selector(close))
        self.navigationItem.leftBarButtonItem?.tintColor = .systemPurple
    }
    
    private func configureHierarchy() {
        self.view.addSubview(locationCard)
        self.view.addSubview(checkinButton)
        self.view.addSubview(mapView)
    }
    
    private func configureConstraints() {
        locationCard.snp.makeConstraints {
            $0.height.equalTo(100)
            $0.width.equalToSuperview().inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        checkinButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(10)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().inset(10)
            $0.height.equalTo(88)
        }
        
        mapView.snp.makeConstraints {
            $0.height.equalTo(300)
            $0.width.equalTo(300)
            $0.top.equalTo(locationCard.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func configureStyling() {
        mapView.layer.cornerRadius = 20
        view.backgroundColor = AppColor.viewBackground
    }
    
    private func configureProperties() {
        mapView.isScrollEnabled = false
        mapView.isZoomEnabled = false
        checkinButton.addTarget(target: self, action: #selector(checkIn), for: .touchUpInside)
        checkinButton.configure(configuration: AnimatedButtonConfiguration(title: "Check-In", color: AppColor.primary))
    }
    
    private func configureBindings() {
        viewModel.$isCheckingIn.receive(on: DispatchQueue.main).sink { [weak self] isCheckingIn in
            guard let self = self else { return }
            if isCheckingIn {
                self.checkinButton.startAnimating()
            } else {
                self.checkinButton.stopAnimating()
            }
        }.store(in: &cancelBag)
        
        viewModel.$isUpdatingLocation.receive(on: DispatchQueue.main).sink { [weak self] isUpdatingLocation in
            guard let self = self else { return }
            if isUpdatingLocation {
                self.checkinButton.startAnimating()
            } else {
                self.checkinButton.stopAnimating()
            }
        }.store(in: &cancelBag)
        
        viewModel.$currentLocation
            .receive(on: DispatchQueue.main)
            .sink { [weak self] currentLocation in
            guard let self = self else { return }
            guard let currentLocation = currentLocation else { return }
            self.locationCard.stopLoading()
            self.locationCard.configure(CheckinLocationCardConfiguration(
                locationTitle: "\(currentLocation.cityName), \(currentLocation.countryName)",
                coordinates: "\(self.checkinValueFormatter.format(coordinate: currentLocation.latitudeCoordinate)), \(self.checkinValueFormatter.format(coordinate: currentLocation.longitudeCoordinate))",
                date: self.checkinDisplayFormatter.format(date: Date()),
                flag: currentLocation.countryLocale.flag())
            )
                self.mapView.addPin(location: CLLocationCoordinate2D(latitude: currentLocation.latitudeCoordinate, longitude: currentLocation.longitudeCoordinate), title: "Current Location", subtitle: "Check-In Point", zoomTo: true)
        }.store(in: &cancelBag)
    }
    
    @objc func checkIn() {
        checkinButton.startAnimating()
        Task {
            try await viewModel.checkIn()
            delegate?.didCompleteCheckin()
            checkinButton.stopAnimating()
            close()
        }
    }
    
    @objc func close() {
        dismiss(animated: true)
    }
}
