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
    var isFinished: Bool = false
    var isDealer = false
    
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
            if hand.state == .incomplete {
                self.activatedHand = hand
                return
            }
        }
        self.activatedHand = nil // no action left to take
        self.isFinished = true
    }
    
    func clearHands() {
        self.hands = []
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
    
    
}
