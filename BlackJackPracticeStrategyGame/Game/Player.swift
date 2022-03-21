//
//  Player.swift
//  PrettyExample
//
//  Created by JON on 7/6/21.
//  Copyright © 2021 nlampi. All rights reserved.
//

import UIKit

class Player: Dealable {
    func movedToHand(_ hand: Hand) {
        movedToHand = hand
    }
    
    var movedToHand: Hand?
    var splitHandGroups: [[Hand]] = []
    var dealt2Hands = false
    var activatedHand: Hand? // nil implies all hands are complete ie no action to take
    var hands: [Hand] = []
    //var isFinished: Bool = false
    var isDealer = false
    
    var numberOfHandsToMoveForScore: Int {
        //var indexOfLastHandWithNilResult = 0
        var indexOfLastHandWithNilResult: Int?
        var index = hands.count - 1
        for hand in hands.reversed() {
            if hand.result == nil && !hand.isGhostHand {
                indexOfLastHandWithNilResult = index
                break
            }
            index -= 1
        }
//        var amountToMove = 0
//        if indexOfLastHandScored == nil {//|| indexOfLastHandScored == 0 {
//            amountToMove = (hands.count - 1) - indexOfLastHandWithNilResult//0//indexOfLastHandWithNilResult
//        } else if indexOfLastHandWithNilResult == hands.count - 1 {
//            amountToMove = 0
//        }
//        else {
//            amountToMove = indexOfLastHandScored! - indexOfLastHandWithNilResult
//        }
        //return amountToMove
        
        var indexOfMovedToHand = 0
        for (i, hand) in hands.enumerated() {
            if hand === movedToHand {
                indexOfMovedToHand = i
            }
        }
        
        if indexOfLastHandWithNilResult != nil {
            let dif = indexOfMovedToHand - indexOfLastHandWithNilResult!
            return dif
        }
        return 0
        
    }
    
    var indexOfLastHandScored: Int? = nil
    var nextHandToScore: Hand? {
        let hands = self.hands.reversed()
        for hand in hands {
            if hand.result == nil && !hand.isGhostHand {
                return hand
            }
        }
        return nil
    }
    
    init() {

    }
    
    func add(hand: Hand, at index: Int) {
        if index == 0 { set(activatedHand: hand) }
        hands.insert(hand, at: index)
    }
    
    func add(hand: Hand, index: Int? = nil) {
        if hands.count == 0 { set(activatedHand: hand) }
        hands.append(hand)
    }
    
    func set(activatedHand hand: Hand?) {
        self.activatedHand = hand
    }
    
    func searchForIncompleteHand() {
        for i in (0..<self.hands.count) {//.reversed() {
            let hand = hands[i]
            if hand.state == .incomplete || hand.state == .splitAces { //|| (hand.state == .splitAces && hand.cards[0].value == .ace && hand.cards[1].value == .ace)  { 
                self.activatedHand = hand
                movedToHand = hand
                return
            }
        }
        self.activatedHand = nil // no action left to take
        //self.isFinished = true
    }
    
    func clearHands() {
        hands.removeAll()
        indexOfLastHandScored = nil
        splitHandGroups.removeAll()
        
    }
    
    func allHandsBust() -> Bool {
        var isBust = true
        self.hands.forEach {
            if $0.state != .bust {
                isBust = false
            }
        }
        return isBust
    }
    
    func allHandsLost() -> Bool {
        var isLost = true
        self.hands.forEach {
            let state = $0.state
            if state != .bust && state != .surrender {
                isLost = false
            }
        }
        return isLost
    }
    
    func allHandsBustSurrenderOrBlackjack() -> Bool {
        var result = true
        self.hands.forEach {
            let state = $0.state
            if state != .bust && state != .surrender && state != .blackjack {
                result = false
            }
        }
        return result
    }
    
    func index(of hand: Hand) -> Int? {
        for (i, h) in hands.enumerated() {
            if h === hand {
                return i
            }
        }
        return nil
    }
}

extension Player {
    func updateSplitHandGroups(new: Hand, original: Hand) {
        var index: Int?
        for (i, group) in splitHandGroups.enumerated() {
            if group.contains(where: { $0 === original }) {
                index = i
                break
            }
        }
        if let index = index {
            splitHandGroups[index].append(new)
            if Settings.shared.landscape {
                updateFrames(for: splitHandGroups[index])
            }
        } else {
            splitHandGroups.append([original, new])
            if Settings.shared.landscape {
                updateFrames(for: splitHandGroups.last!)
            }
        }
    }
    
    func howManyTimesHasOriginalHandBeenSplit(_ hand: Hand) -> Int {
        for group in splitHandGroups {
            if group.contains(where: { $0 === hand }) {
                return group.count
            }
        }
        return 0
    }
    
    func updateFrames(for splitHandGroup: [Hand]) {
        let count = splitHandGroup.count
        var firstHandDealPoint: CGPoint!
        let adjustmentX = Card.width * 0.5
        for (i, hand) in splitHandGroup.enumerated() {
            if i == 0 {
                firstHandDealPoint = hand.originPoint
                if count == 2 {
                    let newDealPoint = CGPoint(x: firstHandDealPoint.x - adjustmentX, y: firstHandDealPoint.y)
                    hand.adjustForScaleChange(dealPoint: newDealPoint, adjustmentX: hand.adjustmentX, adjustmentY: hand.adjustmentY)
                } else {
                    let newDealPoint = CGPoint(x: hand.originPoint.x - adjustmentX, y: hand.originPoint.y)
                    hand.adjustForScaleChange(dealPoint: newDealPoint, adjustmentX: hand.adjustmentX, adjustmentY: hand.adjustmentY)
                }
            } else if i == 1 {
                if count == 2 {
                    let newDealPoint = CGPoint(x: firstHandDealPoint.x + adjustmentX, y: firstHandDealPoint.y)
                    hand.adjustForScaleChange(dealPoint: newDealPoint, adjustmentX: hand.adjustmentX, adjustmentY: hand.adjustmentY)
                } else {
                    let newDealPoint = CGPoint(x: hand.originPoint.x - adjustmentX, y: hand.originPoint.y)
                    hand.adjustForScaleChange(dealPoint: newDealPoint, adjustmentX: hand.adjustmentX, adjustmentY: hand.adjustmentY)
                }
            } else if i == 2 {
                if count == 3 {
                    let newDealPoint = CGPoint(x: firstHandDealPoint.x + adjustmentX * 3, y: firstHandDealPoint.y)
                    hand.adjustForScaleChange(dealPoint: newDealPoint, adjustmentX: hand.adjustmentX, adjustmentY: hand.adjustmentY)
                } else {
                    let newDealPoint = CGPoint(x: hand.originPoint.x - adjustmentX, y: hand.originPoint.y)
                    hand.adjustForScaleChange(dealPoint: newDealPoint, adjustmentX: hand.adjustmentX, adjustmentY: hand.adjustmentY)
                }
            } else if i == 3 {
                if count == 4 {
                    let newDealPoint = CGPoint(x: firstHandDealPoint.x + adjustmentX * 5, y: firstHandDealPoint.y)
                    hand.adjustForScaleChange(dealPoint: newDealPoint, adjustmentX: hand.adjustmentX, adjustmentY: hand.adjustmentY)
                } else {
                    let newDealPoint = CGPoint(x: hand.originPoint.x - adjustmentX, y: hand.originPoint.y)
                    hand.adjustForScaleChange(dealPoint: newDealPoint, adjustmentX: hand.adjustmentX, adjustmentY: hand.adjustmentY)
                }
            }
        }
    }
}
