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
    var nextCardIndex: Int = 0
    var penCardDealt = false
    
    init(table: Table) {
        self.table = table
        fill()
    }
    
    func nextCardIsPenetrationCard() -> Bool {
        for (i, card) in cards.enumerated() {
            if card.isPenetrationCard {
                if i == nextCardIndex { return true }
            }
        }
        return false
    }
    
    private func fill() {
        addCardsToShoe()
        addPenetrationCard()
        CardCounter.shared.reset()
//        if Settings.shared.showDiscardTray && table.discardTray.imageView != nil {
//            table.discardTray.updateViews()
//        }
    }
    
    private func addCardsToShoe() {
        for _ in 1...numberOfDecks {
            let deck = Deck()
            cards += deck.cards
        }
        cards.shuffle()
    }
    
    var penetrationCardIndex: Int!
    private func addPenetrationCard() {
        guard Settings.shared.gameType == .freePlay else { return }
        var cardLocation = Double(numberOfDecks) * 52.0 * Settings.shared.penetration
        cardLocation.round()
        let card = Penetration.card
        //card.set(dealPoint: CGPoint(x: table.view.center.x - Card.width * 1.5, y: table.view.center.y - Card.height * 1))
        if Settings.shared.landscape {
            let x = Hand.dealerHandDealPoint.x + Card.width * 2.2
            var y = Hand.dealerHandDealPoint.y - Card.height * 0.2
            if Settings.shared.verticalSizeClass == .compact {
                y = Hand.dealerHandDealPoint.y - Card.height * 0
            }
            card.set(dealPoint: CGPoint(x: x, y: y))
        } else {
            card.set(dealPoint: CGPoint(x: 0 + Card.width * 1.5, y: 0 + Card.height * 1.5))
        }
        penetrationCardIndex = Int(cardLocation) - 1
        cards.insert(card, at: penetrationCardIndex)
        //print("pen card index \(penetrationCardIndex)")
        penCardDealt = false
    }
    
    func refill() {
        emptyShoe()
        fill()
        updateDiscardTray()
    }
    
    private func updateDiscardTray() {
        if Settings.shared.showDiscardTray && table.discardTray.imageView != nil {
            table.discardTray.updateViews()
        }
    }
    
    private func emptyShoe() {
        cards.removeAll()
        nextCardIndex = 0
    }
    
    func takeCard() -> Card {
        let trueCountThreshold = 6
        if Settings.shared.gameType == .freePlay && Settings.shared.countBias && !cards[nextCardIndex].isPenetrationCard && CardCounter.shared.getTrueCount() < trueCountThreshold {
            countBias()
        }
        
        let card = cards[nextCardIndex]
        nextCardIndex += 1
        if nextCardIndex > cards.count - 1 {
           refill()
        }
        if card.isPenetrationCard { penCardDealt = true }
        return card
    }
    
    func countBias() {
        let num = Int.random(in: 1...10)
        if num > 5 { // higher number will reduce speed to reach bias level
          let lowCardValues: [CardValue] = [.two, .three, .four, .five, .six]
          while (true) {
              if !cards.contains(where: { lowCardValues.contains($0.value) }) {
                  break
              }
              let randomIndex = Int.random(in: nextCardIndex...cards.count - 1)
              let card = cards[randomIndex]
              if [.two, .three, .four, .five, .six].contains(card.value) {
                  cards.remove(at: randomIndex)
                  cards.insert(card, at: nextCardIndex)
                  if randomIndex > penetrationCardIndex {
                      adjustmentForPenetrationCard()
                  }
                  break
              }
          }
        }
    }
    
    
//    func whereIsPenCard() {
//        for (i, card) in cards.enumerated() {
//            if card.isPenetrationCard {
//                //print("pen card is at this index \(i)")
//            }
//        }
//    }
    
    func adjustmentForPenetrationCard() {
        for (i, card) in cards.enumerated() {
            if card.isPenetrationCard {
                let removedCard = cards.remove(at: i)
                cards.insert(removedCard, at: penetrationCardIndex)
            }
        }
    }
    
    func isTimeToRefillShoe() -> Bool {
        let numberOfDecks = Settings.shared.numberOfDecks
        let totalNumberOfCards = numberOfDecks * 52
        var penetrationPercent = Double(totalNumberOfCards - CardCounter.shared.getNumberOfCardsLeft()) / Double(totalNumberOfCards)
        penetrationPercent = round(penetrationPercent * 100.0) / 100 // round to hundreths
        //print("Pen %: \(penetrationPercent)")
        let isTimeToShuffle = penetrationPercent >= Settings.shared.penetration
        let shuffleToAvoidShuffleDuringRound = CardCounter.shared.getNumberOfCardsLeft() < 17
        return penCardDealt //|| isTimeToShuffle ? isTimeToShuffle : shuffleToAvoidShuffleDuringRound
    }
}
