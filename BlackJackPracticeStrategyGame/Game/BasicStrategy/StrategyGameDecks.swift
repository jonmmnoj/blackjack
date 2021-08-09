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
    static func getDecks() -> [StrategyDeck] {
        var array: [StrategyDeck] = []
        if Settings.shared.twoCardHands {
            array.append(twoCardHandDeck)
        }
        if Settings.shared.threeCardHands {
            array.append(threeCardHandDeck)
        }
        if Settings.shared.fourCardHands {
            array.append(fourCardHandDeck)
        }
        return array//.randomElement()!
    }
    
//    static func getRandomRound() {
//        let decks = getDecks()
//        let deck = decks.randomElement()
//        deck?.nextRoundThatIsDeviation()
//    }
    
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
    
    static var threeCardHandDeck: StrategyDeck {
        let deck = StrategyDeck(type: .threeCards)
        for hand in threeCardHands {
            let pc = [hand[0], hand[1], hand[2]]
            let dc = [hand[3]]
            let a = BasicStrategy.getPlayerAction(dealerCardValue: dc[0], playerCardValues: pc)
            let SR = StrategyRound(playerCards: pc, dealerCards: dc, action: a)
            deck.rounds.append(SR)
        }
        print(deck.rounds.count)
        return deck
    }
    
    static var fourCardHandDeck: StrategyDeck {
        let deck = StrategyDeck(type: .fourCards)
        for hand in fourCardHands {
            let pc = [hand[0], hand[1], hand[2], hand[3]]
            let dc = [hand[4]]
            let a = BasicStrategy.getPlayerAction(dealerCardValue: dc[0], playerCardValues: pc)
            let SR = StrategyRound(playerCards: pc, dealerCards: dc, action: a)
            deck.rounds.append(SR)
        }
        print(deck.rounds.count)
        return deck
    }
    
//    // count 765
//    static var tchd: [[Int]] = []
//    static var threeCardHandDeck: StrategyDeck {
////        if let deck = UserDefaults.standard.object(forKey: "threeCardHandDeck") {
////            //return deck as! StrategyDeck
////        }
//        let deck = StrategyDeck(type: .threeCards)
//        for i in 0...twoCardHands.count - 1 {
//            // check for split
//            if twoCardHands[i][0] == twoCardHands[i][1] {
//                continue
//            }
//            let hand = twoCardHands[i]
//            for j in 0...values.count - 1 {
//                // j is the dealers card
//                let playerCardValues = [hand[0], hand[1]]//, values[j].rawValue]
//                // see if this combination of palyer cardsa and dealer card is supposed to be hit
//                let action = BasicStrategy.getPlayerAction(dealerCardValue: values[j], playerCardValues: playerCardValues)
//                if action == .hit {
//                    for k in 0...values.count - 1 {
//                        // k is the possible hit cards
//                        let pc = [hand[0], hand[1], values[k]]
//                        if isBust(value1: hand[0], value2: hand[1], value3: values[k]) {
//                            continue
//                        }
//                        if isValue21(value1: hand[0], value2: hand[1], value3: values[k]) {
//                            continue
//                        }
//                        let dc = [ values[j]]
//                        if !StrategyGameDecks.keepHandForStrategyDeck(playerCardValues: [hand[0], hand[1], values[k]], dealerCardValue: dc[0]) {
//                            continue
//                        }
//
//                        let a = BasicStrategy.getPlayerAction(dealerCardValue: values[j], playerCardValues: [hand[0], hand[1], values[k]])
//                        let SR = StrategyRound(playerCards: pc, dealerCards: dc, action: a)
//                        //print(SR.playerCards)
//                        deck.rounds.append(SR)
//                        tchd.append([hand[0],hand[1],values[k],dc[0]])
//                    }
//                }
//            }
//        }
//        //UserDefaults.standard.set(deck, forKey: "threeCardHandDeck")
//        print(deck.rounds.count)
//        print(tchd)
//        return deck
//    }
    
    
/// this was used to generate the fourcardhands array. this is slow way to make deck. based on threecardhands. keeping in case need to regenerate or alter four card hands.
//    static var fchd: [[Int]] = []
    // count 11610
//    static var fourCardHandDeck: StrategyDeck {
////        if let deck = UserDefaults.standard.object(forKey: "fourCardHandDeck") {
////            //return deck as! StrategyDeck
////        }
//        var add = 0
//        let deck = StrategyDeck(type: .fourCards)
//        for i in 0...threeCardHands.count - 1 {
//
//            let hand = threeCardHands[i]
//            for j in 0...values.count - 1 {
//                // j is the dealers card
//                let playerCardValues = [hand[0], hand[1], hand[2]]//, values[j].rawValue]
//                // see if this combination of palyer cardsa and dealer card is supposed to be hit
//                let action = BasicStrategy.getPlayerAction(dealerCardValue: values[j], playerCardValues: playerCardValues)
//                if action == .hit {
//                    for k in 0...values.count - 1 {
//                        // k is the possible hit cards
//                        var pc = playerCardValues
//                        pc.append(values[k])
//                        if isBust(value1: hand[0], value2: hand[1], value3: hand[2], value4: values[k]) {
//                            continue
//                        }
//                        if isValue21(value1: hand[0], value2: hand[1], value3: hand[2], value4: values[k]) {
//                            continue
//                        }
//                        let dc = [ values[j]]
//                        if !StrategyGameDecks.keepHandForStrategyDeck(playerCardValues: pc, dealerCardValue: dc[0]) {
//                            continue
//                        }
//                        add += 1
//                        // append 1 for every 10
//                        if add % 10 != 0 {
//                            continue
//                        }
//
//                        fchd.append([hand[0], hand[1], hand[2], values[k], dc[0]])
//
//                        let a = BasicStrategy.getPlayerAction(dealerCardValue: values[j], playerCardValues: pc)
//                        let SR = StrategyRound(playerCards: pc, dealerCards: dc, action: a)
//                        deck.rounds.append(SR)
//                    }
//                }
//            }
//        }
//        //UserDefaults.standard.set(deck, forKey: "fourCardHandDeck")
//        print(deck.rounds.count)
//        print(fchd)
//        return deck
//    }
    
    static func keepHandForStrategyDeck(playerCardValues: [Int], dealerCardValue: Int) -> Bool {
        let type = BasicStrategy.getRuleType(playerCardValues: playerCardValues)
        if type == .hard {
            // TODO: Why did I put a check for 1 -- OH BLACKJACK CHECK maybe?
                // in mean time I'll put a condition fro four card hand
            if (!playerCardValues.contains(1) || playerCardValues.count == 4) && playerCardValues.reduce(0, +) > 17 {
                return false
            }
        }
//        else if type == .soft {
//            if (playerCardValues.count > 2) {
//                return false
//            }
//        }
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
    
}


