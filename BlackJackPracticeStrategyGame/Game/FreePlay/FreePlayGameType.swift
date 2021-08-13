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
        countMaster.delegate = gameMaster.delegate
        countMaster.gameMaster = gameMaster
    }
    
    func dealCards() {
        dealer.dealCardToPlayers()
        dealer.dealCardToSelf()
        dealer.dealCardToPlayers()
        dealer.dealCardToSelf()
        //dealer.dealCardToPlayers()
    }
    
    func inputReceived(action: PlayerAction) {
        let correctAction = gameMaster.getPlayerAction()
        if action != correctAction && Settings.shared.notifyMistakes {
            gameMaster.delegate.alertMistake(message: "You want to \(action.rawValue.uppercased()) \nCorrect strategy is \(correctAction.rawValue.uppercased())", completion: { fix in
                if fix {
                    self.gameMaster.waitForPlayerInput()
                } else {
                    self.accept(action)
                }
            })
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
        }
    }
    
    func tasksForEndOfRound() {
        
        
        if Settings.shared.defaults.freePlayAskForCount && countMaster.isTimeToAskForCount() {
            countMaster.endOfRoundTasks(gameMaster: gameMaster, completion: {
                self.gameMaster.prepareForNewRound()
            })// let countMaster call back to GameMaster when task is complete
            //print("GM waiting on CM")
        } else {
            gameMaster.prepareForNewRound()
        }
    }
    
    func waitForPlayerInput() {
        dealer.indicateDealerIsReadyForPlayerInput(on: player.activatedHand!)
        gameMaster.delegate.playerInput(enabled: true)
    }
}
