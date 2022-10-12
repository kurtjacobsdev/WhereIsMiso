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
        configureBindings()
        self.view.backgroundColor = .systemBackground
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", image: nil, target: self, action: #selector(close))
        self.navigationItem.leftBarButtonItem?.tintColor = .systemPurple
        
        self.view.addSubview(locationCard)
        self.view.addSubview(checkinButton)
        self.view.addSubview(mapView)
        
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
        
        locationCard.startLoading()
        checkinButton.addTarget(target: self, action: #selector(checkIn), for: .touchUpInside)
        checkinButton.configure(configuration: AnimatedButtonConfiguration(title: "Check-In", color: .systemPurple))
        mapView.layer.cornerRadius = 20
        mapView.isScrollEnabled = false
        mapView.isZoomEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            if await !viewModel.requestAuthorization() {
                let alert = UIAlertController(title: "Error Location Services Disabled", message: "Please Provide Location Services Access In Settings", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    self.close()
                }))
                self.present(alert, animated: true)
            }
            try await viewModel.refresh()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
    
    private func configureBindings() {
        viewModel.$isCheckingIn.receive(on: DispatchQueue.main).sink { isCheckingIn in
            if isCheckingIn {
                
            } else {
                
            }
        }.store(in: &cancelBag)
        
        viewModel.$isUpdatingLocation.receive(on: DispatchQueue.main).sink { isUpdatingLocation in
            if isUpdatingLocation {
                self.checkinButton.startAnimating()
            } else {
                self.checkinButton.stopAnimating()
            }
        }.store(in: &cancelBag)
        
        viewModel.$currentLocation
            .receive(on: DispatchQueue.main)
            .sink { currentLocation in
            guard let currentLocation = currentLocation else { return }
            self.locationCard.stopLoading()
            self.locationCard.configure(CheckinLocationCardConfiguration(
                locationTitle: "\(currentLocation.cityName), \(currentLocation.countryName)",
                coordinates: "\(self.checkinValueFormatter.format(coordinate: currentLocation.latitudeCoordinate)), \(self.checkinValueFormatter.format(coordinate: currentLocation.longitudeCoordinate))",
                date: self.checkinDisplayFormatter.format(date: Date()),
                flag: currentLocation.countryLocale.flag())
            )
            self.setPinUsingMKPointAnnotation(location: CLLocationCoordinate2D(latitude: currentLocation.latitudeCoordinate, longitude: currentLocation.longitudeCoordinate))
        }.store(in: &cancelBag)
    }
    
    private func setPinUsingMKPointAnnotation(location: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Current Location"
        annotation.subtitle = "Check-In Point"
        let coordinateRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.addAnnotation(annotation)
    }
    
    @objc func close() {
        self.dismiss(animated: true)
    }
}
