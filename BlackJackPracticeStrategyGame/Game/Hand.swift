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
    var betAmount: Int = 0
    var insurance: Insurance?
    var cards: [Card] = []
    var nextCardPoint: CGPoint
    private(set) var hasAce: Bool = false
    private(set) var owner: Dealable
    var isFirstHand: Bool {
        return owner.hands.first === self
    }
    
    var originPoint: CGPoint
    var wasSplit: Bool = false
    var isSplitAce: Bool = false
    var isSplitHand: Bool = false
    var adjustmentX: CGFloat
    var adjustmentY: CGFloat
    var state: HandState
    var result: HandResult? = nil
    var isGhostHand = false
    
    func adjustForScaleChange(dealPoint: CGPoint, adjustmentX: CGFloat, adjustmentY: CGFloat, changeInDealPointX: CGFloat? = nil, changeInDealPointY: CGFloat? = nil) {
        var changeX = originPoint.x - dealPoint.x // The originPoint is the orginal point... The new deal point is apparently adjusted for the new card size.
        var changeY = originPoint.y - dealPoint.y
        
        // changeInDealPoint is never nil, so just use that and get rid of dealPoint argument
        
        if changeInDealPointX != nil {
            changeX = changeInDealPointX!
        }
        if changeInDealPointY != nil {
            changeY = changeInDealPointY!
        }
        
        
        self.nextCardPoint = CGPoint(x: originPoint.x - changeX, y: originPoint.y - changeY)
        self.originPoint = CGPoint(x: originPoint.x - changeX, y: originPoint.y - changeY)
        self.adjustmentX = adjustmentX
        self.adjustmentY = adjustmentY
        for (i, card) in cards.enumerated() {
            if i > 0 {
                adjustDealPoint(isRotated: card.rotateAnimation)
                //card.dealPoint = nextCardPoint
            }
            card.dealPoint = nextCardPoint
        }
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
        card.hand = self
        if card.value == .ace { self.hasAce = true }
        
        if Settings.shared.gameType != .runningCount_v2 {
            if cards.count > 1 { adjustDealPoint(isRotated: card.rotateAnimation) }
            card.set(dealPoint: nextCardPoint)
        }
        
//        if self.cards.count == 2 && Rules.hasBlackjack(hand: self) {
//            state = .blackjack
//        }
    }
    
    func adjustDealPoint(isRotated: Bool = false) {
        let oldPoint = self.nextCardPoint
        var newY = oldPoint.y - adjustmentY
        var newX = oldPoint.x + adjustmentX
        if isRotated {
            newY -= adjustmentY * 1.2// /1.15 // look into better solution or save as constants? what if card size changes does that make a difference.  
            newX += adjustmentX * 0.6
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
    }
    
    func createSplitHand() -> Hand {
        let newHand = Hand(dealToPoint: CGPoint(x: self.nextCardPoint.x + Card.width * 1.6, y: self.originPoint.y),
        //let newHand = Hand(dealToPoint: CGPoint(x: self.nextCardPoint.x + 50 + Card.width, y: self.originPoint.y),
                           adjustmentX: self.adjustmentX, adjustmentY: self.adjustmentY, owner: self.owner)
        newHand.betAmount = self.betAmount
        //Settings.shared.bankRollAmount -= Double(self.betAmount)
        Bankroll.shared.add(-Double(self.betAmount))
        newHand.isSplitHand = true
        self.isSplitHand = true
        newHand.isGhostHand = self.isGhostHand
        if isAces() {
            self.isSplitAce = true
            newHand.isSplitAce = true
        }
        self.wasSplit = true
        let lastCard = cards.last!
        newHand.add(lastCard)
        cards.removeLast()
        set(nextCardPoint: CGPoint(x: nextCardPoint.x - adjustmentX, y: nextCardPoint.y + adjustmentY))
        //resetNextCardPoint()
        owner.activatedHand = newHand
        let index = owner.index(of: self)!
        owner.hands.insert(newHand, at: index + 1)
        return newHand
    }
    
    func set(adjustmentX: CGFloat, adjustmentY: CGFloat) {
        self.adjustmentX = adjustmentX
        self.adjustmentY = adjustmentY
    }
    
    func set(state: HandState) {
        self.state = state
    }
    
    func set(nextCardPoint: CGPoint) {
        self.nextCardPoint = nextCardPoint
    }
    
    var valueLabelView: UILabel?
    
    func updateViewValueOfHand(for table: Table) {
        guard Settings.shared.showHandTotal else {
            if valueLabelView != nil {
                valueLabelView?.removeFromSuperview()
            }
            return
        }
        
        //if owner.isDealer && cards[0].isFaceDown { return }
        
        if valueLabelView == nil {
            let width: CGFloat = 45
            let height: CGFloat = 20
            let padding: CGFloat = 10
            let x: CGFloat = self.owner.isDealer ? originPoint.x + Settings.shared.cardWidth * 0.5 : originPoint.x + Settings.shared.cardWidth * 0.5 //originPoint.x + Settings.shared.cardWidth - width
            valueLabelView = UILabel(frame: CGRect(x: x, y: originPoint.y + Settings.shared.cardSize + padding, width: width, height: height))
            valueLabelView?.font = UIFont.preferredFont(forTextStyle: .body)
            valueLabelView?.backgroundColor = .white
            valueLabelView?.textAlignment = .center
            table.view.addSubview(valueLabelView!)
        }
        
        let array = cards.filter { card in
            return card.wasDealt && !card.isFaceDown
        }
        let h = Hand(dealToPoint: .zero, adjustmentX: 0, adjustmentY:0, owner: self.owner)
        h.cards = array
        let value = Rules.value(of: h.cards)
        var s = String(value)

        var cardValues: [Int] = []
        for card in h.cards {
            cardValues.append(card.value.rawValue)
        }
        if BasicStrategy.getRuleType(playerCardValues: cardValues) == .soft {
            s += "/\(value + 10)"
        }
        valueLabelView?.text = String(s)
    }
    
    func isAces() -> Bool {
        guard cards.count == 2 else { return false }
        return cards[0].value == .ace && cards[1].value == .ace
    }
}
