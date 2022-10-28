//
//  File.swift
//  
//
//  Created by Kurt Jacobs on 2022/10/10.
//

import UIKit
import ui_common
import NVActivityIndicatorView

struct CheckinLocationCardConfiguration {
    let locationTitle: String
    let coordinates: String
    let date: String
    let flag: String
}

public class CheckinLocationCard: UIView {
    private var locationTitleLabel = UILabel()
    private var coordinatesLabel = UILabel()
    private var dateLabel = UILabel()
    private var locationFlag = FlagLabelView()
    private var contentStack = UIStackView()
    private var loadingIndicator = NVActivityIndicatorView(frame: .zero)
    
    public init() {
        super.init(frame: .zero)
        configureHierarchy()
        configureConstraints()
        configureStyling()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ configuration: CheckinLocationCardConfiguration) {
        locationTitleLabel.text = configuration.locationTitle
        coordinatesLabel.text = configuration.coordinates
        dateLabel.text = configuration.date
        locationFlag.configure(FlagLabelViewConfiguration(flag: configuration.flag,
                                                          color: .systemPurple.withAlphaComponent(0.4)))
    }
    
    private func configureHierarchy() {
        contentStack.addArrangedSubview(UIView())
        contentStack.addArrangedSubview(dateLabel)
        contentStack.addArrangedSubview(locationTitleLabel)
        contentStack.addArrangedSubview(coordinatesLabel)
        contentStack.addArrangedSubview(UIView())
        addSubview(contentStack)
        addSubview(locationFlag)
        addSubview(loadingIndicator)
    }
    
    private func configureConstraints() {
        locationFlag.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.width.equalTo(50)
            $0.height.equalTo(50)
        }
        
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(50)
            $0.height.equalTo(50)
        }
        
        contentStack.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(locationFlag.snp.right).offset(10)
            $0.right.equalToSuperview().inset(10)
        }
    }
    
    func startLoading() {
        locationTitleLabel.isHidden = true
        coordinatesLabel.isHidden = true
        dateLabel.isHidden = true
        locationFlag.isHidden = true
        loadingIndicator.startAnimating()
    }
    
    func stopLoading() {
        loadingIndicator.stopAnimating()
        locationTitleLabel.isHidden = false
        coordinatesLabel.isHidden = false
        dateLabel.isHidden = false
        locationFlag.isHidden = false
    }
    
    private func configureStyling() {
        dateLabel.font = .systemFont(ofSize: 20, weight: .bold)
        locationTitleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        coordinatesLabel.font = .systemFont(ofSize: 14, weight: .light)
        self.layer.cornerRadius = 20
        self.backgroundColor = .systemPurple.withAlphaComponent(0.8)
        contentStack.alignment = .leading
        contentStack.axis = .vertical
        contentStack.distribution = .fill
    }
}
