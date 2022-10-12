//
//  File.swift
//  
//
//  Created by Kurt Jacobs on 2022/10/10.
//

import UIKit

public extension UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
