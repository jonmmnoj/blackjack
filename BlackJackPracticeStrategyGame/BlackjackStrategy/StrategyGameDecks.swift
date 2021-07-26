//
//  StrategyGameDecks.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/19/21.
//

import Foundation
import UIKit

class StrategyGameDecks {
    // count 248
    static var twoCardHandDeck: StrategyDeck {
        let deck = StrategyDeck(type: .twoCards)
        for i in 0...twoCardHands.count - 1 {
            let hand = twoCardHands[i]
            for j in 0...values.count - 1{
                let action = BasicStrategy.getPlayerAction(dealerCardValue: values[j], playerCardValues: [hand[0], hand[1]])
                let pc = [ hand[0], hand[1]]
                let dc = [values[j]]
                
                if !StrategyGameDecks.keepHandForStrategyDeck(playerCardValues: pc, dealerCardValue: dc[0]) {
                    continue
                }
                let SR = StrategyRound(playerCards: pc, dealerCards: dc, action: action)
                deck.rounds.append(SR)
            }
        }
        print(deck.rounds.count)
        return deck
    }
    
    // count 765
    static var threeCardHandDeck: StrategyDeck {
        let deck = StrategyDeck(type: .threeCards)
        for i in 0...twoCardHands.count - 1 {
            // check for split
            if twoCardHands[i][0] == twoCardHands[i][1] {
                continue
            }
            let hand = twoCardHands[i]
            for j in 0...values.count - 1 {
                // j is the dealers card
                let playerCardValues = [hand[0], hand[1]]//, values[j].rawValue]
                // see if this combination of palyer cardsa and dealer card is supposed to be hit
                let action = BasicStrategy.getPlayerAction(dealerCardValue: values[j], playerCardValues: playerCardValues)
                if action == .hit {
                    for k in 0...values.count - 1 {
                        // k is the possible hit cards
                        let pc = [hand[0], hand[1], values[k]]
                        if isBust(value1: hand[0], value2: hand[1], value3: values[k]) {
                            continue
                        }
                        if isValue21(value1: hand[0], value2: hand[1], value3: values[k]) {
                            continue
                        }
                        let dc = [ values[j]]
                        if !StrategyGameDecks.keepHandForStrategyDeck(playerCardValues: [hand[0], hand[1], values[k]], dealerCardValue: dc[0]) {
                            continue
                        }
                        
                        let a = BasicStrategy.getPlayerAction(dealerCardValue: values[j], playerCardValues: [hand[0], hand[1], values[k]])
                        let SR = StrategyRound(playerCards: pc, dealerCards: dc, action: a)
                        deck.rounds.append(SR)
                    }
                }
            }
        }
        print(deck.rounds.count)
        return deck
    }
    
    // count 11610
    static var fourCardHandDeck: StrategyDeck {
        let deck = StrategyDeck(type: .fourCards)
        for i in 0...threeCardHands.count - 1 {
            
            let hand = threeCardHands[i]
            for j in 0...values.count - 1 {
                // j is the dealers card
                let playerCardValues = [hand[0], hand[1], hand[2]]//, values[j].rawValue]
                // see if this combination of palyer cardsa and dealer card is supposed to be hit
                let action = BasicStrategy.getPlayerAction(dealerCardValue: values[j], playerCardValues: playerCardValues)
                if action == .hit {
                    for k in 0...values.count - 1 {
                        // k is the possible hit cards
                        var pc = playerCardValues
                        pc.append(values[k])
                        if isBust(value1: hand[0], value2: hand[1], value3: hand[2], value4: values[k]) {
                            continue
                        }
                        if isValue21(value1: hand[0], value2: hand[1], value3: hand[2], value4: values[k]) {
                            continue
                        }
                        let dc = [ values[j]]
                        if !StrategyGameDecks.keepHandForStrategyDeck(playerCardValues: pc, dealerCardValue: dc[0]) {
                            continue
                        }
                        
                        let a = BasicStrategy.getPlayerAction(dealerCardValue: values[j], playerCardValues: pc)
                        let SR = StrategyRound(playerCards: pc, dealerCards: dc, action: a)
                        deck.rounds.append(SR)
                    }
                }
            }
        }
        print(deck.rounds.count)
        return deck
    }
    
