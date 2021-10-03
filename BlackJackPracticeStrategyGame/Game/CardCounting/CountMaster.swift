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
        let value = Settings.shared.gameType == .freePlay ? Settings.shared.numberOfRoundsBeforeAskTrueCount : Settings.shared.numberOfRoundsBeforeAskRunningCount
        let setting = CountRounds(rawValue: value)?.numericValue ?? 0
        if setting == 0 { // TODO: at end of shoe or end game
            
            if gameMaster!.dealer.shoe.isTimeToRefillShoe() {
                return true
            }
            
            return false
            
        }
        return numberOfRoundsPlayed % setting == 0
    }
    
    func endOfRoundTasks(gameMaster: GameMaster, completion: @escaping () -> Void) {
        //self.gameMaster = gameMaster // needed to call back to GM when count task is done
        self.taskComplete = completion
        presentViewToGetUserCount()
    }
    
    func presentViewToGetUserCount() {
        let gameType = Settings.shared.gameType!
        let inputView = DeviationInputView(frame: .zero, gameType: gameType)
            inputView.runningCountSubmitHandler = { inputRC in
                let correctCount = gameType == .runningCount ? self.cardCounter.runningCount : self.cardCounter.getTrueCount()
                let isInputCorrect = inputRC == correctCount
                self.gameMaster!.delegate.presentBasicStrategyFeedbackView(isCorrect: isInputCorrect, playerAction: String(inputRC), correctAction: String(correctCount)) {
                    self.taskComplete()
                }
                inputView.removeFromSuperview()
        }
        
        let tableView = gameMaster!.tableView
        tableView.addSubview(inputView)
        inputView.snp.makeConstraints { make in
            make.center.equalTo(tableView)
            make.width.greaterThanOrEqualTo(tableView.snp.width).offset(-50)
            //make.left.equalTo(table)(50)
            // make.right.equalTo(table).offset(-50)
            make.height.lessThanOrEqualTo(250)
        }
    }
    
    func userInput(value: Int, completion: (Bool, Int, Int) -> ()) {
        print("User input: \(value), Actual Count: \(cardCounter.runningCount)")
        let isCorrect = value == cardCounter.runningCount
        completion(isCorrect, value, cardCounter.runningCount)
    }
    
    func dismissCountView() {
        delegate.dismissViewController() {
            //self.gameMaster!.prepareForNewRound()
            self.taskComplete()
        }
    }
}
