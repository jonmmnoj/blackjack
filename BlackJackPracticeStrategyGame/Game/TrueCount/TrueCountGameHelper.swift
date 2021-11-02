//
//  TrueCountGameHelper.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 8/12/21.
//

import Foundation
import UIKit

class TrueCountGameHelper: GameTypeStrategyPatternProtocol {
    var gameMaster: GameMaster
    var stackView: UIStackView!
    var vc: TrueCountView!
    
    init(gameMaster: GameMaster) {
        self.gameMaster = gameMaster
    }
    
    func dealCards() {
        vc = TrueCountView()
        vc.tableView = gameMaster.tableView
        stackView = vc.stackView
        gameMaster.tableView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.centerWithinMargins.equalTo(gameMaster.tableView.snp.centerWithinMargins)
            make.height.lessThanOrEqualTo(gameMaster.tableView.snp.height)
        }
        vc.setup()
        vc.submitHandler = { isCorrect, text, correctText in
            self.gameMaster.delegate.presentBasicStrategyFeedbackView(isCorrect: isCorrect, playerAction: text, correctAction: correctText) {
                self.dealCards()
            }
            self.stackView.removeFromSuperview()

        }

        gameMaster.tableView.isUserInteractionEnabled = true
        
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

