//
//  File.swift
//  
//
//  Created by Kurt Jacobs on 2022/10/11.
//

import Foundation

public extension String {
    func flag() -> String {
        let base = 127397
        var flag: String = ""
        flag.unicodeScalars.append(contentsOf: self.utf16.compactMap { UnicodeScalar(Int($0) + base) })
        return flag
    }
}
