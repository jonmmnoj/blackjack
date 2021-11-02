//
//  BasicStrategyGameType.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/21/21.
//

import Foundation

class BasicStrategyGameType: GameTypeStrategyPatternProtocol {
    var gameMaster: GameMaster
    var decks: [StrategyDeck]
    
    init(gameMaster: GameMaster) {
        self.gameMaster = gameMaster
        self.decks = StrategyGameDecks.getDecks()
        for deck in decks {
            deck.shuffle()
        }
    }
    
    func dealCards() {
        let deck = decks.randomElement()!
        let r = deck.nextRound()
        let pCards = r.playerCards
        let dCards = r.dealerCards
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
        let correctAction = gameMaster.getPlayerAction()
        let result = correctAction == action
        gameMaster.delegate.presentBasicStrategyFeedbackView(isCorrect: result, playerAction: action.rawValue.uppercased(), correctAction: correctAction.rawValue.uppercased()) {
                self.gameMaster.discardAllHands()
            }
    }
    
    func tasksForEndOfRound() {
        gameMaster.prepareForNewRound()
    }
    
    func waitForPlayerInput() {
        dealer.indicateDealerIsReadyForPlayerInput(on: player.activatedHand!)
        gameMaster.delegate.playerInput(enabled: true)
    }
}
