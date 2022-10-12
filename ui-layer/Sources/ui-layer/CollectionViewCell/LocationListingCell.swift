//
//  File.swift
//  
//
//  Created by Kurt Jacobs on 2022/10/10.
//

import UIKit
import ui_common

public class LocationListingCell: UICollectionViewCell {
    private var countryName: UILabel = UILabel()
    private var coordinates: UILabel = UILabel()
    private var date: UILabel = UILabel()
    private var contentStack: UIStackView = UIStackView()
    private var flagView = FlagLabelView()
    private let circleSize = 50.0
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        configureStyling()
        configureProperties()
        configureHierarchy()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ configuration: LocationListingCellConfiguration) {
        self.flagView.configure(FlagLabelViewConfiguration(flag: configuration.locale.flag(), color: AppColor.primary.withAlphaComponent(0.4)))
        self.coordinates.text = configuration.coordinates
        self.date.text = configuration.date
        self.countryName.text = configuration.countryWithCity
    }
    
    private func configureStyling() {
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = AppColor.primary.withAlphaComponent(0.8)
        countryName.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        date.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        coordinates.font = UIFont.systemFont(ofSize: 14, weight: .light)
    }
    
    private func configureProperties() {
        contentStack.distribution = .fillEqually
        contentStack.axis = .vertical
        contentStack.alignment = .leading
    }
    
    private func configureHierarchy() {
        contentStack.addArrangedSubview(countryName)
        contentStack.addArrangedSubview(date)
        contentStack.addArrangedSubview(coordinates)
        contentStack.addArrangedSubview(UIView())
        contentView.addSubview(contentStack)
        contentView.addSubview(flagView)
    }
    
    private func configureConstraints() {
        flagView.snp.makeConstraints {
            $0.width.equalTo(circleSize)
            $0.height.equalTo(circleSize)
            $0.left.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        contentStack.snp.makeConstraints {
            $0.left.equalTo(flagView.snp.right).offset(20)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(10)
            $0.right.equalToSuperview()
        }
    }
}
