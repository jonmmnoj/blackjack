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
    
    func dealCards() {
        
        dv = DeckRoundingView()
        dv.tableView = gameMaster.tableView
        stackView = dv.stackView
        gameMaster.tableView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.centerWithinMargins.equalTo(gameMaster.tableView.snp.centerWithinMargins)
            make.height.lessThanOrEqualTo(gameMaster.tableView.snp.height)
        }
        dv.setup()
        dv.submitHandler = { isCorrect, text, correctText in
            self.gameMaster.delegate.presentBasicStrategyFeedbackView(isCorrect: isCorrect, playerAction: text, correctAction: correctText) {
                     self.dealCards()
            }
            self.stackView.removeFromSuperview()

        }

        //gameMaster.delegate.playerInput(enabled: true)
        gameMaster.tableView.isUserInteractionEnabled = true
        //stackView.isUserInteractionEnabled = true
        gameMaster.gameState = .dealtCards
    }
    
    func inputReceived(action: PlayerAction) {
        gameMaster.delegate.playerInput(enabled: true)
    }
    
    
    func tasksForEndOfRound() {
        
    }
    
    func waitForPlayerInput() {
        
    }
}
