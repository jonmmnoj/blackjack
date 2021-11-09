//
//  Player.swift
//  PrettyExample
//
//  Created by JON on 7/6/21.
//  Copyright © 2021 nlampi. All rights reserved.
//

import Foundation
import UIKit


class Player: Dealable {
    
    var activatedHand: Hand? // nil implies all hands are complete ie no action to take
    var hands: [Hand] = []
    //var isFinished: Bool = false
    var isDealer = false
    
    var numberOfHandsToMoveForScore: Int {
        var indexOfLastHandWithNilResult = 0
        var count = 0
        for hand in hands {
            count += 1
            if hand.result == nil {
                indexOfLastHandWithNilResult = count
            }
        }
        var amountToMove = 0
        if indexOfLastHandScored == nil {
            amountToMove = indexOfLastHandWithNilResult
        } else {
            amountToMove = indexOfLastHandScored! - indexOfLastHandWithNilResult
        }
        indexOfLastHandScored = indexOfLastHandWithNilResult
        
        return amountToMove
    }
    var indexOfLastHandScored: Int? = nil
    var nextHandToScore: Hand? {
        let hands = self.hands.reversed()
        for hand in hands {
            if hand.result == nil {
                return hand
            }
        }
        return nil
    }
    
    init() {

    }
    
    func add(hand: Hand) {
        self.hands.append(hand)
        set(activatedHand: hand)
    }
    
    func set(activatedHand hand: Hand?) {
        self.activatedHand = hand
    }
    
    func searchForIncompleteHand() {
        for i in (0..<self.hands.count).reversed() {
            let hand = hands[i]
            if hand.state == .incomplete || hand.state == .splitAces { //|| (hand.state == .splitAces && hand.cards[0].value == .ace && hand.cards[1].value == .ace)  { 
                self.activatedHand = hand
                return
            }
        }
        self.activatedHand = nil // no action left to take
        //self.isFinished = true
    }
    
    func clearHands() {
        self.hands = []
        self.indexOfLastHandScored = nil
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
