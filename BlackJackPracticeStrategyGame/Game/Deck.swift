//
//  Deck.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/6/21.
//

import Foundation

class Deck {
    private(set) var cards: [Card] = []
    private(set) var index: Int = 0
    private(set) var isEmpty: Bool = false
    
    init() {
        for suit in CardSuit.allCases {
            for value in CardValue.allCases {
                self.cards.append(Card(value: value, suit: suit))
            }
        }
        self.shuffle()
        //self.stackDeck()
    }
    
    func shuffle() {
        cards.shuffle()
        index = 0
        isEmpty = false
    }
    
    func nextCard() -> Card {
        let nextCard = cards[index]
        index += 1
        if index == cards.count {
            index = 0
            isEmpty = true
        }
        return nextCard
    }
    
    func cardsRemaining() -> Int {
        return isEmpty ? 0 : cards.count - index
    }
    
    func stackDeck() {
        var card = Card(value: .ten, suit: .clubs)
        self.cards.insert(card, at: 0)
        card = Card(value: .ten, suit: .clubs)
        self.cards.insert(card, at: 0)
        card = Card(value: .nine, suit: .clubs)
        self.cards.insert(card, at: 0)
        card = Card(value: .ace, suit: .clubs)
        self.cards.insert(card, at: 0)
        card = Card(value: .ace, suit: .clubs)
        self.cards.insert(card, at: 0)
        card = Card(value: .ace, suit: .clubs)
        self.cards.insert(card, at: 0)
        card = Card(value: .ten, suit: .clubs)
        self.cards.insert(card, at: 0)
        card = Card(value: .ten, suit: .clubs)
        self.cards.insert(card, at: 0)
        card = Card(value: .ten, suit: .clubs)
        self.cards.insert(card, at: 0)
        card = Card(value: .ace, suit: .clubs)
        self.cards.insert(card, at: 0)
        card = Card(value: .ace, suit: .clubs)
        self.cards.insert(card, at: 0)
        card = Card(value: .ace, suit: .clubs)
        self.cards.insert(card, at: 0)
    }
}
