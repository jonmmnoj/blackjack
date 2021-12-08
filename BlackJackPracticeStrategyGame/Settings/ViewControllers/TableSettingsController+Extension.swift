//
//  TableSettingsController+Extension.swift
//  BlackJackPracticeStrategyGame
//
//  Created by Jon on 11/26/21.
//

import Foundation
import UIKit

extension TableSettingsViewController  {
    override func viewWillDisappear(_ animated: Bool) {
        gameVC.gameMaster!.dealer.table.view.backgroundColor = UIColor(hex: TableColor(rawValue: Settings.shared.tableColor)!.tableCode)
        gameVC.gameMaster!.dealer.table.discardTray.button.backgroundColor = UIColor(hex: TableColor(rawValue: Settings.shared.buttonColor)!.buttonCode)
        gameVC.setButtonColor()
        
        if cardSizeFactorOnLoad != Settings.shared.cardSizeFactor {
            gameVC.adjustmentsForScaleChange()
            gameVC.gameMaster.dealer.table.discardTray.adjustSizeForScaleChange()
            
            // player cards
            var changeX: CGFloat = 0
            var changeY: CGFloat = 0
            for (i, hand) in gameVC.gameMaster!.player!.hands.enumerated() {
                if i == 0 {
                    changeX = hand.originPoint.x - gameVC.gameMaster.getPlayerHandDealPoint(numberOfHandsToAdjustBy: 0).x
                    changeY = hand.originPoint.y - gameVC.gameMaster.getPlayerHandDealPoint(numberOfHandsToAdjustBy: 0).y
                }
                hand.adjustForScaleChange(dealPoint: gameVC.gameMaster!.playerHandDealPoint, adjustmentX: gameVC.gameMaster!.playerAdjustmentXorY, adjustmentY: gameVC.gameMaster!.playerAdjustmentXorY, changeInDealPointX: changeX, changeInDealPointY: changeY)
                
                for card in hand.cards {
                    card.adjustSizeForScaleChange(changeX: changeX, changeY: changeY)
                }
//                if hand === gameVC.gameMaster!.player!.activatedHand && Settings.shared.gameType == .freePlay {
//                    gameVC.gameMaster!.dealer!.table.stopIndicator()
//                    gameVC.gameMaster!.dealer!.table.showIndicator(on: hand)
//                }
            }
            
            let movements = gameVC.gameMaster!.dealer.table.movements
            let scaleMovements = gameVC.gameMaster!.dealer.table.movementsForScaleChange
            if movements != 0 && scaleMovements != movements {
                var dif = movements - scaleMovements
                let direction: MoveCardsDirection = dif < 0 ? .left : .right
                dif = abs(dif)
                for _ in 0..<dif {
                    gameVC.gameMaster.dealer.moveCards(for: gameVC.gameMaster!.player!, to: direction)
                }
                gameVC.gameMaster!.dealer.table.movementsForScaleChange = gameVC.gameMaster!.dealer.table.movements
                
            }
            
            if Settings.shared.gameType == .freePlay {
                gameVC.gameMaster!.dealer!.table.stopIndicator()
                gameVC.gameMaster!.dealer!.table.showIndicator(on: gameVC.gameMaster!.player!.activatedHand!)
            }
            
            // dealer cards
            for (i, hand) in gameVC.gameMaster!.dealer!.hands.enumerated() {
                if i == 0 {
                    changeX = hand.originPoint.x - gameVC.gameMaster!.dealerHandDealPoint.x
                    changeY = hand.originPoint.y - gameVC.gameMaster!.dealerHandDealPoint.y
                }
                hand.adjustForScaleChange(dealPoint: gameVC.gameMaster!.dealerHandDealPoint, adjustmentX: gameVC.gameMaster!.dealerHandAdjustmentX, adjustmentY: gameVC.gameMaster!.dealerHandAdjustmentY, changeInDealPointX: changeX, changeInDealPointY: changeY)
                for card in hand.cards {
                    card.adjustSizeForScaleChange(changeX: changeX, changeY: changeY)
                }
            }
        }
        
        if cardColorOnLoad != Settings.shared.cardColor {
            for hand in gameVC.gameMaster!.dealer!.hands {
                for card in hand.cards {
                    if card.isFaceDown {
                        card.backView?.image = UIImage(named: card.backImageName())
                    }
                }
            }
        }

        gameVC.updateForTableSettings()
        
        if showHandValueOnLoad != Settings.shared.showHandTotal {
            for hand in gameVC.gameMaster!.player!.hands {
                hand.updateViewValueOfHand(for: gameVC.gameMaster!.dealer!.table)
            }
            
            for hand in gameVC.gameMaster!.dealer!.hands {
                hand.updateViewValueOfHand(for: gameVC.gameMaster!.dealer!.table)
            }
        }
        
    }
}
