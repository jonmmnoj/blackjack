//
//  Insurance.swift
//  BlackJackPracticeStrategyGame
//
//  Created by Jon on 10/27/21.
//

import UIKit

class Insurance {
    //static let trueCount = 3
    
    static func askInsurance(player: Player, delegate: GameViewDelegate, dealerHasBlackjack: Bool, completion: @escaping (Bool, String, Double) -> Void) {//-> UIAlertController {
        let alert = UIAlertController(title: "Insurance", message: "Insure hand?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            let correctAnswer = playerShouldInsureHand() ? "Yes" : "No"
            Stats.shared.update(decision: Decision(type: .insurance, isCorrect: correctAnswer == "Yes", yourAnswer: "Yes", correctAnswer: correctAnswer, decisionBasedOn: "@ TC \(CardCounter.shared.getTrueCount())"))
            if !playerShouldInsureHand() && Settings.shared.notifyMistakes {
                notifyInsuranceMistake(player: player, delegate: delegate, dealerHasBlackjack: dealerHasBlackjack, completion: completion)
            } else {
                playerWantsToInsure(player, dealerHasBlackjack: dealerHasBlackjack, completion: completion)
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { _ in
            let correctAnswer = playerShouldInsureHand() ? "Yes" : "No"
            Stats.shared.update(decision: Decision(type: .insurance, isCorrect: correctAnswer == "No", yourAnswer: "No", correctAnswer: correctAnswer, decisionBasedOn: "@ TC \(CardCounter.shared.getTrueCount())"))
            if playerShouldInsureHand() && Settings.shared.notifyMistakes {
                notifyInsuranceMistake(player: player, delegate: delegate, dealerHasBlackjack: dealerHasBlackjack, completion: completion)
            } else {
                completion(false, "", 0)
            }
        }))
        delegate.present(alert)
    }
    
    static func notifyInsuranceMistake(player: Player, delegate: GameViewDelegate, dealerHasBlackjack: Bool, completion: @escaping (Bool, String, Double) -> Void) {
        PlayError.notifyMistake(delegate, message: "You should insure at true count \(insureOnThisTrueCount())+", completion: { fix in
            if fix {
                askInsurance(player: player, delegate: delegate, dealerHasBlackjack: dealerHasBlackjack, completion: completion)
            } else {
                playerWantsToInsure(player, dealerHasBlackjack: dealerHasBlackjack, completion: completion)
            }
        })
    }
    
    static func playerWantsToInsure(_ player: Player, dealerHasBlackjack: Bool, completion: @escaping (Bool, String, Double) -> Void) {
        betInsurance(for: player)
        var message = ""
        var amount: Double = 0
        if dealerHasBlackjack {
            message += "Won Insurance +$"
            payoutInsurance(for: player)
            amount = Double(player.hands.first!.betAmount) * 0.5 * 2
            if player.dealt2Hands {
                amount += amount
            }
        } else {
            message += "Lost Insurance -$"
            amount = Double(player.hands.first!.betAmount) * 0.5
            if player.dealt2Hands {
                amount += amount
            }
        }
        completion(true, message, amount)
    }
    
    static func betInsurance(for player: Player) {
        var insuredAmount = Double(player.hands.first!.betAmount) * 0.5
        if player.dealt2Hands {
            insuredAmount += insuredAmount
        }
        Bankroll.shared.add(-insuredAmount)
    }
    
    static private func payoutInsurance(for player: Player) {
        var amount = Double(player.hands.first!.betAmount) * 0.5 * 3
        if player.dealt2Hands { amount += amount }
        Bankroll.shared.add(amount)
        
    }
    
    static func playerShouldInsureHand() -> Bool {
        return CardCounter.shared.getTrueCount() >= insureOnThisTrueCount()
    }
    
    static func showToastForInsureBet(_ delegate: GameViewDelegate, message: String, amount: Double) {
        var message = message
        message += Rules.hasRemainder(amount) ? String(format: "%.2f", amount) : "\(Int(amount))"
        delegate.showToast(message: message)
    }
    
    static func insureOnThisTrueCount() -> Int {
        switch Settings.shared.numberOfDecks {
        case 1: return 1
        case 2: return 2
        case 4, 6, 8: return 3
        default: return -999
        }
        
    }
}
