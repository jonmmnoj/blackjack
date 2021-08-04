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
    var rule: Rule!
    
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
        self.rule = result.1
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
//        let correctAction = gameMaster.getPlayerAction()
//        let result = correctAction == action
//        print("\(result). Your action: \(action), Correct action: \(correctAction)")
//        gameMaster.delegate.presentBasicStrategyFeedbackView(playerAction: action, correctAction: correctAction)
    }
    
    func tasksForEndOfRound() {
        gameMaster.prepareForNewRound()
    }
    
    func waitForPlayerInput() {
        //dealer.indicateDealerIsReadyForPlayerInput(on: player.activatedHand!)
        //gameMaster.delegate.playerInput(enabled: true)
        
        let pvc = PopUpViewController()
        pvc.setupContentView = { containerView in
            containerView.backgroundColor = UIColor.black.withAlphaComponent(0)
            let inputView = DeviationInputView(frame: .zero)
            containerView.addSubview(inputView)
            inputView.snp.makeConstraints { make in
                make.center.equalTo(containerView)
                make.width.greaterThanOrEqualTo(containerView.snp.width).offset(-50)
                //make.left.equalTo(table)(50)
               // make.right.equalTo(table).offset(-50)
                make.height.equalTo(250)
            }
            inputView.submitHandler = { action, number in
                print("submit value: \(number)")
                // compare action/number with rule
                
                let isActionCorrect = action == self.rule.deviation!.getAction(numberOfPlayerCards: self.gameMaster.player.activatedHand!.cards.count)
                let isCountCorrect = number == self.rule.deviation!.getCount()
                
                if isActionCorrect && isCountCorrect {
                    print("deviation report: correct input")
                } else {
                    print("deviation report: wrong input")
                }
                
                
                self.gameMaster.delegate.dismissViewController(completion: nil)
                self.gameMaster.discardAllHands()
            }
        }
        gameMaster.delegate.presentViewController(pvc)
        
//        let table = gameMaster.tableView
//        let inputView = DeviationInputView(frame: .zero)
//        gameMaster.tableView.addSubview(inputView)
//        inputView.snp.makeConstraints { make in
//            make.center.equalTo(table)
//            make.width.greaterThanOrEqualTo(table.snp.width).offset(-50)
//            //make.left.equalTo(table)(50)
//           // make.right.equalTo(table).offset(-50)
//            make.height.equalTo(300)
//        }
//        inputView.completion = { correct in
//            print("submit value: \(correct)")
//        }
        
        
        
        
        // SHOW DEV INPUT, WITH CALLBACK FOR SUBMIT BUTTON
        // GET INPUT RETURNED ON TAP SUBMIT BUTTON
            // CHECK WITH RULES, CORRECT/INCORRECT
            // SHOW FEEDBACK VIEW, PROVIDE LABEL DATA, INCLUDE CALLBACK FOR DISMISS
        // ACTION DISMISS CALLED BACK
            // GM: SET STATE DISCARD ALL, THEN: RESUME
    }
}
