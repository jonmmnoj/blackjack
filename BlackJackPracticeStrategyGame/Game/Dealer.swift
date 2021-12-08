//
//  Dealer.swift
//  PrettyExample
//
//  Created by JON on 7/6/21.
//  Copyright © 2021 nlampi. All rights reserved.
//

import Foundation
import UIKit

class Dealer: Dealable {
    
    var players: [Player] = []
    //var numberOfDecks: Int = 1
    var shoe: Shoe
    private var shoeIndex: Int = 0
    var hands: [Hand] = []
    var activatedHand: Hand?
    var table: Table
    var isDealer = true
    var penetrationCard: Card?
    
    init(table: Table) { //, numberOfDecks: Int = 1) {
        self.table = table
        //for _ in 1...numberOfDecks { shoe.append(Deck() }
        self.shoe = Shoe(table: table)
    }
    
    func add(hand: Hand) {
        self.hands.removeAll()
        self.activatedHand = hand
        self.hands.append(hand)
    }
    
    func access(to player: Player) {
        players.append(player)
    }
    
    //var i = 0
    func dealCardToSelf() {
        let card = getCard()
//        var card = getCard()
//        if i == 0 {
//            card = Card(value: .ten, suit: .clubs)
//            i = 1
//        } else if i == 1 {
//            i = 0
//            card = Card(value: .ace, suit: .clubs)
//        }
        if self.activatedHand!.cards.count == 0 {
            card.isFaceDown = true
        }
        deal(card: card, to: self.activatedHand!)
    }
    
    func dealCardToPlayers() {
        players.forEach {
            deal(to: $0)
        }
    }
    
    //let values: [CardValue] = [.ten, .five]//, .five]
    //var i2 = 0
    func deal(to player: Player) {
        
        let hands = player.hands.reversed()
        hands.forEach {
        //    let card = getCard()
        //player.hands.forEach {
           let card = getCard()
//            var card = getCard()
//           if i2 == 0 {
//                card = Card(value: .ace, suit: .diamonds)
//                i2 += 1
//            } else if i2 == 1 {
//                //i2 += 1
//                card = Card(value: .nine, suit: .diamonds)
//                if i2 == 1 {
//                    i2 = 0
//                    //card = Card(value: .ten, suit: .diamonds)
//                }
//
//            }
           //let card = Card(value: values[i], suit: .diamonds); i += 1; if i > 1 { i = 0 };
            deal(card: card, to: $0)
        }
        
        // if 2 hand round...
            // player would have 2 hands, player.hands.count == 2
        // move to hand... deal card
            // to move to hand: keep track of which hand the dealer has moved to, or just always move to hand before a deal (less efficient but don't have to keep track of last hand moved to and don't have to compare)
        // move to next hand... deal card
        // move back to first hand... deal card
        // move to next hand... deal card
    }
    
    func dealtToAtLeast17() -> Void {
        while !Rules.isSoftOrHardSeventeenOrGreater(hand: self.activatedHand!) {
            let card = getCard()
            //card = Card(value: .eight, suit: .diamonds)
            self.deal(card: card, to: self.activatedHand!)
        }
        return
    }
    
    func deal(to hand: Hand, isDouble: Bool = false) {
        let card = getCard()
        //let card = Card(value: .two, suit: .diamonds)
        card.isDouble = isDouble
        if Settings.shared.dealDoubleFaceDown && isDouble && hand.value() <= 11 {
            card.isFaceDown = true
        }
        deal(card: card, to: hand)
    }
    
    func deal(card: Card, to hand: Hand, delay: Bool = true) {
        hand.add(card)
        table.animateDeal(card: card, delayAnimation: delay)
    }
    
    func getCard() -> Card {
        var card = shoe.takeCard()
        if card.isPenetrationCard {
            penetrationCard = card
            table.animateDeal(card: card, delayAnimation: true)
            card = shoe.takeCard()
        }
        return card
    }
    
    func discard(hand: Hand) {
        hand.cards.forEach {
            table.animateDiscard(card: $0)
        }
        hand.clearHand()
    }
    
    func discardPenetrationCard() {
        guard penetrationCard != nil else { return }
        table.animateDiscard(card: penetrationCard!)
        penetrationCard = nil
    }
    
    func checkBust(player: Player) -> Bool {
        return Rules.didBust(hand: player.activatedHand!)
    }
    
    func checkBust(hand: Hand) -> Bool {
        return Rules.didBust(hand: hand)
    }
    
    func handleBust(for player: Player) {
        discard(hand: player.hands.first!)
    }
    
    func handleBust(for hand: Hand) {
        hand.set(state: .bust)
        discard(hand: hand)
    }
    
    func splitHand(for hand: Hand) {
        let newHand = hand.createSplitHand()
        let cardToMove = newHand.cards.first!
        // check for move all hands to the right of this hand, first
        if let newHandIndex = players[0].index(of: newHand) {
            if newHandIndex < players[0].hands.count - 1 {
                table.moveAllCards(for: players[0], to: .left, startIndex: newHandIndex + 1)
            }
        }
        table.animateMove(card: cardToMove)
        let rotate = cardToMove.value == .ace
        dealCardsAfterSplit(newHand: newHand, otherHand: hand, rotate: rotate)
    }
    
    func dealCardsAfterSplit(newHand: Hand, otherHand: Hand, rotate: Bool = false) {
        let isSplitAce = newHand.cards.first!.value == .ace ? true : false
        if isSplitAce {
            newHand.set(state: .splitAces)
            otherHand.set(state: .splitAces)
        }
        var card = getCard()
        //var card = Card(value: .nine, suit: .diamonds)//
        if isSplitAce {
            card.rotateForSplitAce = true
        }
        deal(card: card, to: newHand)
        card = getCard()
        //card = Card(value: .ace, suit: .diamonds)
        if isSplitAce {
            card.rotateForSplitAce = true
        }
        deal(card: card, to: otherHand)
    }
    
    func revealCard() {
        let faceUpCard = self.activatedHand!.cards[1]
        faceUpCard.dealPoint = CGPoint(x: faceUpCard.dealPoint.x + Card.width * 0.85, y: faceUpCard.dealPoint.y)
        table.animateMove(card: faceUpCard)
        
        let faceDownCard = self.activatedHand!.cards.first!
        faceDownCard.isFaceDown = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5 * Settings.dealSpeedFactor) {
            self.table.animateReveal(card: faceDownCard)
        }
        
        //faceUpCard.dealPoint = CGPoint(x: faceUpCard.dealPoint.x - Card.width * 0.8, y: faceUpCard.dealPoint.y)
        //table.animateMove(card: faceUpCard)
        
    }
    
    func moveCardToNewPositionOnTable() {
        let card = self.activatedHand!.cards.last!
        self.activatedHand!.set(adjustmentX: Card.width * 0.28, adjustmentY: 0)//Settings.shared.cardSize * 0.2, adjustmentY: 0) //50
        self.activatedHand!.resetNextCardPoint()
        self.activatedHand!.adjustDealPoint()
        card.set(dealPoint: self.activatedHand!.nextCardPoint)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25 * Settings.dealSpeedFactor) {
            self.table.animateMove(card: card, isDelay: false)
        }
    }
    
    func moveCards(for player: Player, to direction: MoveCardsDirection) {
        table.moveAllCards(for: player, to: direction)
    }
    
    func indicateDealerIsReadyForPlayerInput(on hand: Hand) {
        table.showIndicator(on: hand)
    }
    
    func stopIndicator() {
        table.stopIndicator()
    }
}
