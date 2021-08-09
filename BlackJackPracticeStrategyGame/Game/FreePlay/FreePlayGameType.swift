//
//  FreePlayGameType.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/21/21.
//

import Foundation
import UIKit

class FreePlayGameTypeStrategy: GameTypeStrategyPatternProtocol {
    
    
    var automaticPlay: Bool {
        return false
    }
    var gameMaster: GameMaster
    
    init(gameMaster: GameMaster) {
        self.gameMaster = gameMaster
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
            break
        }
    }
    
    func tasksForEndOfRound() {
        gameMaster.prepareForNewRound()
    }
    
    func waitForPlayerInput() {
        dealer.indicateDealerIsReadyForPlayerInput(on: player.activatedHand!)
        gameMaster.delegate.playerInput(enabled: true)
    }
}
