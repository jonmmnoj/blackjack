//
//  Penetration.swift
//  BlackJackPracticeStrategyGame
//
//  Created by Jon on 11/9/21.
//

import UIKit

class Penetration {
    static var penetrationValues: [Double] {
        return [1.0, 0.95, 0.9, 0.85, 0.8, 0.75, 0.7, 0.65, 0.6, 0.55, 0.5, 0.45, 0.4, 0.35, 0.3, 0.25, 0.2]
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
    
    static var redCard: Card {
        let card = Card(value: .ace, suit: .diamonds)
        card.isPenetrationCard = true
        card.isFaceDown = true
        //card.isDouble = true
        //card.customRotation = true
        //card.rotationDegrees = 90
        return card
    }
}
