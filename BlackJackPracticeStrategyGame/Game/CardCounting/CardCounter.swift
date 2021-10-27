//
//  CardCounter.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/13/21.
//

import Foundation

class CardCounter {
    static var shared = CardCounter()
    var runningCount: Int = 0
    var numberOfCardsPlayed: Int = 0
    
    private init() {}
    
    func reset() {
        runningCount = 0
        numberOfCardsPlayed = 0
        print("Card Counter reset")
    }
    
    func getNumberOfDiscardedDecks() -> Float {
        let result: Float
        let roundDeckToNearest = Settings.shared.deckRoundedTo
        let roundLast3DecksToHalf = false //Settings.shared.roundDecksToHalf
        let discardedDecks = Float(Float(numberOfCardsPlayed) / 52)
        if roundDeckToNearest == "whole" {
            if roundLast3DecksToHalf && discardedDecks >= 3 {
                result = discardedDecks.floor(nearest: 0.5)
            } else {
                result = discardedDecks.rounded(.towardZero) // if 0.9 -> 0, if 1.25 -> 1, if 1.5 -> 1, if 1.75 -> 1, if 1.99 -> 1
            }
        } else {
            result = discardedDecks.floor(nearest: 0.5) // if 0.4 -> 0, if 0.5 -> 0.5, if 0.9 -> 0.5, if 0.99 -> 0.5, if 1 -> 1
        }
        return result
    }
    
    func getNumberOfDecksInPlay() -> Float {
        let result = Float(Settings.shared.numberOfDecks) - getNumberOfDiscardedDecks()
        return result
    }
    
    func getTrueCount() -> Int {
        let divisionResult = (Float(runningCount) / getNumberOfDecksInPlay())
        let trueCount = Int(divisionResult)
        return trueCount
    }
    
    func discard() {
        numberOfCardsPlayed += 1
    }
    
    func count(card: Card) {
        if card.isFaceDown {
            return
        }
        switch card.value {
        case .two, .three, .four, .five, .six:
            runningCount += 1
        case .seven, .eight, .nine:
            runningCount += 0
        case .ten, .jack, .queen, .king, .ace:
            runningCount -= 1
        }
    }
    
    func doesDeviationApply(_ deviation: Deviation) -> Bool {
        var apply: Bool = false
        let deviationTrueCount = deviation.getCount()
        let direction = deviation.direction
        if deviationTrueCount == nil {
            apply = true
        } else {
            if deviationTrueCount! == 0 { // Use the RUNNING count when 0
                if direction == "+" {
                    if self.runningCount > 0 {
                        apply = true
                    }
                } else {
                    if self.runningCount < 0 {
                        apply = true
                    }
                }
            }
            if direction == "+" {
                if self.getTrueCount() >= deviationTrueCount! {
                    apply = true
                }
            } else {
                if self.getTrueCount() <= deviationTrueCount! {
                    apply = true
                }
            }
        }
        return apply
    }
    
    func getNumberOfCardsLeft() -> Int {
        let totalCards = Settings.shared.numberOfDecks * 52
        let numOfCardsNotPlayed = totalCards - numberOfCardsPlayed
        return numOfCardsNotPlayed
    }
}