    static func keepHandForStrategyDeck(playerCardValues: [Int], dealerCardValue: Int) -> Bool {
        let type = BasicStrategy.getRuleType(playerCardValues: playerCardValues)
        if type == .hard {
            // TODO: Why did I put a check for 1 -- OH BLACKJACK CHECK maybe?
                // in mean time I'll put a condition fro four card hand
            if (!playerCardValues.contains(1) || playerCardValues.count == 4) && playerCardValues.reduce(0, +) > 17 {
                return false
            }
        }
        let prv = BasicStrategy.getPlayerRuleValue(rule: type, playerCardValues: playerCardValues)
        switch type {
        case .pair:
            return keepPairHand(playerRuleValue: prv, dealerCardValue: dealerCardValue)
        case .soft:
            return keepSoftHand(playerRuleValue: prv, dealerCardValue: dealerCardValue)
        case .hard:
            return keepHardHand(playerRuleValue: prv, dealerCardValue: dealerCardValue)
        }
    }
    
    static private func keepPairHand(playerRuleValue: Int, dealerCardValue: Int) -> Bool {
        switch playerRuleValue {
        case 10:
            return dealerCardValue >= 4 && dealerCardValue <= 6
        case 9:
            return dealerCardValue == 1 || dealerCardValue >= 5 && dealerCardValue <= 10
        case 8:
            return dealerCardValue >= 5 && dealerCardValue <= 7
        case 7:
            return dealerCardValue >= 5 && dealerCardValue <= 8
        case 6:
            return dealerCardValue >= 5 && dealerCardValue <= 7
        case 5:
            return dealerCardValue == 6
        case 4:
            return dealerCardValue >= 4 && dealerCardValue <= 7
        case 3:
            return dealerCardValue >= 5 && dealerCardValue <= 8
        case 2:
            return dealerCardValue >= 5 && dealerCardValue <= 8
        default:
            return false
        }
    }
    
    static private func keepSoftHand(playerRuleValue: Int, dealerCardValue: Int) -> Bool {
        switch playerRuleValue {
        case 9:
            return dealerCardValue >= 6 && dealerCardValue <= 7
        case 8:
            return dealerCardValue >= 4 && dealerCardValue <= 7
        case 7:
            return dealerCardValue >= 2 && dealerCardValue <= 9
        case 6:
            return dealerCardValue >= 2 && dealerCardValue <= 7
        case 5:
            return dealerCardValue >= 3 && dealerCardValue <= 7
        case 4:
            return dealerCardValue >= 3 && dealerCardValue <= 7
        case 3:
            return dealerCardValue >= 4 && dealerCardValue <= 7
        case 2:
            return dealerCardValue >= 4 && dealerCardValue <= 7
        default:
            return false
        }
    }
    
    static private func keepHardHand(playerRuleValue: Int, dealerCardValue: Int) -> Bool {
        switch playerRuleValue {
        case 17:
            return dealerCardValue == 1 || dealerCardValue >= 9 && dealerCardValue <= 10
        case 16:
            return dealerCardValue == 1 || dealerCardValue >= 2 && dealerCardValue <= 10
            // that's all of the cards, so could just do: return true
        case 15:
            return dealerCardValue == 1 || dealerCardValue >= 2 && dealerCardValue <= 10
        case 14:
            return dealerCardValue >= 3 && dealerCardValue <= 7
        case 13:
            return dealerCardValue >= 4 && dealerCardValue <= 7
        case 12:
            return dealerCardValue >= 4 && dealerCardValue <= 7
        case 11:
            return dealerCardValue == 1 || dealerCardValue >= 7 && dealerCardValue <= 10
        case 10:
            return dealerCardValue == 1 || dealerCardValue >= 7 && dealerCardValue <= 10
        case 9:
            return dealerCardValue >= 2 && dealerCardValue <= 8
        case 8:
            return dealerCardValue >= 5 && dealerCardValue <= 7
        default:
            return false
        }
    }
    
