//
//  DeckRoundingGameHelper.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 8/22/21.
//

import Foundation
import UIKit

class DeckRoundingGameHelper: GameTypeStrategyPatternProtocol {
    var gameMaster: GameMaster
    var stackView: UIStackView!
    var dv: DeckRoundingView!
    
    init(gameMaster: GameMaster) {
        self.gameMaster = gameMaster
    }
    
    
    var lastSetupDeckRemaining: Float?
    func dealCards() {
        SoundPlayer.shared.playSound(.discard)
        dv = DeckRoundingView()
        dv.tableView = gameMaster.tableView
        stackView = dv.stackView
        gameMaster.tableView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.centerWithinMargins.equalTo(gameMaster.tableView.snp.centerWithinMargins)
            make.height.lessThanOrEqualTo(gameMaster.tableView.snp.height)
        }
        lastSetupDeckRemaining = dv.setup(previousAnswer: lastSetupDeckRemaining)
        dv.submitHandler = { isCorrect, text, correctText in
            
            if Settings.shared.feedbackWhenWrong && isCorrect {
                self.stackView.removeFromSuperview()
                self.dealCards()
                self.gameMaster.gameState = .dealtCards
                self.gameMaster.tableView.isUserInteractionEnabled = true
            } else if !Settings.shared.quickFeedback {
                self.stackView.removeFromSuperview()
                self.gameMaster.delegate.presentBasicStrategyFeedbackView(isCorrect: isCorrect, playerAction: text, correctAction: correctText) {
                    self.dealCards()
                    self.gameMaster.gameState = .dealtCards
                    self.gameMaster.tableView.isUserInteractionEnabled = true
                }
            } else {
                QuickFeedback.result(isCorrect, delegate: self.gameMaster.delegate, moreMessage: correctText)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.stackView.removeFromSuperview()
                    self.dealCards()
                    self.gameMaster.gameState = .dealtCards
                    self.gameMaster.tableView.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    func inputReceived(action: PlayerAction) {
        gameMaster.delegate.playerInput(enabled: true)
    }
    
    func tasksForEndOfRound() {
        
    }
    
    func waitForPlayerInput() {
        
    }
}
