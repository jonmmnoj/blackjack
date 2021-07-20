//
//  StrategyGameDecks.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/19/21.
//

import Foundation
import UIKit

class StrategyGameDecks {
    var twoCardHandDeck: StrategyDeck
    var threeCardHandDeck: StrategyDeck
    var fourCardHandDeck: StrategyDeck
    
    
    
    
    init() {
        
        var twoCardHands: [[CardValue]] = []
        var threeCardHands: [[CardValue]] = []
        var fourCardHands: [[CardValue]] = []
        
        let values: [CardValue] = [.ace, .two, .three, .four, .five, .six, .seven, .eight, .nine, .ten, .jack, .queen, .king ]
        
        var added = 0
        var bust = 0
        var twentyone = 0
        var split = 0
        
        twoCardHands = []
        
        for i in 0...values.count - 1 {
            //print("entered loop for i: \(i)")
            for j in i...values.count - 1 {
                if isBlackJack(value1: values[i], value2: values[j]) {
                    twentyone += 1
                    continue
                }
                twoCardHands.append([values[i], values[j]])
                added += 1
                //print("\(values[i]) \(values[j])")
            }
        }
        
        threeCardHands = []
        added = 0
        bust = 0
        twentyone = 0
        split = 0
        for i in 0...twoCardHands.count - 1 {
            //print("entered loop for i: \(i)")
            if twoCardHands[i][0] == twoCardHands[i][1] {
                split += 1
                continue
            }
            for j in 0...values.count - 1 {
                if isValue21(value1: twoCardHands[i][0], value2: twoCardHands[i][1], value3: values[j]) { continue }
                if isBust(value1: twoCardHands[i][0], value2: twoCardHands[i][1], value3: values[j]) { continue }
                threeCardHands.append([twoCardHands[i][0], twoCardHands[i][1], values[j]])
            }
        }
        
        //print("3 card hands: added: \(added), busted: \(bust), twentyones: \(twentyone), splits: \(split)")
        
        fourCardHands = []
        added = 0
        bust = 0
        twentyone = 0
        split = 0
        
        for i in 0...threeCardHands.count - 1 {
            //print("entered loop for i: \(i)")
//            if twoCardHands[i][0] == twoCardHands[i][1] {
//                split += 1
//                continue
//            }
            for j in 0...values.count - 1 {
                if isValue21(value1: threeCardHands[i][0], value2: threeCardHands[i][1], value3: threeCardHands[i][2], value4: values[j]) {
                    //print("Is 21: \(threeCardHands[i][0]) \(threeCardHands[i][1]) \(threeCardHands[i][2]) \(values[j])")
                    twentyone += 1
                    continue
                }
                if isBust(value1: threeCardHands[i][0], value2: threeCardHands[i][1], value3: threeCardHands[i][2], value4: values[j]) {
                    //print("Is Bust: \(threeCardHands[i][0]) \(threeCardHands[i][1]) \(threeCardHands[i][2]) \(values[j])")
                    bust += 1
                    continue
                }
                threeCardHands.append([threeCardHands[i][0], threeCardHands[i][1], threeCardHands[i][2], values[j]])
                added += 1
                //print("Added: \(threeCardHands[i][0]) \(threeCardHands[i][1]) \(threeCardHands[i][2]) \(values[j])")
            }
        }
        
        
        //print("4 card hands: added: \(added), busted: \(bust), twentyones: \(twentyone),
        twoCardHandDeck = StrategyDeck()
        for i in 0...twoCardHands.count - 1 {
            let hand = twoCardHands[i]
            for j in 0...values.count - 1{
                let action = BasicStrategy.getPlayerAction(dealerCardValue: values[j].rawValue, playerCardValues: [hand[0].rawValue, hand[1].rawValue])
                let pc = [ hand[0], hand[1]]
                let dc = [values[j]]
                let SR = StrategyRound(playerCards: pc, dealerCards: dc, action: action)
                twoCardHandDeck.rounds.append(SR)
            }
        }
        
        threeCardHandDeck = StrategyDeck()
        for i in 0...twoCardHands.count - 1 {
            // check for split
            if twoCardHands[i][0] == twoCardHands[i][1] {
                continue
            }
            let hand = twoCardHands[i]
            for j in 0...values.count - 1 {
                // j is the dealers card
                let playerCardValues = [hand[0].rawValue, hand[1].rawValue]//, values[j].rawValue]
                // see if this combination of palyer cardsa and dealer card is supposed to be hit
                let action = BasicStrategy.getPlayerAction(dealerCardValue: values[j].rawValue, playerCardValues: playerCardValues)
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
                        let a = BasicStrategy.getPlayerAction(dealerCardValue: values[j].rawValue, playerCardValues: [hand[0].rawValue, hand[1].rawValue, values[k].rawValue])
                        let SR = StrategyRound(playerCards: pc, dealerCards: dc, action: a)
                        threeCardHandDeck.rounds.append(SR)
                    }
                }
            }
        }
        
        fourCardHandDeck = StrategyDeck()
        // same idea as three deck