    static func isBlackJack(value1: CardValue, value2: CardValue) -> Bool {
        let array: [CardValue] = [value1, value2]
        let hasTen = array.contains(.ten) || array.contains(.jack)
        //{ $0 == .ten || $0 == .jack || $0 == .queen || $0 == .king }
        let hasAce = array.contains { $0 == .ace }
        return hasTen && hasAce
    }


    static func isValue21(value1: Int, value2: Int, value3: Int, value4: Int? = nil) -> Bool {
        let hand = Hand(dealToPoint: CGPoint(x: 0, y: 0), adjustmentX: 0, adjustmentY: 0, owner: Dealer(table: Table(view: UIView(), gameMaster: GameMaster(gameType: .freePlay, table: UIView()))))
        
        hand.add(Card(value: CardValue(rawValue: value1)!, suit: .clubs))
        hand.add(Card(value: CardValue(rawValue: value2)!, suit: .clubs))
        hand.add(Card(value: CardValue(rawValue: value3)!, suit: .clubs))
        if value4 != nil { hand.add(Card(value: CardValue(rawValue: value4!)!, suit: .clubs)) }
        
        return Rules.value(of: hand) == 21
        
    }

    static func isBust(value1: Int, value2: Int, value3: Int, value4: Int? = nil) -> Bool {
        let hand = Hand(dealToPoint: CGPoint(x: 0, y: 0), adjustmentX: 0, adjustmentY: 0, owner: Dealer(table: Table(view: UIView(), gameMaster: GameMaster(gameType: .freePlay, table: UIView()))))
        
        hand.add(Card(value: CardValue(rawValue: value1)!, suit: .clubs))
        hand.add(Card(value: CardValue(rawValue: value2)!, suit: .clubs))
        hand.add(Card(value: CardValue(rawValue: value3)!, suit: .clubs))
        if value4 != nil { hand.add(Card(value: CardValue(rawValue: value4!)!, suit: .clubs)) }
        
        return Rules.didBust(hand: hand)
    }
    
