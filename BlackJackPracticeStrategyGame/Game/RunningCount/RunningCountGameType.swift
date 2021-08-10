//
//  RunningCountGameType.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/21/21.
//

import Foundation

class RunningCount: FreePlayGameTypeStrategy {
    
    override init(gameMaster: GameMaster) {
        super.init(gameMaster: gameMaster)
    }
    
    override var automaticPlay: Bool {
        return true
    }
    
    override func waitForPlayerInput() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let pAction = self.gameMaster.getPlayerAction()
            self.gameMaster.inputReceived(type: pAction)
        }
    }
    
    // Before discarding all... ask for running count?
    
    
    
    /* Ideas/Notes for dealing cards one/two/three,etc at a time, instead of dealing liek a real game...
     
     In settings, have option to "How to deal cards..." One card, Two cards, Three cards, etc, Simulate Game (like a real game),
     
     if deal one card at a time, or two, and not like a real game...
       have to override dealCards().. then deal as many cards to player as needed
        until the deck or shoe is one card short... then ask for count...
       to ask for count... change logic for waitForPlayerInput()
     ... need to call taskAtEndOfRound() and get input for running count...
     ... then start new round, ie return to dealCards()
    */
}
