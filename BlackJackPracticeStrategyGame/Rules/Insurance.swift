//
//  Insurance.swift
//  BlackJackPracticeStrategyGame
//
//  Created by Jon on 10/27/21.
//

import Foundation
import UIKit

class Insurance {
    static let trueCount = 3
    
    static func askInsurance(for hand: Hand, dealerHasBlackjack: Bool, completion: @escaping (String, Double) -> Void) -> UIAlertController {
        let alert = UIAlertController(title: "Insurance", message: "Do you want insurance?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            betInsurance(for: hand)
            var message = ""
            var amount: Double = 0
            if dealerHasBlackjack {
                message += "Won Insurance +$"
                payoutInsurance(for: hand)
                amount = Double(hand.betAmount) * 0.5 * 3
            } else {
                message += "Lost Insurance -$"
                amount = Double(hand.betAmount) * 0.5
            }
            completion(message, amount)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { _ in
            completion("", 0)
        }))
        return alert
    }
    
    static func betInsurance(for hand: Hand) {
        let insuredAmount = Double(hand.betAmount) * 0.5
        Settings.shared.bankRollAmount -= insuredAmount
    }
    
    static private func payoutInsurance(for hand: Hand) {
        Settings.shared.bankRollAmount += Double(hand.betAmount) * 0.5 * 3
    }
}
