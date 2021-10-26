//
//  Shoe.swift
//  BlackJackPracticeStrategyGame
//
//  Created by Jon on 9/2/21.
//

import Foundation

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
        for _ in 1...numberOfDecks {
            let deck = Deck()
            cards += deck.cards
        }
        cards.shuffle()
        print("shoe filled")
        CardCounter.shared.reset()
        if Settings.shared.showDiscardTray && table.discardTray.imageView != nil {
            table.discardTray.updateViews()
        }
    }
    
    func refill() {
        empty()
        fill()
    }
    
    func empty() {
        cards.removeAll()
        cardIndex = 0
        print("shoe emptied")
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
        // if deck penetration... would adjust this number here
        let value = CardCounter.shared.getNumberOfCardsLeft() < 17
        if value {
            print("Shoe should be refilled, i.e. less that 17 cards remaining")
        }
        // good place to shoe popup message syaing end of shoe, only show if freeplay
        
        return value
    }
    
    
}
