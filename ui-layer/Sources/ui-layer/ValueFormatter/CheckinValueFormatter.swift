//
//  File.swift
//  
//
//  Created by Kurt Jacobs on 2022/10/11.
//

import Foundation

public class CheckinValueFormatter {
    private var coordinatesFormatter: NumberFormatter = NumberFormatter()
    
    init() {
        configureNumberFormatter()
    }
    
    private func configureNumberFormatter() {
        coordinatesFormatter.numberStyle = .decimal
        coordinatesFormatter.maximumFractionDigits = 2
        coordinatesFormatter.minimumFractionDigits = 2
    }
    
    func format(coordinate: Double) -> String {
        coordinatesFormatter.string(from: NSNumber(value: coordinate)) ?? ""
    }
}
