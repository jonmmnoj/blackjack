//
//  StrategyRound.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/19/21.
//

import Foundation

class StrategyRound {
    var playerCards: [Int] = []
    var dealerCards: [Int] = []
    var correctAction: StrategyAction = .hit
    
    init(playerCards: [Int], dealerCards: [Int], action: StrategyAction) {
        self.playerCards = playerCards
        self.dealerCards = dealerCards
        self.correctAction = action
    }
}

extension StrategyRound: Equatable {
    static func == (lhs: StrategyRound, rhs: StrategyRound) -> Bool {
        return
            lhs.playerCards == rhs.playerCards &&
            lhs.dealerCards == rhs.dealerCards &&
            lhs.correctAction == rhs.correctAction
    }
}
