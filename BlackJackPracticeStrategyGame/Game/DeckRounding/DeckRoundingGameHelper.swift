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
        stackView = dv.stackView
        gameMaster.tableView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.left.equalTo(gameMaster.tableView.safeAreaLayoutGuide.snp.leftMargin).offset(50)
            make.right.equalTo(gameMaster.tableView.safeAreaLayoutGuide.snp.rightMargin).offset(-50)
            //make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(100)//.snp.topMargin)//.offset(50)
            //make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).offset(-100)//.offset(50)
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

        gameMaster.delegate.playerInput(enabled: true)
        gameMaster.tableView.isUserInteractionEnabled = true
        //stackView.isUserInteractionEnabled = true
    }
    
    func inputReceived(action: PlayerAction) {
        gameMaster.delegate.playerInput(enabled: true)
    }
    
    
    func tasksForEndOfRound() {
        
    }
    
    func waitForPlayerInput() {
        
    }
}
