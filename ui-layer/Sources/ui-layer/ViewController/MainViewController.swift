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
    private var mapView: MKMapView = MKMapView(frame: .zero)
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
        configureHierarchy()
        configureConstraints()
        configureProperties()
        configureStyling()
        configureBindings()
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        delegate?.mainViewControllerDidAppear()
        Task { try await viewModel.refresh() }
    }
    
    private func configureHierarchy() {
        view.addSubview(mapView)
        view.addSubview(refreshButton)
        view.addSubview(misoButton)
        view.addSubview(loadingIndicator)
    }
    
    private func configureConstraints() {
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        refreshButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.width.equalTo(50)
            $0.height.equalTo(50)
        }
        
        misoButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.width.equalTo(50)
            $0.height.equalTo(50)
        }
        
        loadingIndicator.snp.makeConstraints {
            $0.width.equalTo(50)
            $0.height.equalTo(50)
            $0.center.equalToSuperview()
        }
    }
    
    private func configureStyling() {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .heavy, scale: .large)
        refreshButton.setImage(UIImage(systemName: "arrow.counterclockwise", withConfiguration: largeConfig), for: .normal)
        refreshButton.tintColor = .white
        refreshButton.backgroundColor = .systemPurple
        refreshButton.layer.cornerRadius = 25
        
        misoButton.setImage(UIImage(named: "misoButton", in: Bundle.module, compatibleWith: nil), for: .normal)
        misoButton.tintColor = .white
        misoButton.backgroundColor = .systemPurple
        misoButton.layer.cornerRadius = 25
        
        loadingIndicator.type = .ballScaleRipple
        loadingIndicator.color = .systemPurple
    }
    
    private func configureProperties() {
        refreshButton.addTarget(self, action: #selector(refresh), for: .touchUpInside)
        misoButton.addTarget(self, action: #selector(misoAction), for: .touchUpInside)
    }
    
    @objc func refresh() {
        delegate?.didRequestRefresh()
        Task { try await viewModel.refresh() }
    }
    
    @objc func misoAction() {
        delegate?.didSelectMiso()
    }
    
    func resetMap() {
        mapView.removeAnnotations(mapView.annotations)
    }
    
    private func configureBindings() {
        viewModel.$pins
            .receive(on: DispatchQueue.main)
            .sink { [weak self] pins in
                guard let self = self else { return }
                self.resetMap()
                for (idx, pin) in pins.enumerated() {
                    self.mapView.addPin(location: pin.coordinates, title: pin.title, subtitle: pin.subtitle, zoomTo: idx == 0)
                }
        }.store(in: &cancelBag)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
            guard let self = self else { return }
            if isLoading {
                self.loadingIndicator.startAnimating()
            } else {
                self.loadingIndicator.stopAnimating()
            }
        }.store(in: &cancelBag)
    }
    
}
