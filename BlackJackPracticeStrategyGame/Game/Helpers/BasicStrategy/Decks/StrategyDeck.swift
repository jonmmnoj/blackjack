

//
//  StrategyDeck.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/26/21.
//
import Foundation

class StrategyDeck: NSObject {
    var deckType: StrategyDeckType
    var rounds: [StrategyRound] = []
    var roundIndex = 0
    
    init(type: StrategyDeckType) {
        self.deckType = type
    }
    
    func shuffle() {
        rounds.shuffle()
    }
    
    private func roundConformsToSettings(_ round: StrategyRound) -> Bool {
        let typeForRound = BasicStrategy.getRuleType(playerCardValues: round.playerCards)
        let typeOfHands: [RuleType] = Settings.getTypeOfHands()
        return typeOfHands.contains(typeForRound)
    }
    
    var lastRound: StrategyRound?
    func nextRound() -> StrategyRound {
        let round = rounds[roundIndex]
        updateRoundIndex()
        if !roundConformsToSettings(round) {
            return nextRound()
        }
        if lastRound != nil && lastRound == round {
            return nextRound()
        }
        return round
    }
    
    var lastDeviation: Deviation?
    func nextRoundThatIsDeviation() -> (StrategyRound, Deviation) {
        let round = rounds[roundIndex]
        updateRoundIndex()
        let type = BasicStrategy.getRuleType(playerCardValues: round.playerCards)
        let handValue = Rules.value(of: round.playerCards)
        
        let ruleValue = BasicStrategy.getPlayerRuleValue(rule: type, playerCardValues: round.playerCards)
        let rule = BasicStrategy.ruleLookup(type:type, dealerCardValue: round.dealerCards[0], playerRuleValue: ruleValue)
        
        let deviationType: DeviationType = Deviation.getType()
        
        let ruleDeviation = rule.deviations?.first(where: {$0.type == deviationType})
        let surrenderDeviation = rule.surrender?.deviations?.first(where: {$0.type == deviationType})
        
        if Settings.shared.surrender && rule.surrender?.isSurrender == true && surrenderDeviation == nil {
            return nextRoundThatIsDeviation()
        }
        
        let deviation = Settings.shared.surrender && surrenderDeviation != nil &&  round.playerCards.count == 2 ? surrenderDeviation : ruleDeviation
       
        if !roundConformsToSettings(round) || deviation == nil || (type == .hard && handValue < 8) || (type == .soft && round.playerCards.count > 2) || ((deviation!.action == .doubleStand || deviation!.action == .doubleHit) && round.playerCards.count > 2) {
            return nextRoundThatIsDeviation()
        }
        
        if lastDeviation != nil && lastDeviation == deviation {
            return nextRoundThatIsDeviation()
        }
        lastDeviation = deviation!
        
        return (round, deviation!)
    }
    
    private func updateRoundIndex() {
        roundIndex += 1
        if roundIndex > rounds.count - 1 {
            roundIndex = 0
            shuffle()
        }
    }
}
