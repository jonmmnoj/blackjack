//
//  RunningCountGameType.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/21/21.
//

import UIKit

class RunningCount: FreePlayGameTypeStrategy {
    
    override init(gameMaster: GameMaster) {
        super.init(gameMaster: gameMaster)
    }
    
    override var automaticPlay: Bool {
        return true
    }
    
    override func waitForPlayerInput() {
        //DispatchQueue.main.asyncAfter(deadline: .now() + 0.25 * Settings.dealSpeedFactor) {
            let sAction = self.gameMaster.getPlayerAction()
            self.gameMaster.inputReceived(type: sAction.action)
        //}
    }
    
    override func tasksForEndOfRound() {
        if countMaster.isTimeToAskForCount() {
            countMaster.endOfRoundTasks(gameMaster: gameMaster, completion: {
                self.gameMaster.prepareForNewRound()
            })
        } else {
            gameMaster.prepareForNewRound()
        }
    }
    
    override func dealCards() {
            dealer.dealCardToPlayers()
            dealer.dealCardToSelf()
            dealer.dealCardToPlayers()
            dealer.dealCardToSelf()
            gameMaster.gameState = .dealtCards
    }
    
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
