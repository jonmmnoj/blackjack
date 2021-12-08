//
//  Shoe.swift
//  BlackJackPracticeStrategyGame
//
//  Created by Jon on 9/2/21.
//

import UIKit

class Shoe {
    var table: Table
    var cards: [Card] = []
    var numberOfDecks = Settings.shared.numberOfDecks
    var cardIndex: Int = 0
    
    init(table: Table) {
        self.table = table
        fill()
    }
    
    func fill() {
        addCardsToShoe()
        addPenetrationCard()
        CardCounter.shared.reset()
        if Settings.shared.showDiscardTray && table.discardTray.imageView != nil {
            table.discardTray.updateViews()
        }
    }
    
    private func addCardsToShoe() {
        for _ in 1...numberOfDecks {
            let deck = Deck()
            cards += deck.cards
        }
        cards.shuffle()
    }
    
    private func addPenetrationCard() {
        var cardLocation = Double(numberOfDecks) * 52.0 * Settings.shared.penetration
        cardLocation.round()
        let card = Penetration.redCard
        card.set(dealPoint: CGPoint(x: table.view.center.x - Card.width * 1.5, y: table.view.center.y - Card.height * 1))
        cards.insert(card, at: Int(cardLocation) - 1)
    }
    
    func refill() {
        empty()
        fill()
    }
    
    func empty() {
        cards.removeAll()
        cardIndex = 0
    }
    
    func takeCard() -> Card {
        let card = cards[cardIndex]
        cardIndex += 1
        if cardIndex > cards.count - 1 {
           refill()
        }
        return card
    }
    
    func isTimeToRefillShoe() -> Bool {
        let numberOfDecks = Settings.shared.numberOfDecks
        let totalNumberOfCards = numberOfDecks * 52
        var penetrationPercent = Double(totalNumberOfCards - CardCounter.shared.getNumberOfCardsLeft()) / Double(totalNumberOfCards)
        penetrationPercent = round(penetrationPercent * 100.0) / 100 // round to hundreths
        //print("Pen %: \(penetrationPercent)")
        let isTimeToShuffle = penetrationPercent >= Settings.shared.penetration
        let shuffleToAvoidShuffleDuringRound = CardCounter.shared.getNumberOfCardsLeft() < 17
        return isTimeToShuffle ? isTimeToShuffle : shuffleToAvoidShuffleDuringRound
    }
}
