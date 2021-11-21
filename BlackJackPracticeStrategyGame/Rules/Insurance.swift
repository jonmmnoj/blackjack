//
//  Insurance.swift
//  BlackJackPracticeStrategyGame
//
//  Created by Jon on 10/27/21.
//

import UIKit

class Insurance {
    static let trueCount = 3
    
    static func askInsurance(_ delegate: GameViewDelegate, hand: Hand, dealerHasBlackjack: Bool, completion: @escaping (Bool, String, Double) -> Void) {//-> UIAlertController {
        let alert = UIAlertController(title: "Insurance", message: "Insure hand?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            if !playerShouldInsureHand() {
                notifyInsuranceMistake(delegate, hand: hand, dealerHasBlackjack: dealerHasBlackjack, completion: completion)
            } else {
                playerWantsToInsure(hand, dealerHasBlackjack: dealerHasBlackjack, completion: completion)
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { _ in
            
            if playerShouldInsureHand() {
                notifyInsuranceMistake(delegate, hand: hand, dealerHasBlackjack: dealerHasBlackjack, completion: completion)
            } else {
                completion(false, "", 0)
            }
        }))
        delegate.present(alert)
    }
    
    static func notifyInsuranceMistake(_ delegate: GameViewDelegate, hand: Hand, dealerHasBlackjack: Bool, completion: @escaping (Bool, String, Double) -> Void) {
        PlayError.notifyMistake(delegate, message: "You should insure at true count \(CardCounter.shared.getTrueCount())+", completion: { fix in
            if fix {
                askInsurance(delegate, hand: hand, dealerHasBlackjack: dealerHasBlackjack, completion: completion)
            } else {
                playerWantsToInsure(hand, dealerHasBlackjack: dealerHasBlackjack, completion: completion)
            }
        })
    }
    
    static func playerWantsToInsure(_ hand: Hand, dealerHasBlackjack: Bool, completion: @escaping (Bool, String, Double) -> Void) {
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
        completion(true, message, amount)
    }
    
    static func betInsurance(for hand: Hand) {
        let insuredAmount = Double(hand.betAmount) * 0.5
        Bankroll.shared.add(-insuredAmount)
    }
    
    static private func payoutInsurance(for hand: Hand) {
        Bankroll.shared.add(Double(hand.betAmount) * 0.5 * 3)
    }
    
    static func playerShouldInsureHand() -> Bool {
        let trueCount = CardCounter.shared.getTrueCount()
        var insureOnTrueCount = -999
        switch Settings.shared.numberOfDecks {
        case 1: insureOnTrueCount = 1
        case 2: insureOnTrueCount = 2
        case 4, 6, 8: insureOnTrueCount = 3
        default: break
        }
        return trueCount >= insureOnTrueCount
    }
    
    static func showToastForInsureBet(_ delegate: GameViewDelegate, message: String, amount: Double) {
        var message = message
        message += Rules.hasRemainder(amount) ? String(format: "%.2f", amount) : "\(Int(amount))"
        delegate.showToast(message: message)
    }
}
