//
//  StrategyRound.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/19/21.
//

import Foundation

class StrategyRound {
    // player cards
    // dealer card
    // frequency
    // weight
    // # of times wrong action taken, etc.
    // current revelance - some kind of sum of factors
    // return player cards
    // return dealer cards
    // return weighted score for
    var playerCards: [CardValue] = []
    var dealerCards: [CardValue] = []
    var correctAction: StrategyAction = .hit
    
    init(playerCards: [CardValue], dealerCards: [CardValue], action: StrategyAction) {
        self.playerCards = playerCards
        self.dealerCards = dealerCards
        self.correctAction = action
    }
    
}

class StrategyDeck {
    // type two three four decks
    // collection of strategyrounds
    // logic to deliver next strategyround, based on score/weight
    var rounds: [StrategyRound] = []
    var roundIndex = 0
    
    func nextRound() -> StrategyRound {
        
        let round = rounds[roundIndex]
        roundIndex += 1
        if roundIndex > rounds.count - 1 {
            roundIndex = 0
        }
        return round
        
        
    }
}
