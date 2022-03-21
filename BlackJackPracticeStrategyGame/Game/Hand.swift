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
    var isLastHand: Bool {
        return owner.hands.last === self
    }
    var wasSplitFromHand: Hand?
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
        var changeX = originPoint.x - dealPoint.x
        var changeY = originPoint.y - dealPoint.y
        
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
                adjustNextCardDealPoint(isRotated: card.rotateAnimation)
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
            if cards.count > 1 { adjustNextCardDealPoint(isRotated: card.rotateAnimation) }
            card.set(dealPoint: nextCardPoint)
        }
    }
    
    func adjustNextCardDealPoint(isRotated: Bool = false) {
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
        var dealPoint = CGPoint(x: self.nextCardPoint.x + Card.width * 1.2, y: self.originPoint.y)
        //if Settings.shared.landscape { // adjust depending on how many split hands
        //    dealPoint = CGPoint(x: self.originPoint.x - Card.width/2, y: self.originPoint.y)
        //}
        let newHand = Hand(dealToPoint: dealPoint, adjustmentX: self.adjustmentX, adjustmentY: self.adjustmentY, owner: self.owner)
        newHand.wasSplitFromHand = self
        newHand.betAmount = self.betAmount
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
        //let newHandIndex = max(index - 1, 0)
        owner.hands.insert(newHand, at: index)//newHandIndex)
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
        
        if valueLabelView == nil {
            let width: CGFloat = 45
            let height: CGFloat = 20
            let padding: CGFloat = 10
            let x: CGFloat = originPoint.x + Settings.shared.cardWidth * 0.5 - width/2//self.owner.isDealer ? originPoint.x + Settings.shared.cardWidth * 0.5 - width/2 : originPoint.x + Settings.shared.cardWidth * 0.5 - width/2
            valueLabelView = UILabel(frame: CGRect(x: x, y: originPoint.y + Card.height + padding, width: width, height: height))
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

extension Hand {
    static func getHand(for dealer: Dealer) -> Hand {
        return Hand(dealToPoint: Hand.dealerHandDealPoint, adjustmentX: dealerHandAdjustmentX , adjustmentY: dealerHandAdjustmentY, owner: dealer)
    }
    
    static var dealerHandDealPoint: CGPoint {
        var x = UIScreen.main.bounds.width/2 - Card.width * 0.6
        var y = 50.0
        if Settings.shared.showDiscardTray {
            if UIScreen.main.bounds.width / 2 < Card.width * 2 { // if 1/2 screen width is smaller than 2 card widths
                x = Card.width + 3
            }
        }
        if Settings.shared.landscape {
            x = UIScreen.main.bounds.width/2 - Card.width/2 + Card.width * 0.15
            y = UIScreen.main.bounds.height * 0.05
            if Settings.shared.verticalSizeClass == .regular {
                y = UIScreen.main.bounds.height * 0.10
            }
        }
        return CGPoint(x: x , y: y)
    }
    
    static var dealerHandAdjustmentX: CGFloat {
        var x = Card.width * 0.15
        if Settings.shared.landscape {
            x = Card.width * -0.15
        }
        return x
    }
    
    static var dealerHandAdjustmentXAfterReveal: CGFloat {
        var x = Card.width * 0.28
        if Settings.shared.landscape {
            x = Card.width * -1.1
        }
        return x
    }
    
    static var dealerHandAdjustmentY: CGFloat {
        return 0
    }
    
    static func getHand(for player: Player) -> Hand {
        return Hand(dealToPoint: Hand.getDealPoint(for: player), adjustmentX: playerAdjustmentX, adjustmentY: playerAdjustmentY, owner: player)
    }
    
    static func getPlayerHandDealPoint(numberOfHandsToAdjustBy: Int) -> CGPoint {
        var numberOfHandsAdjustment: CGFloat = 0
        numberOfHandsAdjustment -= CGFloat(numberOfHandsToAdjustBy) * (Card.width * 1.6)
        return  CGPoint(x: UIScreen.main.bounds.width/2 - Card.width * 0.7 + numberOfHandsAdjustment, y: UIScreen.main.bounds.height - Card.height - Card.height * 0.30)
    }
    
    static func getDealPoint(for player: Player) -> CGPoint {
        var numberOfHandsAdjustment: CGFloat = 0
        numberOfHandsAdjustment -= CGFloat(player.hands.count) * (Card.width * 1.6)
        return  CGPoint(x: UIScreen.main.bounds.width/2 - Card.width * 0.7 + numberOfHandsAdjustment, y: UIScreen.main.bounds.height - Card.height - Card.height * 0.30)
    }
    static var playerAdjustmentX: CGFloat {
        var adj = Card.height * 0.2
        if Settings.shared.landscape {
            adj = Card.height * 0.15
        }
        return adj
    }
    static var playerAdjustmentY: CGFloat {
        var adj = Card.height * 0.2
        if Settings.shared.landscape {
            adj = Card.height * 0.15
        }
        return adj
    }
    
    static func getDealPoint(for spotIndex: Int) -> CGPoint {
        var xS = [ 0.87, 0.85, 0.7, 0.5, 0.3, 0.15, 0.13]//[ 0.13, 0.15, 0.30, 0.50, 0.70, 0.85, 0.87]//.reversed()
        var yS = [35.0, 17.0, 5.0, 4.0, 5.0, 17.0, 35.0]
        if Settings.shared.verticalSizeClass == .compact {
            xS = [0.85, 0.68, 0.5, 0.32, 0.15]//.reversed()
            yS = [10.0, 3.0, 3.0, 3.0, 10.0]
        }
        
        let tableWidth = UIScreen.main.bounds.width
        let tableHeight = UIScreen.main.bounds.height
        return CGPoint(x: tableWidth * CGFloat(xS[spotIndex]) - Card.width * 0.5, y: tableHeight - Card.height - Card.height * 0.10 * yS[spotIndex])
    }
    
    static func getHand(for spot: Int, player: Player) -> Hand {
        let hand = Hand(dealToPoint: getDealPoint(for: spot), adjustmentX: playerAdjustmentX, adjustmentY: playerAdjustmentY, owner: player)
        return hand
    }
}
