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
    private var shoe: [Deck] = []
    private var shoeIndex: Int = 0
    var hands: [Hand] = [] // dealer only has one had so this is not the best design
    var activatedHand: Hand?
    var table: Table
    
    init(table: Table, numberOfDecks: Int = 1) {
        self.table = table
        for _ in 1...numberOfDecks { shoe.append(Deck()) }
    }
    
    func add(hand: Hand) {
        self.activatedHand = hand
    }
    
    func access(to player: Player) {
        players.append(player)
    }
    
    func dealCardToSelf() {
        let card = getCard()
        if self.activatedHand!.cards.count == 0 {
            card.isFaceDown = true
        }
        deal(card: card, to: self.activatedHand!)
    }
    
    func dealToHard17() -> Void {
        while !Rules.isHardSeventeenOrGreater(hand: self.activatedHand!) {
            let card = getCard()
            self.deal(card: card, to: self.activatedHand!)
        }
        return
    }
    
    func dealCardToPlayers() {
        players.forEach {
            deal(to: $0)
        }
    }
    
    func deal(to player: Player) {
        player.hands.forEach {
           let card = getCard()
            //let card = getTen()
            deal(card: card, to: $0)
        }
    }
    
    func deal(to hand: Hand, isDouble: Bool = false) {
        let card = getCard()
        card.isDouble = isDouble
        deal(card: card, to: hand)
    }
    
    func deal(card: Card, to hand: Hand, delay: Bool = true) {
        //CardCounter.shared.count(card: card)
        hand.add(card)
        table.animateDeal(card: card, delayAnimation: delay)
    }
    
    func getCard() -> Card {
        manageShoe()
        return shoe[shoeIndex].nextCard()
    }
    
    func manageShoe() {
        if shoe[shoeIndex].isEmpty {
            shoeIndex += 1
        }
        if shoeIndex > shoe.count - 1 {
            refillShoe()
        }
    }
    
    func refillShoe() {
        print("refill shoe...ie. cleared decks array and append new deck")
        shoe = []
        for _ in 1...1 { shoe.append(Deck()) }
        shoeIndex = 0
    }
    
    func discard(hand: Hand) {
        hand.cards.forEach {
            table.animateDiscard(card: $0)
        }
        hand.clearHand()
    }
    
    func checkBust(player: Player) -> Bool {
        return Rules.didBust(hand: player.activatedHand!)
    }
    
    func checkBust(hand: Hand) -> Bool {
        return Rules.didBust(hand: hand)
    }
    
    func handleBust(for player: Player) {
        print("Player Bust")
        discard(hand: player.hands.first!)
    }
    
    func handleBust(for hand: Hand) {
        print("Hand Bust")
        hand.set(state: .bust)
        discard(hand: hand)
    }
    
    func splitHand(for hand: Hand) {
        let newHand = hand.createSplitHand()
        let cardToMove = newHand.cards.first!
        table.animateMove(card: cardToMove)
        let rotate = cardToMove.value == .ace
        dealCardsAfterSplit(newHand: newHand, otherHand: hand, rotate: rotate)
    }
    
    func dealCardsAfterSplit(newHand: Hand, otherHand: Hand, rotate: Bool = false) {
        var card = getCard()
        //var card = getAce()
        deal(card: card, to: newHand)
        card = getCard()
        //card = getAce()
        deal(card: card, to: otherHand)
    }
    
    func revealCard() {
        let card = self.activatedHand!.cards.first!
        card.isFaceDown = false
        //CardCounter.shared.count(card: card)
        table.animateReveal(card: card)
    }
    
    func moveCardToNewPositionOnTable() {
        let card = self.activatedHand!.cards.last!
        self.activatedHand!.set(adjustmentX: 50, adjustmentY: 0)
        self.activatedHand!.resetNextCardPoint()
        self.activatedHand!.adjustDealPoint()
        card.set(dealPoint: self.activatedHand!.nextCardPoint)
        table.animateMove(card: card)
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
