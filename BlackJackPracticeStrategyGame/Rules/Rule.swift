//
//  Rule.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/19/21.
//

import Foundation

class Rule {
    var type: RuleType
    var dealerCardValue: Int
    var playerRuleValue: Int // derives from the type of rule and player's hand, eg. .hard is the sum of the player's cards, whereas .soft is just the player's non-ace card.
    var action: StrategyAction
    var deviation: Deviation?
    
    init(type: RuleType, dealerCardValue: Int, playerRuleValue: Int, action: StrategyAction, deviation: Deviation? = nil) {
        self.type = type
        self.dealerCardValue = dealerCardValue
        self.playerRuleValue = playerRuleValue
        self.action = action
        self.deviation = deviation
    }
    
    func isMatch(dealerCardValue: Int, playerRuleValue: Int) -> Bool {
        return dealerCardValue == self.dealerCardValue && playerRuleValue == self.playerRuleValue
    }
    
//    func isMatch(dealerCard: Int, playerCards: [Int], action: StrategyAction) -> Bool {
//        return dealerCard == self.dealerCard && playerCards.elementsEqual(self.playerCards) && action == self.action
//    }
}
