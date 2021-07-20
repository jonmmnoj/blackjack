//
//  CardCounter.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/13/21.
//

import Foundation

class CardCounter {
    static var shared = CardCounter()
    var count: Int
    
    private init() {
        count = 0
    }
    
    func count(card: Card) {
        if card.isFaceDown {
            return
        }
        switch card.value {
        case .two, .three, .four, .five, .six:
            count += 1
            printCount()
        case .seven, .eight, .nine:
            count += 0
        case .ten, .jack, .queen, .king, .ace:
            count -= 1
            printCount()
        }
    }
    
    func printCount() {
        print("Count updated to: \(count)")
    }
    
}
