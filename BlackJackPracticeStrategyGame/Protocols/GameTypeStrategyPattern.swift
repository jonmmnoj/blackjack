//
//  GameTypeStrategyPattern.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/21/21.
//

import Foundation


protocol GameTypeStrategyPatternProtocol {
    var automaticPlay: Bool { get }
    var gameMaster: GameMaster { get set }
    //var automaticPlay: Bool { get set }
    func dealCards()
    //waitForPlayerInput()
    func inputReceived(action: PlayerAction)
    func tasksForEndOfRound()
    func waitForPlayerInput()
}

extension GameTypeStrategyPatternProtocol {
    var dealer: Dealer {
        return gameMaster.dealer
    }
    var player: Player {
        return gameMaster.player
    }
    var automaticPlay: Bool {
        return false
    }
    
}
