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
    }
    
    func getDivisor() -> Int {
        let numOfDecks = Settings.shared.numberOfDecks
        let numOfDiscardedDecks = (numberOfCardsPlayed / 52)
        let divisor = numOfDecks - numOfDiscardedDecks
        return divisor
    }
    
    func getTrueCount() -> Int {
        return runningCount / getDivisor()
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
            printCount()
        case .seven, .eight, .nine:
            runningCount += 0
        case .ten, .jack, .queen, .king, .ace:
            runningCount -= 1
            printCount()
        }
    }
    
    func printCount() {
        print("Count updated to: \(runningCount)")
    }
    
}
