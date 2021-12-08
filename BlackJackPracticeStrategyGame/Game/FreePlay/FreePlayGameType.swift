//
//  FreePlayGameType.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/21/21.
//

import Foundation
import UIKit

class FreePlayGameTypeStrategy: GameTypeStrategyPatternProtocol {
    var countMaster = CountMaster()
    
    var automaticPlay: Bool {
        return false
    }
    var gameMaster: GameMaster
    
    init(gameMaster: GameMaster) {
        self.gameMaster = gameMaster
        countMaster.gameMaster = gameMaster
    }
    
    func dealCards() {
        dealer.dealCardToPlayers()
        dealer.dealCardToSelf()
        dealer.dealCardToPlayers()
        dealer.dealCardToSelf()
        gameMaster.gameState = .askInsurance
    }
    
    private func updateStats(_ sa: StrategyAction, action: PlayerAction) {
        let type = sa.isDeviation ? DecisionType.deviation : DecisionType.basicStrategy
        var basedOn = gameMaster.getStringOfPlayerAndDealerHandValue()
        if sa.isDeviation {
            basedOn += " @ TC \(CardCounter.shared.getTrueCount())"
        }
        let decision = Decision(type: type, isCorrect: action == sa.action, yourAnswer: action.rawValue.uppercased(), correctAnswer: sa.action.rawValue.uppercased(), decisionBasedOn: basedOn)
        Stats.shared.update(decision: decision)
    }
    
    func inputReceived(action: PlayerAction) {
        let correctStrategyAction = gameMaster.getPlayerAction()
        let right = action == correctStrategyAction.action
        updateStats(correctStrategyAction, action: action)
        if !right && Settings.shared.notifyMistakes {
            
            let message = "You want to \(action.rawValue.uppercased()) \nCorrect strategy is \(correctStrategyAction.action.rawValue.uppercased())"
            PlayError.notifyMistake(gameMaster.delegate, message: message, completion: { fix in
                if fix {
                    self.gameMaster.waitForPlayerInput()
                } else {
                    self.accept(action)
                }})
        } else {
            accept(action)
        }
    }
    
    private func accept(_ action: PlayerAction) {
        switch action{
        case .hit:
            gameMaster.playerHits()
        case .stand:
            gameMaster.playerStands()
        case .double:
            gameMaster.playerDoubles()
        case .split:
            gameMaster.playerSplits()
        case .surrender:
            gameMaster.playerSurrenders()
        case .doubleHit, .doubleStand, .splitIfDAS, .doNotSplit:
            break
        }
    }
    
    func tasksForEndOfRound() {
        if countMaster.isTimeToAskForCount() {
            countMaster.endOfRoundTasks(gameMaster: gameMaster, completion: {
                self.gameMaster.prepareForNewRound()
            })
        } else {
            gameMaster.prepareForNewRound()
        }
    }
    
    func waitForPlayerInput() {
        if gameMaster.player.activatedHand!.isGhostHand {
            let sAction = self.gameMaster.getPlayerAction()
            self.gameMaster.inputReceived(type: sAction.action)
        } else {
            dealer.indicateDealerIsReadyForPlayerInput(on: player.activatedHand!)
            gameMaster.delegate.playerInput(enabled: true)
        }
    }
}