//        var roundNum = 0
//        for round in threeCardHandDeck.rounds {
//            print(roundNum)
//            roundNum += 1
//            let hand = round.playerCards
//            for j in 0...values.count - 1 {
//                // j is the dealers card
//                let playerCardValues = [hand[0].value.rawValue, hand[1].value.rawValue, hand[2].value.rawValue]//, values[j].rawValue]
//                // see if this combination of palyer cardsa and dealer card is supposed to be hit
//                let action = BS.getPlayerAction(dealerCardValue: values[j].rawValue, playerCardValues: playerCardValues)
//                if action == .hit {
//                    for k in 0...values.count - 1 {
//                        if isValue21(value1: hand[0].value, value2: hand[1].value, value3: hand[2].value, value4: values[k]) { continue }
//                        if isBust(value1: hand[0].value, value2: hand[1].value, value3: hand[2].value, value4: values[k]) { continue }
//                        let pc = [Card(value: hand[0].value, suit: .clubs), Card(value: hand[1].value, suit: .clubs), Card(value: hand[2].value, suit: .clubs), Card(value: values[k], suit: .clubs)]
//                        let dc = [Card(value: values[j], suit: .clubs)]
//                        let a = BS.getPlayerAction(dealerCardValue: values[j].rawValue, playerCardValues: [hand[0].value.rawValue, hand[1].value.rawValue, hand[2].value.rawValue, values[k].rawValue])
//                        let SR = StrategyRound(playerCards: pc, dealerCards: dc, action: a)
//                        fourCardHandDeck.rounds.append(SR)
//                    }
//                }
//            }
//        
//        //threeCardHandDeck.printRounds()
//        
//        //6292
//        // 4360
//        }
        
        print(threeCardHandDeck.rounds.count)
        //threeCardHandDeck = StrategyDeck()
        print(fourCardHandDeck.rounds.count)
        fourCardHandDeck = StrategyDeck()
        
        

        
    }
    
    static func keepHandForStrategyDeck(playerCardValues: [Int], dealerCardValue: Int) -> Bool {
        let type = BasicStrategy.getRuleType(playerCardValues: playerCardValues)
        switch type {
        case .pair:
            return keepPairHand(playerCardValues: playerCardValues, dealerCardValue: dealerCardValue)
        case .soft:
            return keepSoftHand(playerCardValues: playerCardValues, dealerCardValue: dealerCardValue)
        case .hard:
            return keepHardHand(playerCardValues: playerCardValues, dealerCardValue: dealerCardValue)
        }
    }
    
    static private func keepPairHand(playerCardValues: [Int], dealerCardValue: Int) -> Bool {
        switch dealerCardValue {
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
    
    static private func keepSoftHand(playerCardValues: [Int], dealerCardValue: Int) -> Bool {
        switch dealerCardValue {
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
    
    static private func keepHardHand(playerCardValues: [Int], dealerCardValue: Int) -> Bool {
        switch dealerCardValue {
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
}

func isBlackJack(value1: CardValue, value2: CardValue) -> Bool {
    let array: [CardValue] = [value1, value2]
    let hasTen = array.contains(.ten) || array.contains(.jack)
    //{ $0 == .ten || $0 == .jack || $0 == .queen || $0 == .king }
    let hasAce = array.contains { $0 == .ace }
    return hasTen && hasAce
}


func isValue21(value1: CardValue, value2: CardValue, value3: CardValue, value4: CardValue? = nil) -> Bool {
    let hand = Hand(dealToPoint: CGPoint(x: 0, y: 0), adjustmentX: 0, adjustmentY: 0, owner: Dealer(table: Table(view: UIView(), gameMaster: GameMaster(table: UIView()))))
    
    hand.add(Card(value: value1, suit: .clubs))
    hand.add(Card(value: value2, suit: .clubs))
    hand.add(Card(value: value3, suit: .clubs))
    if value4 != nil { hand.add(Card(value: value4!, suit: .clubs)) }
    
    return Rules.value(of: hand) == 21
    
}

func isBust(value1: CardValue, value2: CardValue, value3: CardValue, value4: CardValue? = nil) -> Bool {
    let hand = Hand(dealToPoint: CGPoint(x: 0, y: 0), adjustmentX: 0, adjustmentY: 0, owner: Dealer(table: Table(view: UIView(), gameMaster: GameMaster(table: UIView()))))
    
    hand.add(Card(value: value1, suit: .clubs))
    hand.add(Card(value: value2, suit: .clubs))
    hand.add(Card(value: value3, suit: .clubs))
    if value4 != nil { hand.add(Card(value: value4!, suit: .clubs)) }
    
    return Rules.didBust(hand: hand)
}
