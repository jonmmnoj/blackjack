//
//  Hand.swift
//  PrettyExample
//
//  Created by JON on 7/6/21.
//  Copyright © 2021 nlampi. All rights reserved.
//

import Foundation
import UIKit



class Hand {
    var cards: [Card] = []
    var nextCardPoint: CGPoint
    private(set) var hasAce: Bool = false
    private(set) var owner: Dealable
    var originPoint: CGPoint
    var isSplitHand: Bool = false
    var adjustmentX: CGFloat
    var adjustmentY: CGFloat
    var state: HandState
    var canSplit: Bool {
        return cards.count == 2// && cards[0].value.rawValue == cards[1].value.rawValue
    }
    
    init(dealToPoint: CGPoint, adjustmentX: CGFloat, adjustmentY: CGFloat, owner: Dealable) {
        self.nextCardPoint = dealToPoint
        self.originPoint = dealToPoint
        self.adjustmentX = adjustmentX
        self.adjustmentY = adjustmentY
        self.owner = owner
        self.state = .incomplete
    }
    
    func add(_ card: Card) {
        self.cards.append(card)
        if card.value == .ace { self.hasAce = true }
        if self.cards.count > 1 { adjustDealPoint(isRotated: card.isDouble) }
        card.set(dealPoint: nextCardPoint)
    }
    
    func adjustDealPoint(isRotated: Bool = false) {
        let oldPoint = self.nextCardPoint
        var newY = oldPoint.y - adjustmentY
        var newX = oldPoint.x + adjustmentX
        if isRotated {
            newY -= adjustmentY/1.15 // look into better solution or save as constants? what if card size changes does that make a difference
            newX += adjustmentX/2
        }
        self.nextCardPoint = CGPoint(x: newX, y: newY)
    }
    
    func resetNextCardPoint() {
        self.nextCardPoint = self.originPoint
    }
    
    func value() -> Int {
        var array: [Int] = []
        self.cards.forEach {
            array.append($0.value.rawValue)
        }
        return array.reduce(0, +)
    }
    
    func clearHand() {
        cards = []
        hasAce = false
        //isSplitHand =
        //resetNextCardPoint()
    }
    
    func createSplitHand() -> Hand {
        let newHand = Hand(dealToPoint: CGPoint(x: self.nextCardPoint.x + 10 + Card.width, y: self.originPoint.y), adjustmentX: self.adjustmentX, adjustmentY: self.adjustmentY, owner: self.owner)
        newHand.isSplitHand = true
        let lastCard = cards.last!
        newHand.add(lastCard)
        cards.removeLast()
        if !self.isSplitHand {
            resetNextCardPoint() // so that new 2nd card is dealt to right spot on table
        } else {
            set(nextCardPoint: CGPoint(x: nextCardPoint.x - adjustmentX, y: nextCardPoint.y + adjustmentY))
        }
        owner.activatedHand = newHand
        owner.hands.append(newHand)
        return newHand
    }
    
    func set(adjustmentX: CGFloat, adjustmentY: CGFloat) {
        self.adjustmentX = adjustmentX
        self.adjustmentY = adjustmentY
    }
    
    func set(state: HandState) {
        self.state = state
        if (state == .stand) {
            //self.owner.searchForIncompleteHand()
        }
        else if (state == .double) {
            //self.owner.searchForIncompleteHand()
        }
        else if (state == .blackjack) {
            //self.owner.searchForIncompleteHand()
        }
        
        
    }
    
    func set(nextCardPoint: CGPoint) {
        self.nextCardPoint = nextCardPoint
    }
    
    
}
