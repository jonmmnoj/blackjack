//
//  BasicStrategy.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/11/21.
//

import Foundation


class BasicStrategy {
    static func getStrategyAction(dealerCardValue: Int, playerCardValues: [Int]) -> StrategyAction {
        let ruleType = BasicStrategy.getRuleType(playerCardValues: playerCardValues)
        let playerRuleValue = getPlayerRuleValue(rule: ruleType, playerCardValues: playerCardValues)
        return getStrategyAction(for: ruleType, dealerCardValue: dealerCardValue, playerRuleValue: playerRuleValue, numberOfPlayerCards: playerCardValues.count)
    }
    
    static private func getStrategyAction(for type: RuleType, dealerCardValue: Int, playerRuleValue: Int, numberOfPlayerCards: Int) -> StrategyAction {
        var action: StrategyAction!
        let rules = type == .pair ? pairRules : type == .soft ? softRules : hardRules
        for rule in rules {
            if rule.isMatch(dealerCardValue: dealerCardValue, playerRuleValue: playerRuleValue) {
                // first, check if the rule has surrender logic (and the player can surrender), if not, then check if it has deviation logic, if not, then return rule's action
                if Settings.shared.surrender && numberOfPlayerCards == 2 {
                    if let surrender = rule.surrender {
                        if let deviation = surrender.getDeviation() {
                            if CardCounter.shared.doesDeviationApply(deviation) {
                                action = deviation.action
                                break
                            }
                        }
                        if surrender.isSurrender {
                            action = .surrender
                            break
                        }
                        action = rule.action
                        break
                    }
                }
                if Settings.shared.deviations {
                    if let deviation = rule.getDeviation() {
                        if CardCounter.shared.doesDeviationApply(deviation) {
                            action = deviation.action
                            break
                        }
                    }
                }
                // if the rule gets to this point, then it does not have surrender or deviation logic.
                action = rule.action
                break
            }
        }
        return action
    }
    
    // this method returns an action that the player can actually input into the game, ie. it is not "doNotSplit"... or... "doubleStand"... "doubleHit"... etc., Rather, the action is one of the following: stand, hit, split, double, surrender.
    static func getPlayerAction(dealerCardValue: Int, playerCardValues: [Int]) -> StrategyAction {
        let ruleType = BasicStrategy.getRuleType(playerCardValues: playerCardValues)
        let playerRuleValue = getPlayerRuleValue(rule: ruleType, playerCardValues: playerCardValues)
        return getPlayerAction(ruleType: ruleType, dealerCardValue: dealerCardValue, playerRuleValue: playerRuleValue, playerCardValues: playerCardValues)
    }
    
    // this method will keep converting strategyaction until it is an actionalbe result... ie hit, stand, double, split, surrender. Not all strategyAction are actionable, eg. doNotSplit, doubleHit...that isn't specific enough fro the game's user input options.
    
    static private func getPlayerAction(ruleType: RuleType, dealerCardValue: Int, playerRuleValue: Int,  playerCardValues: [Int]) -> StrategyAction {
        var action: StrategyAction!
        let strategyAction = getStrategyAction(for: ruleType, dealerCardValue: dealerCardValue, playerRuleValue: playerRuleValue, numberOfPlayerCards: playerCardValues.count)
    
        if strategyAction == .doNotSplit {
            let doubledPlayerRuleValue = double(playerRuleValue: playerRuleValue)
            return getPlayerAction(ruleType: .hard, dealerCardValue: dealerCardValue, playerRuleValue: doubledPlayerRuleValue, playerCardValues: playerCardValues)
        } else if strategyAction == .splitIfDAS {
            if Settings.shared.doubleAfterSplit {
                action = .split
            } else {
                let doubledPlayerRuleValue = double(playerRuleValue: playerRuleValue)
                return getPlayerAction(ruleType: .hard, dealerCardValue: dealerCardValue, playerRuleValue: doubledPlayerRuleValue, playerCardValues: playerCardValues)
            }
        }
        else if strategyAction == .doubleHit {
            if playerCardValues.count == 2 {
                return .double
            } else {
                return .hit
            }
        }
        else if strategyAction == .doubleStand {
            if playerCardValues.count == 2 {
                return .double
            } else {
                return .stand
            }
        }
        else {
            action = strategyAction
        }
        
        return action
    }
    
    static private func double(playerRuleValue value: Int) -> Int {
        var doubledValue = value * 2
        if doubledValue > 17 { doubledValue = 18 } // 9,9 or T,T
        if doubledValue < 8 { doubledValue = 7 } // 2,2 or 3,3
        return doubledValue
    }
    
    static func getRuleType(playerCardValues: [Int]) -> RuleType {
        var ruleType: RuleType!
        if playerCardValues.count == 2 {
            if playerCardValues.first == playerCardValues.last {
                ruleType = .pair
            } else if playerCardValues.contains(1) {
                ruleType = .soft
            } else {
                ruleType = .hard
            }
        } else if playerCardValues.contains(1) {
            var total = 0
            var skippedFirstAce = false
            for value in playerCardValues {
                if value == 1 {
                    if !skippedFirstAce {
                        skippedFirstAce = true
                    } else {
                        total += value
                    }
                } else {
                    total += value
                }
            }
            ruleType = total > 10 ? .hard : .soft
        } else {
            ruleType = .hard
        }
        return ruleType
    }
    
    // this is the value used for the Rule... ie a hard hand's value is teh sum of the cards, whereas a split hand's value is the just the value of one of the cards. and a soft hand is just the value of the non-ace card.
    static func getPlayerRuleValue(rule: RuleType, playerCardValues: [Int]) -> Int {
        var playerRuleValue: Int!
        if rule == .pair {
            playerRuleValue = playerCardValues.first
        } else if rule == .soft {
            playerRuleValue = playerCardValues.reduce(0, +) - 1
        } else {
           // hard
            playerRuleValue = playerCardValues.reduce(0, +)
            if playerRuleValue > 17 { playerRuleValue = 17 }
            if playerRuleValue < 8 { playerRuleValue = 8 }
        }
        return playerRuleValue
    }
}
