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
        self.decks = StrategyGameDecks.getDecks() // need decks for devation hands only
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
    }
    
    func inputReceived(action: PlayerAction) {

    }
    
    func tasksForEndOfRound() {
        gameMaster.prepareForNewRound()
    }
    
    func waitForPlayerInput() {
        //dealer.indicateDealerIsReadyForPlayerInput(on: player.activatedHand!)
        //gameMaster.delegate.playerInput(enabled: true)
        
            let inputView = DeviationInputView(frame: .zero)
            inputView.submitHandler = { action, count, direction in
                
                let action = StrategyAction(rawValue: action.rawValue)
                
                //let deviationType: DeviationType = Deviation.getType()
                
                //let surrenderDeviation = self.rule.surrender?.getDeviation()
                //let ruleDeviation = self.rule.getDeviation()//self.rule.deviations!.first(where: { $0.type == deviationType })!
                
                //let deviationRule = self.rule.getDeviation(numberOfCards: self.gameMaster.player.activatedHand!.cards.count)!//surrenderDeviation != nil && self.gameMaster.player.activatedHand!.cards.count == 2 ? surrenderDeviation! : ruleDeviation!
                
                var correctAction = self.deviation.action
                if correctAction == .doubleHit || correctAction == .doubleStand {
                    correctAction = .double
                }
                
                let isActionCorrect = action == correctAction//deviationRule.getAction(numberOfPlayerCards: self.gameMaster.player.activatedHand!.cards.count)
                let isCountCorrect = count == self.deviation.getCount()
                let isDirectionCorrect = direction == self.deviation.direction
                
                if isActionCorrect && isCountCorrect && isDirectionCorrect {
                    print("deviation report: CORRECT input")
                } else {
                    print("deviation report: WRONG input")
                }
                print("Your answer: \(count)\(direction), \(action!.rawValue)")
                print("Correct answer: \(self.deviation.getCount() ?? 99)\(self.deviation.direction ?? "nil"), \(correctAction)")
                
                inputView.removeFromSuperview()
                self.gameMaster.discardAllHands()
            }
        
        let tableView = gameMaster.tableView
        tableView.addSubview(inputView)
        inputView.snp.makeConstraints { make in
            make.center.equalTo(tableView)
            make.width.greaterThanOrEqualTo(tableView.snp.width).offset(-50)
            //make.left.equalTo(table)(50)
           // make.right.equalTo(table).offset(-50)
            make.height.equalTo(250)
        }
    }

}
