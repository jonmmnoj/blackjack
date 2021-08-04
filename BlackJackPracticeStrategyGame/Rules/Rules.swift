//
//  Rules.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/6/21.
//

import Foundation

class Rules {
    static func didBust(hand: Hand) -> Bool {
        return Rules.value(of: hand) > 21
    }
    
    static func isOver21(hand: Hand) -> Bool {
        if hand.hasAce {
            return valueOfHandWithAces(for: hand) > 21
        }
        else {
            return hand.value() > 21
        }
    }
    
    static func value(of hand: Hand) -> Int {
        var value = 0
        if hand.hasAce {
            value = valueOfHandWithAces(for: hand)
        } else {
            value = hand.value()
        }
        return value
    }
    
    static func valueOfHandWithAces(for hand: Hand) -> Int {
        var array: [Int] = []
        hand.cards.forEach {
            var rawValue = $0.value.rawValue
            if rawValue == 1 { rawValue = 11 }
            array.append(rawValue)
        }
        
        var updated = false
        repeat {
            updated = false
            if array.reduce(0, +) > 21 {
                for i in 0...array.count - 1 {
                    if array[i] == 11 {
                        array[i] = 1
                        updated = true
                        break
                    }
                }
            } else {
                break
            }
        } while (updated)
       
        return array.reduce(0, +)
    }
    
    // this allows checks for soft 17
    static func isSoftOrHardSeventeenOrGreater(hand: Hand) -> Bool {
        let value = Rules.value(of: hand)
        if value == 17 {
            // if deal to soft 17, then this returns true
            // otherwise, need to test if 17 is hard or not
            return Settings.shared.dealerHitsSoft17 ? isHardSeventeen(hand: hand) : true
        } else {
            return value > 17
        }
    }
    
    static func isHardSeventeen(hand: Hand) -> Bool {
        guard Rules.value(of: hand) == 17 else {
            return false
        }
        
        if !hand.hasAce {
            return true
        }
        
        var total = 0
        hand.cards.forEach {
            total += $0.value.rawValue
        }
        
        return total == 17 // after checks above, assume H17 when total is 17
    }
    
    static func hasBlackjack(hand: Hand) -> Bool {
        let hasTen = hand.cards.contains { $0.value == .ten || $0.value == .jack || $0.value == .queen || $0.value == .king }
        let hasAce = hand.cards.contains { $0.value == .ace }
        return hasTen && hasAce && hand.cards.count == 2
    }
    
    static func value(of cards: [Card]) -> Int {
        let array = cards.filter { card in
            return card.wasDealt && !card.isFaceDown
        }
        let h = Hand(dealToPoint: .zero, adjustmentX: 0, adjustmentY:0, owner: Player())
        h.cards = array
        let value = Rules.value(of: h)
        return value
    }
    
    static func value(of ints: [Int]) -> Int {
        var array: [Card] = []
        for int in ints {
            array.append(Card(value: CardValue(rawValue: int)!, suit: .clubs))
        }
        let h = Hand(dealToPoint: .zero, adjustmentX: 0, adjustmentY:0, owner: Player())
        h.cards = array
        let value = Rules.value(of: h)
        return value
    }
}
