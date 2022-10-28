//
//  File.swift
//  
//
//  Created by Kurt Jacobs on 2022/10/11.
//

import Foundation

class CheckinDisplayFormatter {
    private var dateFormatter: DateFormatter = DateFormatter()
    
    init() {
        configureDateFormatter()
    }
    
    private func configureDateFormatter() {
        dateFormatter.dateFormat = "dd MMMM yyyy"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
    }
    
    func format(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
}
