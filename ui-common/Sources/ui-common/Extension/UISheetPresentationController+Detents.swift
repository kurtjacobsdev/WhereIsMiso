//
//  File.swift
//  
//
//  Created by Kurt Jacobs on 2022/10/12.
//

import UIKit

public enum AppDetents: String {
    case micro = "micro"
    case overlay = "overlay"
}

public extension UISheetPresentationController.Detent.Identifier {
    static var micro: UISheetPresentationController.Detent.Identifier = UISheetPresentationController.Detent.Identifier(AppDetents.micro.rawValue)
    static var overlay: UISheetPresentationController.Detent.Identifier = UISheetPresentationController.Detent.Identifier(AppDetents.overlay.rawValue)
}

public extension UISheetPresentationController.Detent {
    class func micro() -> UISheetPresentationController.Detent {
        return UISheetPresentationController.Detent.custom(identifier: .init(rawValue: AppDetents.micro.rawValue)) { context in
            return 44
        }
    }
    
    class func overlay() -> UISheetPresentationController.Detent {
        return UISheetPresentationController.Detent.custom(identifier: .init(rawValue: AppDetents.overlay.rawValue)) { context in
            return 260
        }
    }
}



