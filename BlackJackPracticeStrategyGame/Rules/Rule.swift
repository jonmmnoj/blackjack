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
    var playerRuleValue: Int
    var action: StrategyAction
    var deviations: [Deviation]?
    var surrender: Surrender?
    
    init(type: RuleType, dealerCardValue: Int, playerRuleValue: Int, action: StrategyAction, deviations: [Deviation]? = nil, surrender: Surrender? = nil) {
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
//        if let surrender = self.surrender, let deviations = surrender.deviations, let deviation = deviations.first(where: { $0.type == Deviation.getType() }) {
//            return deviation
//        } else {
            deviation = self.deviations?.first(where: { $0.type == Deviation.getType() })
            return deviation
        //}
    }
    
    func getDeviation(numberOfCards: Int) -> Deviation? {
        var surrenderDeviation: Deviation?
        var ruleDeviation: Deviation?
        if let surrender = self.surrender, let deviations = surrender.deviations, let deviation = deviations.first(where: { $0.type == Deviation.getType() }) {
            //return deviation
            surrenderDeviation = deviation
       }
        if let deviation = self.deviations?.first(where: { $0.type == Deviation.getType() }) {
            //return deviation
            ruleDeviation = deviation
        }
        
        return Settings.shared.surrender && numberOfCards == 2 ? surrenderDeviation : ruleDeviation
    }
}

class Surrender {
    var isSurrender: Bool
    var deviations: [Deviation]?
    
    init(_ isSurrender: Bool, deviations: [Deviation]? = nil) {
        self.isSurrender = isSurrender
        self.deviations = deviations
    }
    
    func getDeviation() -> Deviation? {
        var deviation: Deviation?
        deviation = self.deviations?.first(where: { $0.type == Deviation.getType() })
        return deviation
        
    }
}


class Deviation {
    var type: DeviationType
    var count: Int?
    var direction: String?
    var action: StrategyAction
    
    init(type: DeviationType, count: Int?, direction: String?, action: StrategyAction) {
        self.type = type
        self.count = count
        self.direction = direction
        self.action = action
    }
    
    func doesApply() -> Bool {
        // get true/running count and compare to self.count
        return false
    }
    func getSign() -> String? {
        return direction
    }
    func getCount() -> Int? {
        return count
    }
    
    func getAction(numberOfPlayerCards num: Int) -> StrategyAction {
        if self.action == .doubleStand {
            if num > 2 {
                return .stand
            } else {
                return .double
            }
        }
        return self.action
    }
    
    static func getType() -> DeviationType {
        let dealerHitsSoft17 = Settings.shared.dealerHitsSoft17
        let enhc = Settings.shared.ENHC
        let surrender = Settings.shared.surrender
        let type: DeviationType = dealerHitsSoft17 ? .hard17 : .soft17
        return type
    }
}
