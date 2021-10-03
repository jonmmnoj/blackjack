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
    var isFirstHand: Bool {
        return owner.hands.first === self
    }
    
    var originPoint: CGPoint
    var wasSplit: Bool = false // to prevent splitting same hand again ifo split then dealt a pair again.
    var isSplitHand: Bool = false
    var adjustmentX: CGFloat
    var adjustmentY: CGFloat
    var state: HandState
    var result: HandResult? = nil
    var canSplit: Bool {
        let isTwoCards = cards.count == 2
        let isPair = cards[0].value.rawValue == cards[1].value.rawValue
        if !isTwoCards || !isPair ||  wasSplit {
            return false
        } else if cards[0].value == .ace && isSplitHand && !Settings.shared.resplitAces {
            return false
        } else {
            return true
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
        if self.cards.count > 1 { adjustDealPoint(isRotated: card.rotateAnimation) }
        card.set(dealPoint: nextCardPoint)
    }
    
    func adjustDealPoint(isRotated: Bool = false) {
        let oldPoint = self.nextCardPoint
        var newY = oldPoint.y - adjustmentY
        var newX = oldPoint.x + adjustmentX
        if isRotated {
            newY -= adjustmentY * 1.2// /1.15 // look into better solution or save as constants? what if card size changes does that make a difference. NOTE: changed from divide by 1.15 to multiple by 0.87
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
        //isSplitHand =
        //resetNextCardPoint()
    }
    
    func createSplitHand() -> Hand {
        let newHand = Hand(dealToPoint: CGPoint(x: self.nextCardPoint.x + 10 + Card.width, y: self.originPoint.y), adjustmentX: self.adjustmentX, adjustmentY: self.adjustmentY, owner: self.owner)
        newHand.isSplitHand = true
        self.isSplitHand = true
        self.wasSplit = true
        let lastCard = cards.last!
        newHand.add(lastCard)
        cards.removeLast()
        // NOTE: I thnk this condition can be removed, so commenting out for now, and just calling set(nextCardPoint:). PRobably needed this condition when developing split feature but ended up not needing this by the time feature was complete, and just overlooked this part and did not refactor.
//        if !self.isSplitHand {
//            //resetNextCardPoint() // so that new 2nd card is dealt to right spot on table
//        } else {
//            set(nextCardPoint: CGPoint(x: nextCardPoint.x - adjustmentX, y: nextCardPoint.y + adjustmentY))
//        }
        set(nextCardPoint: CGPoint(x: nextCardPoint.x - adjustmentX, y: nextCardPoint.y + adjustmentY))
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
    }
    
    func set(nextCardPoint: CGPoint) {
        self.nextCardPoint = nextCardPoint
    }
    
    var valueLabelView: UILabel?
    
    func updateValueOfHand(for table: Table) {
        guard Settings.shared.showHandTotal else { return }
        
        if valueLabelView == nil {
            let width: CGFloat = 45
            let height: CGFloat = 20
            let padding: CGFloat = 10
            let x: CGFloat = self.owner.isDealer ? originPoint.x + Settings.shared.cardWidth * 0.5 : originPoint.x + Settings.shared.cardWidth * 0.5 //originPoint.x + Settings.shared.cardWidth - width
            valueLabelView = UILabel(frame: CGRect(x: x, y: originPoint.y + Settings.shared.cardSize + padding, width: width, height: height))
            valueLabelView?.backgroundColor = .white
            valueLabelView?.textAlignment = .center
            table.view.addSubview(valueLabelView!)
        }
        
        let array = cards.filter { card in
            return card.wasDealt && !card.isFaceDown
        }
        let h = Hand(dealToPoint: .zero, adjustmentX: 0, adjustmentY:0, owner: self.owner)
        h.cards = array
        let value = Rules.value(of: cards)
        var s = String(value)

        var cardValues: [Int] = []
        for card in cards {
            cardValues.append(card.value.rawValue)
        }
        if BasicStrategy.getRuleType(playerCardValues: cardValues) == .soft {
            s += "/\(value + 10)"
        }
        valueLabelView?.text = String(s)
    }
    
    
}
