//
//  File.swift
//  BlackJackPracticeStrategyGame
//
//  Created by Jon on 12/19/21.
//

import UIKit

class DeviationsGameTypeHelper_v2: GameTypeStrategyPatternProtocol {

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
        
        var numberOfPlayerCards = 0
        func dealCards() {
            var deck = decks.randomElement()!
            // this should be habndled in settings:
            // if rule is only soft and three card hands selected... only use deck w/ 2 card hands
//            if deck.deckType != .twoCards && !Settings.getTypeOfHands().contains(.hard) {
//                deck = decks.first(where: { $0.deckType == .twoCards })!
//            }
            
            
            let result = deck.nextRoundThatIsDeviation()//nextRound()
            let round = result.0
            self.deviation = result.1
            let pCards = round.playerCards
            numberOfPlayerCards = pCards.count
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
        
        func tasksForEndOfRound() {
            gameMaster.prepareForNewRound()
        }
    
        private func doesDeviationApply() -> Bool {
            let count = deviation.getCount()
            let sign = deviation.getSign()
            
            if count == nil {
                return true
            }
            
            if count! == 0 {
                if sign! == "+" {
                    if trueCount > count! || (trueCount == 0 && trueCountSign == "+") {
                        return true
                    }
                }
                if sign! == "-" {
                    if trueCount < count! || (trueCount == 0 && trueCountSign == "-") {
                        return true
                    }
                }
            } else {
                if sign! == "+" {
                    if trueCount >= count! {
                        return true
                    }
                }
                if sign! == "-" {
                    if trueCount <= count! {
                        return true
                    }
                }
            }
            
            return false
        }
    
        func inputReceived(action: PlayerAction) {
            let basicStrategyAction = gameMaster.getPlayerAction()
            let deviationAction = deviation.getAction(numberOfPlayerCards: numberOfPlayerCards)
            
            let correctAction = doesDeviationApply() ? deviationAction : basicStrategyAction.action
            
            let isInputCorrect = action == correctAction

            if Settings.shared.feedbackWhenWrong && isInputCorrect {
                self.gameMaster.discardAllHands()
            } else if Settings.shared.quickFeedback {
                QuickFeedback.result(isInputCorrect, delegate: self.gameMaster.delegate)
                self.gameMaster.discardAllHands()
            } else {
                self.gameMaster.delegate.presentBasicStrategyFeedbackView(isCorrect: isInputCorrect, playerAction: action.rawValue.uppercased(), correctAction: correctAction.rawValue.uppercased()) {
                    self.gameMaster.discardAllHands()
                }
            }
            inputView.removeFromSuperview()

        }
        
        var inputView: DeviationInputView!
        var trueCount = 99
        var trueCountSign = "+"
        func waitForPlayerInput() {
            trueCount = Int.random(in: -5...5) // more range if expanded deviations
            CardCounter.shared.TCspecialCaseDeviationV2 = trueCount
            if trueCount == 0 {
                let rn = Int.random(in: 0...1)
                trueCountSign = rn == 0 ? "+" : "-"
                if trueCountSign == "+" {
                    CardCounter.shared.RCspecialCaseDeviationV2 = 1
                } else {
                    CardCounter.shared.RCspecialCaseDeviationV2 = -1
                }
            }
            if trueCount != 0 {
                if trueCount > 0 {
                    CardCounter.shared.RCspecialCaseDeviationV2 = 1
                } else {
                    CardCounter.shared.RCspecialCaseDeviationV2 = -1
                }
            }
            
            inputView = DeviationInputView(frame: .zero, gameType: Settings.shared.gameType)
            inputView.textField.text = String(trueCount)
            if trueCount == 0 {
                inputView.textField.text = "\(inputView.textField.text!)\(trueCountSign)"
            }
            inputView.textField.isEnabled = false
            
            let tableView = gameMaster.tableView
            tableView.addSubview(inputView)
            inputView.snp.makeConstraints { make in
                make.centerX.equalTo(tableView.snp.centerX)
                make.centerY.equalTo(tableView.snp.centerY).offset(-10)
                //var widthFactor = 1.0
                //if tableView.traitCollection.horizontalSizeClass == .compact {
                //    widthFactor *= 0.75
                //} else { // assumes .regular
                //    widthFactor *= 0.5
                //}
                //if Settings.shared.horizontalSizeClass == .regular {
                //    make.width.equalTo(350)
                //} else {
                    //make.width.greaterThanOrEqualTo(tableView.snp.width).multipliedBy(widthFactor)
                make.width.equalTo(Card.width * 1.5)
                //}
                
                make.height.lessThanOrEqualTo(350)
            }
            
            dealer.indicateDealerIsReadyForPlayerInput(on: player.activatedHand!)
            gameMaster.delegate.playerInput(enabled: true)
        }
       
    }

