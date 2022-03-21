//
//  CardCounter.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/13/21.
//

import Foundation

class CardCounter {
    static var shared = CardCounter()
    var TCspecialCaseDeviationV2: Int?
    var RCspecialCaseDeviationV2: Int?
    private var runningCount: Int = 0
    var numberOfCardsPlayed: Int = 0
    
    private init() {}
    
    func reset() {
        runningCount = 0
        numberOfCardsPlayed = 0
        //print("Card Counter reset")
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
    
    func getRunningCount() -> Int {
        if Settings.shared.gameType == .deviations_v2 && RCspecialCaseDeviationV2 != nil {
            return RCspecialCaseDeviationV2!
        }
        return runningCount
    }
    
    func getTrueCountFloat() -> Float {
        let divisionResult = (Float(getRunningCount()) / getNumberOfDecksInPlay())
        if divisionResult.isInfinite {
            return -99
        }
        return divisionResult
    }
    
    func getTrueCount() -> Int {
        if Settings.shared.gameType == .deviations_v2 && TCspecialCaseDeviationV2 != nil {
            return TCspecialCaseDeviationV2!
        }
        
        let trueCountFloat = getTrueCountFloat()
        let trueCountRounded = Int(trueCountFloat)
        return trueCountRounded
    }
    
    func discard(_ card: Card) {
        if card.isPenetrationCard { return }
        numberOfCardsPlayed += 1
    }
    
    func count(card: Card) {
        if card.isFaceDown || card.isPenetrationCard {
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
            if deviationTrueCount! != 0 {
                if direction == "+" {
                    if getTrueCount() >= deviationTrueCount! {
                        apply = true
                    }
                } else if direction == "-" {
                    if getTrueCount() <= deviationTrueCount! {
                        apply = true
                    }
                }
            } else {
                if direction == "+" {
                    if getRunningCount() > 0 {
                        apply = true
                    }
                } else if direction == "-" {
                    if getRunningCount() < 0 {
                        apply = true
                    }
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
