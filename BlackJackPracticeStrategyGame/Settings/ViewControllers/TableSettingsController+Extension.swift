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
        
        // Scales Cards
        if cardSizeFactorOnLoad != Settings.shared.cardSizeFactor {
            // Home and Gear Button
            gameVC.adjustmentsForScaleChange()
            // Discard Tray
            gameVC.gameMaster.dealer.table.discardTray.adjustSizeForScaleChange()
            
            // Player Cards
            var changeX: CGFloat = 0
            var changeY: CGFloat = 0
            for (i, hand) in gameVC.gameMaster!.player!.hands.enumerated() {
                if Settings.shared.landscape {
                    let assignments = Settings.shared.spotAssignments
                    var count = -1
                    for (j, assignment) in assignments.enumerated() {
                        if assignment != .empty {
                            count += 1
                            if count == i {
                                let newDealPoint = Hand.getDealPoint(for: j)
                                changeX = hand.originPoint.x - newDealPoint.x
                                changeY = hand.originPoint.y - newDealPoint.y
                            }
                        }
                    }
                } else {
                    if i == 0 {
                        let newDealPoint = Hand.getPlayerHandDealPoint(numberOfHandsToAdjustBy: 0)
                        changeX = hand.originPoint.x - newDealPoint.x
                        changeY = hand.originPoint.y - newDealPoint.y
                    }
                }
                // Card Deal Point
                hand.adjustForScaleChange(dealPoint: Hand.getDealPoint(for: gameVC.gameMaster!.player!), adjustmentX: Hand.playerAdjustmentX, adjustmentY: Hand.playerAdjustmentY, changeInDealPointX: changeX, changeInDealPointY: changeY)
                
                // Card Height/Width
                for card in hand.cards {
                    //card.adjustSizeForScaleChange(changeX: changeX, changeY: changeY)
                    card.adjustSizeForScaleChange()
                    //card.updateFrame()
                }
            }
            
            if !Settings.shared.landscape {
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
            }
            
            // Indicator
            if Settings.shared.gameType == .freePlay {
                gameVC.gameMaster!.dealer!.table.stopIndicator()
                gameVC.gameMaster!.dealer!.table.showIndicator(on: gameVC.gameMaster!.player!.activatedHand!)
            }
            
            // Dealer Cards
            for (i, hand) in gameVC.gameMaster!.dealer!.hands.enumerated() {
                if i == 0 { // gameVC.gameMaster!
                    changeX = hand.originPoint.x - Hand.dealerHandDealPoint.x
                    changeY = hand.originPoint.y - Hand.dealerHandDealPoint.y
                }
                hand.adjustForScaleChange(dealPoint: Hand.dealerHandDealPoint, adjustmentX: Hand.dealerHandAdjustmentX, adjustmentY: Hand.dealerHandAdjustmentY, changeInDealPointX: changeX, changeInDealPointY: changeY)
                for card in hand.cards {
                    //card.adjustSizeForScaleChange(changeX: changeX, changeY: changeY)
                    card.adjustSizeForScaleChange()
                }
            }
        }
        
        // Scales Button Stackview
        gameVC.updateForTableSettings()
        
        // Colors
        gameVC.gameMaster!.dealer.table.view.backgroundColor = UIColor(hex: TableColor(rawValue: Settings.shared.tableColor)!.tableCode)
        gameVC.gameMaster!.dealer.table.discardTray.button.backgroundColor = UIColor(hex: TableColor(rawValue: Settings.shared.buttonColor)!.buttonCode)
        gameVC.gameMaster!.dealer.table.setGradientColors()
        gameVC.setButtonColor()
        if cardColorOnLoad != Settings.shared.cardColor {
            for hand in gameVC.gameMaster!.dealer!.hands {
                for card in hand.cards {
                    if card.isFaceDown {
                        card.backView?.image = UIImage(named: card.backImageName())
                    }
                }
            }
        }

        // Hand Total View
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
