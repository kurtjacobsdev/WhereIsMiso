//
//  File.swift
//  
//
//  Created by Kurt Jacobs on 2022/10/10.
//

import UIKit
import Combine
import ui_common
import NVActivityIndicatorView

protocol LocationListingViewControllerDelegate: AnyObject {
    func didSelectCheckin()
}

class LocationListingViewController: UIViewController {
    private var viewModel: LocationListingViewModel
    private var collectionView: UICollectionView!
    weak var delegate: LocationListingViewControllerDelegate?
    private var loadingIndicator: NVActivityIndicatorView = NVActivityIndicatorView(frame: .zero)
    private var cancelBag: Set<AnyCancellable> = []
    private var locations: [LocationListingCellConfiguration] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    init(viewModel: LocationListingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        configureBindings()
        self.view.backgroundColor = .white
        self.title = "Locations"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureSheetContext()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureBarButtons()
        Task { try await viewModel.refresh() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func checkin() {
        delegate?.didSelectCheckin()
    }
    
    private func configureBindings() {
        viewModel.$locations
            .receive(on: DispatchQueue.main)
            .sink { locations in
                self.locations = locations
                self.collectionView.reloadData()
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
    
    private func configureBarButtons() {
        let checkinButton = UIBarButtonItem(image: UIImage(systemName: "mappin.and.ellipse"), style: .done, target: self, action: #selector(checkin))
        checkinButton.tintColor = .systemPurple
        self.navigationItem.leftBarButtonItem = checkinButton
        self.navigationItem.leftBarButtonItem?.isHidden = !viewModel.isLoggedIn()
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { index, env in
            let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100))
            let item = NSCollectionLayoutItem(layoutSize: size)
            item.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 20, leading: 5, bottom: 5, trailing: 5)
            return section
        }))
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        collectionView.register(LocationListingCell.self, forCellWithReuseIdentifier: LocationListingCell.identifier)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.identifier)
        collectionView.dataSource = self
        
        loadingIndicator.type = .ballBeat
        loadingIndicator.color = .systemPurple
        view.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.width.equalTo(50)
            $0.height.equalTo(50)
            $0.centerX.equalToSuperview()
        })
    }
    
    func refreshControls() {
        self.navigationItem.leftBarButtonItem?.isHidden = !viewModel.isLoggedIn()
    }
    
    func configureSheetContext() {
        if let sheet = self.navigationController?.sheetPresentationController {
            sheet.detents = [.micro(), .overlay(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 15
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.largestUndimmedDetentIdentifier = .overlay
            sheet.selectedDetentIdentifier = .overlay
        }
        
        self.navigationController?.modalPresentationStyle = .pageSheet
        self.navigationController?.isModalInPresentation = true
    }
}

extension LocationListingViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locations.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell: LocationListingCell = collectionView.dequeueReusableCell(withReuseIdentifier: LocationListingCell.identifier, for: indexPath) as! LocationListingCell
            cell.configure(locations[indexPath.row])
            return cell
        default:
            return collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.identifier, for: indexPath)
        }
    }
}