    static let values: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]
    
    static var twoCardHands: [[Int]] {
        return [ [1,1],[1,2],[1,3],[1,4],[1,5],[1,6],[1,7],[1,8],[1,9],[2,2],[2,3],[2,4],[2,5],[2,6],[2,7],[2,8],[2,9],[2,10],[3,3],[3,4],[3,5],[3,6],[3,7],[3,8],[3,9],[3,10],[4,4],[4,5],[4,6],[4,7],[4,8],[4,9],[4,10],[5,5],[5,6],[5,7],[5,8],[5,9],[5,10],[6,6],[6,7],[6,8],[6,9],[6,10],[7,7],[7,8],[7,9],[7,10],[8,8],[8,9],[8,10],[9,9],[9,10],[10,10]]
    }
    
    static var threeCardHands: [[Int]] {
        return [[1,2,4],[1,2,5],[1,2,2],[1,2,3],[1,2,4],[1,2,5],[1,2,1],[1,2,2],[1,2,3],[1,2,4],[1,2,5],[1,2,6],[1,2,9],[1,2,10],[1,2,1],[1,2,2],[1,2,3],[1,2,4],[1,2,5],[1,2,6],[1,2,7],[1,2,9],[1,2,10],[1,2,5],[1,2,5],[1,3,3],[1,3,4],[1,3,1],[1,3,2],[1,3,3],[1,3,4],[1,3,10],[1,3,1],[1,3,2],[1,3,3],[1,3,4],[1,3,5],[1,3,8],[1,3,9],[1,3,10],[1,3,1],[1,3,2],[1,3,3],[1,3,4],[1,3,5],[1,3,6],[1,3,8],[1,3,9],[1,3,10],[1,3,4],[1,3,4],[1,4,10],[1,4,2],[1,4,3],[1,4,10],[1,4,1],[1,4,2],[1,4,3],[1,4,9],[1,4,10],[1,4,1],[1,4,2],[1,4,3],[1,4,4],[1,4,5],[1,4,7],[1,4,8],[1,4,9],[1,4,10],[1,4,3],[1,4,10],[1,4,3],[1,4,10],[1,4,10],[1,5,9],[1,5,10],[1,5,1],[1,5,2],[1,5,9],[1,5,10],[1,5,1],[1,5,2],[1,5,8],[1,5,9],[1,5,10],[1,5,1],[1,5,2],[1,5,3],[1,5,4],[1,5,6],[1,5,7],[1,5,8],[1,5,9],[1,5,10],[1,5,2],[1,5,9],[1,5,10],[1,5,2],[1,5,9],[1,5,10],[1,5,9],[1,5,10],[1,6,8],[1,6,9],[1,6,10],[1,6,1],[1,6,8],[1,6,9],[1,6,1],[1,6,2],[1,6,3],[1,6,5],[1,6,6],[1,6,7],[1,6,8],[1,6,9],[1,6,1],[1,6,8],[1,6,9],[1,6,1],[1,6,8],[1,6,9],[1,6,10],[1,6,8],[1,6,9],[1,6,10],[1,7,7],[1,7,8],[1,7,9],[1,7,10],[1,7,7],[1,7,8],[1,7,9],[1,7,10],[1,7,7],[1,7,8],[1,7,9],[1,7,10],[2,3,5],[2,3,6],[2,3,10],[2,3,4],[2,3,10],[2,3,1],[2,3,4],[2,3,9],[2,3,10],[2,3,1],[2,3,4],[2,3,7],[2,3,8],[2,3,9],[2,3,10],[2,3,1],[2,3,2],[2,3,3],[2,3,4],[2,3,7],[2,3,8],[2,3,9],[2,3,10],[2,3,1],[2,3,2],[2,3,3],[2,3,4],[2,3,7],[2,3,8],[2,3,9],[2,3,10],[2,3,1],[2,3,2],[2,3,3],[2,3,4],[2,3,5],[2,3,6],[2,3,7],[2,3,8],[2,3,9],[2,3,10],[2,3,4],[2,3,5],[2,3,6],[2,3,10],[2,3,5],[2,3,6],[2,3,10],[2,3,5],[2,3,6],[2,3,10],[2,4,4],[2,4,5],[2,4,9],[2,4,10],[2,4,1],[2,4,3],[2,4,9],[2,4,10],[2,4,1],[2,4,3],[2,4,8],[2,4,9],[2,4,10],[2,4,1],[2,4,3],[2,4,6],[2,4,7],[2,4,8],[2,4,9],[2,4,10],[2,4,1],[2,4,2],[2,4,3],[2,4,6],[2,4,7],[2,4,8],[2,4,9],[2,4,10],[2,4,1],[2,4,2],[2,4,3],[2,4,6],[2,4,7],[2,4,8],[2,4,9],[2,4,10],[2,4,1],[2,4,2],[2,4,3],[2,4,4],[2,4,5],[2,4,6],[2,4,7],[2,4,8],[2,4,9],[2,4,10],[2,4,3],[2,4,4],[2,4,5],[2,4,9],[2,4,10],[2,4,4],[2,4,5],[2,4,9],[2,4,10],[2,4,4],[2,4,5],[2,4,9],[2,4,10],[2,5,3],[2,5,4],[2,5,8],[2,5,9],[2,5,10],[2,5,1],[2,5,2],[2,5,8],[2,5,9],[2,5,1],[2,5,2],[2,5,7],[2,5,8],[2,5,9],[2,5,1],[2,5,2],[2,5,5],[2,5,6],[2,5,7],[2,5,8],[2,5,9],[2,5,1],[2,5,2],[2,5,5],[2,5,6],[2,5,7],[2,5,8],[2,5,9],[2,5,1],[2,5,2],[2,5,5],[2,5,6],[2,5,7],[2,5,8],[2,5,9],[2,5,1],[2,5,2],[2,5,3],[2,5,4],[2,5,5],[2,5,6],[2,5,7],[2,5,8],[2,5,9],[2,5,1],[2,5,2],[2,5,3],[2,5,4],[2,5,8],[2,5,9],[2,5,1],[2,5,3],[2,5,4],[2,5,8],[2,5,9],[2,5,10],[2,5,3],[2,5,4],[2,5,8],[2,5,9],[2,5,10],[2,6,2],[2,6,3],[2,6,7],[2,6,8],[2,6,9],[2,6,7],[2,6,8],[2,6,6],[2,6,7],[2,6,8],[2,6,1],[2,6,4],[2,6,5],[2,6,6],[2,6,7],[2,6,8],[2,6,1],[2,6,4],[2,6,5],[2,6,6],[2,6,7],[2,6,8],[2,6,1],[2,6,4],[2,6,5],[2,6,6],[2,6,7],[2,6,8],[2,6,1],[2,6,2],[2,6,3],[2,6,4],[2,6,5],[2,6,6],[2,6,7],[2,6,8],[2,6,2],[2,6,3],[2,6,7],[2,6,8],[2,6,2],[2,6,3],[2,6,7],[2,6,8],[2,6,9],[2,6,2],[2,6,3],[2,6,7],[2,6,8],[2,6,9],[2,7,2],[2,7,6],[2,7,7],[2,7,8],[2,7,6],[2,7,7],[2,7,1],[2,7,2],[2,7,3],[2,7,4],[2,7,5],[2,7,6],[2,7,7],[2,7,2],[2,7,6],[2,7,7],[2,7,2],[2,7,6],[2,7,7],[2,7,8],[2,7,2],[2,7,6],[2,7,7],[2,7,8],[2,8,5],[2,8,6],[2,8,7],[2,8,5],[2,8,6],[2,8,7],[2,10,3],[2,10,4],[2,10,5],[2,10,3],[2,10,4],[2,10,2],[2,10,3],[2,10,4],[2,10,1],[2,10,2],[2,10,3],[2,10,4],[2,10,3],[2,10,4],[2,10,3],[2,10,4],[2,10,5],[2,10,3],[2,10,4],[2,10,5],[3,4,3],[3,4,4],[3,4,8],[3,4,9],[3,4,10],[3,4,1],[3,4,2],[3,4,8],[3,4,9],[3,4,1],[3,4,2],[3,4,7],[3,4,8],[3,4,9],[3,4,1],[3,4,2],[3,4,5],[3,4,6],[3,4,7],[3,4,8],[3,4,9],[3,4,1],[3,4,2],[3,4,5],[3,4,6],[3,4,7],[3,4,8],[3,4,9],[3,4,1],[3,4,2],[3,4,5],[3,4,6],[3,4,7],[3,4,8],[3,4,9],[3,4,1],[3,4,2],[3,4,3],[3,4,4],[3,4,5],[3,4,6],[3,4,7],[3,4,8],[3,4,9],[3,4,1],[3,4,2],[3,4,3],[3,4,4],[3,4,8],[3,4,9],[3,4,1],[3,4,3],[3,4,4],[3,4,8],[3,4,9],[3,4,10],[3,4,3],[3,4,4],[3,4,8],[3,4,9],[3,4,10],[3,5,2],[3,5,3],[3,5,7],[3,5,8],[3,5,9],[3,5,7],[3,5,8],[3,5,6],[3,5,7],[3,5,8],[3,5,1],[3,5,4],[3,5,5],[3,5,6],[3,5,7],[3,5,8],[3,5,1],[3,5,4],[3,5,5],[3,5,6],[3,5,7],[3,5,8],[3,5,1],[3,5,4],[3,5,5],[3,5,6],[3,5,7],[3,5,8],[3,5,1],[3,5,2],[3,5,3],[3,5,4],[3,5,5],[3,5,6],[3,5,7],[3,5,8],[3,5,2],[3,5,3],[3,5,7],[3,5,8],[3,5,2],[3,5,3],[3,5,7],[3,5,8],[3,5,9],[3,5,2],[3,5,3],[3,5,7],[3,5,8],[3,5,9],[3,6,2],[3,6,6],[3,6,7],[3,6,8],[3,6,6],[3,6,7],[3,6,1],[3,6,2],[3,6,3],[3,6,4],[3,6,5],[3,6,6],[3,6,7],[3,6,2],[3,6,6],[3,6,7],[3,6,2],[3,6,6],[3,6,7],[3,6,8],[3,6,2],[3,6,6],[3,6,7],[3,6,8],[3,7,5],[3,7,6],[3,7,7],[3,7,5],[3,7,6],[3,7,7],[3,9,3],[3,9,4],[3,9,5],[3,9,3],[3,9,4],[3,9,2],[3,9,3],[3,9,4],[3,9,1],[3,9,2],[3,9,3],[3,9,4],[3,9,3],[3,9,4],[3,9,3],[3,9,4],[3,9,5],[3,9,3],[3,9,4],[3,9,5],[3,10,2],[3,10,3],[3,10,4],[3,10,1],[3,10,2],[3,10,3],[3,10,2],[3,10,3],[3,10,2],[3,10,3],[3,10,4],[3,10,2],[3,10,3],[3,10,4],[4,5,2],[4,5,6],[4,5,7],[4,5,8],[4,5,6],[4,5,7],[4,5,1],[4,5,2],[4,5,3],[4,5,4],[4,5,5],[4,5,6],[4,5,7],[4,5,2],[4,5,6],[4,5,7],[4,5,2],[4,5,6],[4,5,7],[4,5,8],[4,5,2],[4,5,6],[4,5,7],[4,5,8],[4,6,5],[4,6,6],[4,6,7],[4,6,5],[4,6,6],[4,6,7],[4,8,3],[4,8,4],[4,8,5],[4,8,3],[4,8,4],[4,8,2],[4,8,3],[4,8,4],[4,8,1],[4,8,2],[4,8,3],[4,8,4],[4,8,3],[4,8,4],[4,8,3],[4,8,4],[4,8,5],[4,8,3],[4,8,4],[4,8,5],[4,9,2],[4,9,3],[4,9,4],[4,9,1],[4,9,2],[4,9,3],[4,9,2],[4,9,3],[4,9,2],[4,9,3],[4,9,4],[4,9,2],[4,9,3],[4,9,4],[4,10,1],[4,10,2],[4,10,3],[4,10,1],[4,10,2],[4,10,1],[4,10,2],[4,10,1],[4,10,2],[4,10,3],[4,10,1],[4,10,2],[4,10,3],[5,7,3],[5,7,4],[5,7,5],[5,7,3],[5,7,4],[5,7,2],[5,7,3],[5,7,4],[5,7,1],[5,7,2],[5,7,3],[5,7,4],[5,7,3],[5,7,4],[5,7,3],[5,7,4],[5,7,5],[5,7,3],[5,7,4],[5,7,5],[5,8,2],[5,8,3],[5,8,4],[5,8,1],[5,8,2],[5,8,3],[5,8,2],[5,8,3],[5,8,2],[5,8,3],[5,8,4],[5,8,2],[5,8,3],[5,8,4],[5,9,1],[5,9,2],[5,9,3],[5,9,1],[5,9,2],[5,9,1],[5,9,2],[5,9,1],[5,9,2],[5,9,3],[5,9,1],[5,9,2],[5,9,3],[5,10,1],[5,10,2],[5,10,1],[5,10,1],[5,10,1],[5,10,2],[5,10,1],[5,10,2],[6,7,2],[6,7,3],[6,7,4],[6,7,1],[6,7,2],[6,7,3],[6,7,2],[6,7,3],[6,7,2],[6,7,3],[6,7,4],[6,7,2],[6,7,3],[6,7,4],[6,8,1],[6,8,2],[6,8,3],[6,8,1],[6,8,2],[6,8,1],[6,8,2],[6,8,1],[6,8,2],[6,8,3],[6,8,1],[6,8,2],[6,8,3],[6,9,1],[6,9,2],[6,9,1],[6,9,1],[6,9,1],[6,9,2],[6,9,1],[6,9,2],[6,10,1],[6,10,1],[6,10,1],[7,8,1],[7,8,2],[7,8,1],[7,8,1],[7,8,1],[7,8,2],[7,8,1],[7,8,2],[7,9,1],[7,9,1],[7,9,1],]
    }
}


