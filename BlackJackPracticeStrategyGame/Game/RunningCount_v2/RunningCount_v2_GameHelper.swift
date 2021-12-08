//
//  RunningCountv2GameHelper.swift
//  BlackJackPracticeStrategyGame
//
//  Created by Jon on 11/28/21.
//

import UIKit

class RunningCountV2GameHelper: FreePlayGameTypeStrategy {
    
    override init(gameMaster: GameMaster) {
        super.init(gameMaster: gameMaster)
    }
    
    override var automaticPlay: Bool {
        return true
    }
    
    override func waitForPlayerInput() {
        gameMaster.discardAllHands()
    }
    
    override func tasksForEndOfRound() {
        gameMaster.delegate.enableTableSettingsButton(true)
        countMaster.endOfRoundTasks(gameMaster: gameMaster, completion: {
            CardCounter.shared.reset()
            self.gameMaster.prepareForNewRound()
            self.gameMaster.delegate.enableTableSettingsButton(false)
        })
        
    }
    
    private func getDealPoint(for stackNumber: Int) -> CGPoint {
        var dealPoint = CGPoint(x: (UIScreen.main.bounds.midX * 0.5) - Card.width * 0.5, y: UIScreen.main.bounds.midY - Card.height * 0.5)
        if Settings.shared.rcNumberOfStacks == 1 {//&& !Settings.shared.rcDealInPairs {
            dealPoint = CGPoint(x: UIScreen.main.bounds.midX - Card.width * 0.5, y: UIScreen.main.bounds.midY - Card.height * 0.5)
        }
        else if stackNumber == 1 {
            dealPoint = CGPoint(x: (UIScreen.main.bounds.midX + UIScreen.main.bounds.midX * 0.5)  - Card.width * 0.5, y: UIScreen.main.bounds.midY - Card.height * 0.5)
        }
        else if stackNumber == 2 {
            dealPoint = CGPoint(x: UIScreen.main.bounds.midX - Card.width * 0.5, y: UIScreen.main.bounds.midY - Card.height * 2)
        }
        else if stackNumber == 3 {
            dealPoint = CGPoint(x: UIScreen.main.bounds.midX - Card.width * 0.5, y: UIScreen.main.bounds.midY + Card.height * 1)
        }
        return dealPoint
    }
    
    override func dealCards() {
        var numberOfLoops = Settings.shared.rcNumberOfCards
        numberOfLoops /= Settings.shared.rcNumberOfStacks
        if Settings.shared.rcDealInPairs {
            numberOfLoops /= 2
        }
        for i in 0...numberOfLoops - 1 {
            var cards = [Card]()
            let numberOfStacks = Settings.shared.rcNumberOfStacks
            for j in 0...numberOfStacks - 1 {
                let value = CardValue.allCases.randomElement()!
                let suit = CardSuit.allCases.randomElement()!
                let card = Card(value: value , suit: suit)
                let dealPoint = getDealPoint(for: j)
                card.set(dealPoint: dealPoint)
                var delay: Double = Double(i) * Settings.dealSpeedFactor
                if i == 0 {
                    delay = 0
                }
                card.customDealDelay = delay
                cards.append(card)
                
                if Settings.shared.rcDealInPairs {
                    let value = CardValue.allCases.randomElement()!
                    let suit = CardSuit.allCases.randomElement()!
                    let card2 = Card(value: value , suit: suit)
                    card2.dealPoint = CGPoint(x: card.dealPoint.x + Card.width * 0.35, y: card.dealPoint.y - Card.height * 0.25)
                    //card2.isDouble = true
                    //card2.rotationDegrees = card.rotationDegrees
                    card2.customDealDelay = card.customDealDelay
                    cards.append(card2)
                }
            }
            for card in cards {
                self.dealer.deal(card: card, to: self.player.activatedHand!)
            }
        }
        self.gameMaster.gameState = .dealtCards
    }
}
    
    /* Ideas/Notes for dealing cards one/two/three,etc at a time, instead of dealing liek a real game...
     
     In settings, have option to "How to deal cards..." One card, Two cards, Three cards, etc, Simulate Game (like a real game),
     
     if deal one card at a time, or two, and not like a real game...
       have to override dealCards().. then deal as many cards to player as needed
        until the deck or shoe is one card short... then ask for count...
       to ask for count... change logic for waitForPlayerInput()
     ... need to call taskAtEndOfRound() and get input for running count...
     ... then start new round, ie return to dealCards()
    */

