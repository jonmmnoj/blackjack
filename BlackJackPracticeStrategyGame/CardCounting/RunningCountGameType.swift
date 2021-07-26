//
//  RunningCountGameType.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/21/21.
//

import Foundation

class RunningCount: FreePlayGameTypeStrategy {
    var countMaster = CountMaster()
    
    override init(gameMaster: GameMaster) {
        super.init(gameMaster: gameMaster)
        countMaster.delegate = gameMaster.delegate
    }
    
    override var automaticPlay: Bool {
        return true
    }
    
    override func tasksForEndOfRound() {
        if  countMaster.isTimeToAskForCount() {
            countMaster.endOfRoundTasks(gameMaster: gameMaster, completion: {
                self.gameMaster.prepareForNewRound()
            })// let countMaster call back to GameMaster when task is complete
            //print("GM waiting on CM")
        } else {
            gameMaster.prepareForNewRound()
        }
    }
    
}
