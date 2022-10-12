//
//  File.swift
//  
//
//  Created by Kurt Jacobs on 2022/10/10.
//

import UIKit
import SnapKit

public struct FlagLabelViewConfiguration {
    var flag: String
    var color: UIColor
    
    public init(flag: String, color: UIColor) {
        self.flag = flag
        self.color = color
    }
}

public class FlagLabelView: UIView {
    private var flagLabel = UILabel()
    
    public init() {
        super.init(frame: .zero)
        configureHierarchy()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        self.addSubview(flagLabel)
    }
    
    private func configureConstraints() {
        flagLabel.snp.makeConstraints { 
            $0.center.equalToSuperview()
        }
    }
    
    public func configure(_ configuration: FlagLabelViewConfiguration) {
        flagLabel.text = configuration.flag
        backgroundColor = configuration.color
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()

        self.layer.cornerRadius = self.bounds.width / 2
        self.layer.masksToBounds = true
    }
}
