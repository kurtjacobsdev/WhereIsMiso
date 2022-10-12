//
//  File.swift
//  
//
//  Created by Kurt Jacobs on 2022/10/10.
//

import UIKit
import Combine
import MapKit
import SnapKit
import NVActivityIndicatorView

public protocol MainViewControllerDelegate: AnyObject {
    func mainViewControllerDidAppear()
    func didRequestRefresh()
    func didSelectMiso()
}

class MainViewController: UIViewController {
    private var viewModel: MainViewViewModel
    private var cancelBag: Set<AnyCancellable> = []
    private var mapView: MKMapView!
    private var refreshButton: UIButton = UIButton(frame: .zero)
    private var misoButton: UIButton = UIButton(frame: .zero)
    private var loadingIndicator: NVActivityIndicatorView = NVActivityIndicatorView(frame: .zero)
    weak var delegate: MainViewControllerDelegate?
    
    init(viewModel: MainViewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        configureMapView()
        configureBindings()
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        delegate?.mainViewControllerDidAppear()
        Task { try await viewModel.refresh() }
    }
    
    private func configureMapView() {
        mapView = MKMapView(frame: .zero)
        view.addSubview(mapView)
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(refreshButton)
        view.addSubview(misoButton)
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .heavy, scale: .large)
        refreshButton.setImage(UIImage(systemName: "arrow.counterclockwise", withConfiguration: largeConfig), for: .normal)
        refreshButton.tintColor = .white
        refreshButton.backgroundColor = .systemPurple
        refreshButton.layer.cornerRadius = 25
        refreshButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.width.equalTo(50)
            $0.height.equalTo(50)
        }
        refreshButton.addTarget(self, action: #selector(refresh), for: .touchUpInside)
        
        misoButton.setImage(UIImage(named: "misoButton", in: Bundle.module, compatibleWith: nil), for: .normal)
        misoButton.tintColor = .white
        misoButton.backgroundColor = .systemPurple
        misoButton.layer.cornerRadius = 25
        misoButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.width.equalTo(50)
            $0.height.equalTo(50)
        }
        misoButton.addTarget(self, action: #selector(misoAction), for: .touchUpInside)
        
        view.addSubview(loadingIndicator)
        loadingIndicator.type = .ballScaleRipple
        loadingIndicator.color = .systemPurple
        loadingIndicator.snp.makeConstraints {
            $0.width.equalTo(50)
            $0.height.equalTo(50)
            $0.center.equalToSuperview()
        }
    }
    
    @objc func refresh() {
        delegate?.didRequestRefresh()
        Task { try await viewModel.refresh() }
    }
    
    @objc func misoAction() {
        delegate?.didSelectMiso()
    }
    
    func setPinUsingMKPointAnnotation(location: CLLocationCoordinate2D, title: String, subtitle: String, latest: Bool = false) {
       let annotation = MKPointAnnotation()
       annotation.coordinate = location
       annotation.title = title
       annotation.subtitle = subtitle
        if latest {
            let coordinateRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(coordinateRegion, animated: true)
        }
       mapView.addAnnotation(annotation)
    }
    
    func resetMap() {
        mapView.removeAnnotations(mapView.annotations)
    }
    
    private func configureBindings() {
        viewModel.$pins
            .receive(on: DispatchQueue.main)
            .sink { pins in
                self.resetMap()
                for (idx, pin) in pins.enumerated() {
                    self.setPinUsingMKPointAnnotation(location: pin.coordinates, title: pin.title, subtitle: pin.subtitle, latest: idx == 0)
                }
        }.store(in: &cancelBag)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { isLoading in
            if isLoading {
                self.loadingIndicator.startAnimating()
            } else {
                self.loadingIndicator.stopAnimating()
            }
        }.store(in: &cancelBag)
    }
    
}
