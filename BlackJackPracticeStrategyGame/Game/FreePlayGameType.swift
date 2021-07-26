//
//  FreePlayGameType.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/21/21.
//

import Foundation

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
    }
    
    func inputReceived(type: PlayerAction) {
        switch type{
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
}
