//
//  CountMaster.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/15/21.
//

import Foundation
import UIKit



class CountMaster {
    var numberOfRoundsPlayed: Int // notify when setting changes? to reset?
    var delegate: GameViewDelegate!
    var cardCounter = CardCounter.shared
    var gameMaster: GameMaster?
    var taskComplete: (() -> Void)!
    
    init() {
        numberOfRoundsPlayed = 0
    }
    
    func isTimeToAskForCount() -> Bool {
        numberOfRoundsPlayed += 1
        let setting = Settings.shared.askForCountAfterRounds.numericValue
        if setting == 0 { return false }
        return numberOfRoundsPlayed % setting == 0
    }
    
    func endOfRoundTasks(gameMaster: GameMaster, completion: @escaping () -> Void) {
        //self.gameMaster = gameMaster // needed to call back to GM when count task is done
        taskComplete = completion
        presentViewToGetUserCount()
    }
    
    func presentViewToGetUserCount() {
        //var count: Int?
        delegate.presentCountInputView(countMaster: self) { (inputValue) in
            //count = inputValue
        }
    }
    
    func userInput(value: Int, completion: (Bool, Int, Int) -> ()) {
        print("User input: \(value), Actual Count: \(cardCounter.count)")
        let isCorrect = value == cardCounter.count
        completion(isCorrect, value, cardCounter.count) 
    }
    
    func dismissCountView() {
        delegate.dismissCountInputView() {
            //self.gameMaster!.prepareForNewRound()
            taskComplete()
        }
    }
}
