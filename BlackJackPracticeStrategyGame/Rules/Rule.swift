//
//  Rule.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/19/21.
//

class Rule {
    var type: RuleType
    var dealerCardValue: Int
    var playerRuleValue: Int
    var action: PlayerAction
    var deviations: [Deviation]?
    var surrender: Surrender?
    
    init(type: RuleType, dealerCardValue: Int, playerRuleValue: Int, action: PlayerAction, deviations: [Deviation]? = nil, surrender: Surrender? = nil) {
        self.type = type
        self.dealerCardValue = dealerCardValue
        self.playerRuleValue = playerRuleValue
        self.action = action
        self.deviations = deviations
        self.surrender = surrender
    }
    
    func isMatch(dealerCardValue: Int, playerRuleValue: Int) -> Bool {
        return dealerCardValue == self.dealerCardValue && playerRuleValue == self.playerRuleValue
    }
    
    func getDeviation() -> Deviation? {
        var deviation: Deviation?
        var deviations: [Deviation] = []
        self.deviations?.forEach {
            if $0.type == Deviation.getType() {
                deviations.append($0)
            }
        }
        let nilDeviation = deviations.first(where: { $0.count == nil })
        if nilDeviation != nil {
            deviation = nilDeviation
        }
        let countDependentDeviation = deviations.first(where: { $0.count != nil })
        if countDependentDeviation != nil && CardCounter.shared.doesDeviationApply(countDependentDeviation!) {
            deviation = countDependentDeviation
        }
        return deviation
    }
}
