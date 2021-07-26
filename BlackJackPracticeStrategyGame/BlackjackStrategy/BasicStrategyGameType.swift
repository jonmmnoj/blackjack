//
//  BasicStrategyGameType.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/21/21.
//

import Foundation

class BasicStrategyGameType: GameTypeStrategyPatternProtocol {
    var gameMaster: GameMaster
    var deck: StrategyDeck?
    
    init(gameMaster: GameMaster) {
        self.gameMaster = gameMaster
    }
    
    func dealCards() {
        if deck == nil {
            deck = StrategyGameDecks.twoCardHandDeck
            //deck = StrategyGameDecks.threeCardHandDeck
            //deck = StrategyGameDecks.fourCardHandDeck
            //deck!.printArray()
            deck!.rounds.shuffle()
        }
        
        let r = deck!.nextRound()
        let pCards = r.playerCards
        let dCards = r.dealerCards
        var card = Card(value: CardValue(rawValue: pCards[0])!, suit: .clubs)
        dealer.deal(card: card, to: player.activatedHand!, delay: false)
        card = Card(value: CardValue(rawValue: pCards[1])!, suit: .clubs)
        dealer.deal(card:card, to: player.activatedHand!, delay: false)
        //card = Card(value: CardValue(rawValue: pCards[2])!, suit: .clubs)
        //dealer.deal(card: card, to: player.activatedHand!, delay: false)
        //card = Card(value: CardValue(rawValue: pCards[3])!, suit: .clubs)
        //dealer.deal(card: card, to: player.activatedHand!, delay: false)
        card = Card(value: CardValue(rawValue: dCards[0])!, suit: .clubs)
        card.isFaceDown = true
        dealer.deal(card:card ,to: dealer.activatedHand!, delay: false)
        card = Card(value: CardValue(rawValue: dCards[0])!, suit: .clubs)
        dealer.deal(card: card ,to: dealer.activatedHand!, delay: false)
    }
    
    func inputReceived(type: PlayerAction) {
        let correctAction = gameMaster.getPlayerAction()
        let result = correctAction == type
        print("\(result). Your action: \(type), Correct action: \(correctAction)")
        gameMaster.delegate.presentBasicStrategyFeedbackView(playerAction: type, correctAction: correctAction)
        
    }
    
    func tasksForEndOfRound() {
        gameMaster.prepareForNewRound()
    }
}
