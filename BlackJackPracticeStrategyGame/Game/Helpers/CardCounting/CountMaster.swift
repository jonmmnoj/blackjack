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
        self.taskComplete = completion
        presentViewToGetUserCount()
    }
    
    func presentViewToGetUserCount() {
        //let gameType = Settings.shared.gameType!
        let gameType = Settings.shared.gameType
        let inputView = DeviationInputView(frame: .zero, gameType: gameType)
            inputView.runningCountSubmitHandler = { inputRC in
                let correctCount = gameType == .runningCount || gameType == .runningCount_v2 ? self.cardCounter.getRunningCount() : self.cardCounter.getTrueCount()
                let isInputCorrect = inputRC == correctCount
                
                let decision = Decision(type: gameType == .runningCount || gameType == .runningCount_v2 ? .runningCount : .trueCount, isCorrect: inputRC == correctCount, yourAnswer: String(inputRC), correctAnswer: String(correctCount), decisionBasedOn: nil)
                //Stats.shared.update(decision: decision)
                
                inputView.removeFromSuperview()
                // why is there a condition here?
                if true {//Settings.shared.gameType != .freePlay || (Settings.shared.gameType == .freePlay && Settings.shared.notifyMistakes) {//Settings.shared.notifyMistakes) {
                    
                    
                    self.gameMaster!.delegate.presentBasicStrategyFeedbackView(isCorrect: isInputCorrect, playerAction: String(inputRC), correctAction: String(correctCount)) {
                        self.taskComplete()
                    }
                } else {
                    self.taskComplete()
                }
        }
        
        let tableView = gameMaster!.tableView
        tableView.addSubview(inputView)
        var width = UIScreen.main.bounds.size.width
        if tableView.traitCollection.horizontalSizeClass == .compact {
            width *= 0.8
        } else { // assumes .regular
            width *= 0.5
        }
        inputView.snp.makeConstraints { make in
            make.center.equalTo(tableView)
            if Settings.shared.horizontalSizeClass == .regular {
                make.width.equalTo(350)
            } else {
                make.width.equalTo(width)
            }
            
            make.height.lessThanOrEqualTo(250)
        }
    }
    
//    func userInput(value: Int, completion: (Bool, Int, Int) -> ()) {
//        let isCorrect = value == cardCounter.getRunningCount()
//        completion(isCorrect, value, cardCounter.getRunningCount())
//    }
}
