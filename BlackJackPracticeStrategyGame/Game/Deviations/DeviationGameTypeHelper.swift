//
//  DeviationGameTypeHelper.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 8/2/21.
//

import Foundation
import UIKit

class DeviationGameTypeHelper: GameTypeStrategyPatternProtocol {

    var gameMaster: GameMaster
    var decks: [StrategyDeck]
    var deviation: Deviation!
    
    init(gameMaster: GameMaster) {
        self.gameMaster = gameMaster
        self.decks = StrategyGameDeck.getDecks() // need decks for devation hands only
        for deck in decks {
            deck.shuffle()
        }
    }
    
    func dealCards() {
        let deck = decks.randomElement()!
        let result = deck.nextRoundThatIsDeviation()//nextRound()
        let round = result.0
        self.deviation = result.1
        let pCards = round.playerCards
        let dCards = round.dealerCards
        for card in pCards {
            let card = Card(value: CardValue(rawValue: card)!, suit: CardSuit.allCases.randomElement()!)
            dealer.deal(card: card, to: player.activatedHand!, delay: false)
        }
        var card = Card(value: CardValue(rawValue: dCards[0])!, suit: CardSuit.allCases.randomElement()!)
        card.isFaceDown = true
        dealer.deal(card:card ,to: dealer.activatedHand!, delay: false)
        card = Card(value: CardValue(rawValue: dCards[0])!, suit: CardSuit.allCases.randomElement()!)
        dealer.deal(card: card ,to: dealer.activatedHand!, delay: false)
        gameMaster.gameState = .dealtCards
    }
    
    func inputReceived(action: PlayerAction) {

    }
    
    func tasksForEndOfRound() {
        gameMaster.prepareForNewRound()
    }
    
    func waitForPlayerInput() {
        let inputView = DeviationInputView(frame: .zero, deviation: self.deviation)
        inputView.deviationSubmitHandler = { action, count, tcDirection, rcDirection in
            
            let inputAction = StrategyAction(rawValue: action.rawValue)!
            let text = self.getInputText(action: inputAction, count: count, tcDirection: tcDirection, rcDirection: rcDirection)
            let correctText = self.getCorrectText()
            let isInputCorrect = self.isInputCorrect(action: inputAction, count: count, tcDirection: tcDirection, rcDirection: rcDirection)
            
            if Settings.shared.quickFeedback {
                QuickFeedback.result(isInputCorrect, delegate: self.gameMaster.delegate)
                self.gameMaster.discardAllHands()
            } else {
                self.gameMaster.delegate.presentBasicStrategyFeedbackView(isCorrect: isInputCorrect, playerAction: text, correctAction: correctText) {
                    self.gameMaster.discardAllHands()
                }
            }
            inputView.removeFromSuperview()
        }
        
        let tableView = gameMaster.tableView
        tableView.addSubview(inputView)
        inputView.snp.makeConstraints { make in
            make.centerX.equalTo(tableView.snp.centerX)
            make.centerY.equalTo(tableView.snp.centerY).offset(-10)
            var widthFactor = 1.0
            if tableView.traitCollection.horizontalSizeClass == .compact {
                widthFactor *= 0.75
            } else { // assumes .regular
                widthFactor *= 0.5
            }
            make.width.greaterThanOrEqualTo(tableView.snp.width).multipliedBy(widthFactor)
            make.height.lessThanOrEqualTo(350)
        }
    }
    
    private func isInputCorrect(action: StrategyAction, count inputCount: Int, tcDirection: String, rcDirection: String) -> Bool {
        
        let correctAction = getCorrectAction()
        let devCount = deviation.count
        if devCount == nil {
            return action == correctAction
        } else if devCount == 0 {
            return action == correctAction && rcDirection == deviation.direction
        } else {
            return action == correctAction && inputCount == devCount && tcDirection == deviation.direction
        }
    }
    
    private func getInputText(action: StrategyAction, count inputCount: Int, tcDirection: String, rcDirection: String) -> String {
        let devCount = deviation.count
        let action = action.rawValue.uppercased()
        if devCount == nil {
            return "\(action)"
        } else if devCount == 0 {
            return "\(rcDirection) RC \(action)"
        } else {
            return "TC \(inputCount)\(tcDirection) \(action)"
        }
    }
    
    private func getCorrectText() -> String {
        let correctAction = getCorrectAction().rawValue.uppercased()
        let devCount = deviation.count
        
        if devCount == nil {
            return "\(correctAction)"
        } else if devCount == 0 {
            return "\(deviation.direction!) RC \(correctAction)"
        } else {
            return "TC \(devCount!)\(deviation.direction!) \(correctAction)"
        }
    }
    
    private func getCorrectAction() -> StrategyAction {
        var correctAction = self.deviation.action
        if correctAction == .doubleHit || correctAction == .doubleStand {
            correctAction = .double
        }
        return correctAction
    }

}
