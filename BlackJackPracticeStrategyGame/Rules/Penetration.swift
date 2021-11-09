//
//  Penetration.swift
//  BlackJackPracticeStrategyGame
//
//  Created by Jon on 11/9/21.
//

import Foundation


class Penetration {
    static var penetrationValues: [Double] {
        return [1.0, 0.9, 0.85, 0.8, 0.75, 0.7, 0.6, 0.5, 0.4, 0.3, 0.25, 0.2, 0.1]
    }
    
    static func getStringValue(for factor: Double) -> String {
        let value = Int(factor * 100)
        return "\(value)%"
    }
    
    static func convertToDouble(string: String) -> Double {
        var s = string
        s.removeLast()
        let value = Double(s)! / 100
        return value
    }
}
