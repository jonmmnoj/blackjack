//
//  DeviationSettings.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 8/2/21.
//

import Foundation
import UIKit
import QuickTableViewController

class DeviationsSettings: GameTypeSettings {
    var title: String = "Deviations #1"
    init(vc: SettingsViewController) {
        self.vc = vc
    }
    var vc: SettingsViewController
    var settings = Settings.shared
    var surrenderCell: UITableViewCell!
    var es10Cell: UITableViewCell!
    //var enhcCell: UITableViewCell!
    var twoHandCell: UITableViewCell!
    var threeHandCell: UITableViewCell!
    var fourHandCell: UITableViewCell!
    var splitCell: UITableViewCell!
    var softCell: UITableViewCell!
    var hardCell: UITableViewCell!
    var dealerHitsCell: UITableViewCell!
    var quickFeedbackCell: UITableViewCell!
    var feedbackWhenWrongCell: UITableViewCell!
    
    var tableSettings: [Section] {
        return [
            
            Section(title: "", rows: [
               
                TapActionRow(
                    text: "Start",
                    customization: {(cell,row) in
                        cell.textLabel?.textColor = .systemGreen
                        cell.tintColor = .systemGreen
                        cell.textLabel?.font = .systemFont(ofSize: 20, weight: .bold)
                        cell.selectionStyle = UITableViewCell.SelectionStyle.none;
                        //cell.tintColor = .white
                        //cell.frame.height = cell.frame.height * 2
                    },
                    action: { _ in
                        self.playClickSound()
                        
                        let emptyHandSetting = !self.settings.softHands && !self.settings.hardHands && !self.settings.splitHands ? true : false
                        let emptyNumberSetting = !self.settings.twoCardHands && !self.settings.threeCardHands && !self.settings.fourCardHands ? true : false
                        if emptyHandSetting || emptyNumberSetting {
                            var s = "\n"
                            if emptyNumberSetting {
                                s += "NUMBER OF CARDS"
                            }
                            if emptyHandSetting {
                                if s.count > 0 { s += "\n" }
                                s += "TYPE OF HAND"
                            }
                            self.alert(message: s)
                        }
                        
                        self.vc.tableView.deselectRow(at: IndexPath(row:0, section: 0), animated: true)
                        let gvc = self.vc.storyboard!.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
                        gvc.gameType = Settings.shared.gameType
                        gvc.gearButton.isEnabled = true
                        let nvc = UINavigationController(rootViewController: gvc)
                        nvc.modalPresentationStyle = .fullScreen
                        self.vc.present(nvc, animated: true, completion: nil)
                        //gvc.modalPresentationStyle = .overFullScreen
                        //self.vc.present(gvc, animated: true, completion: nil)
                    })
            ]),
        
            Section(title: "Rules", rows: [
                SwitchRow(
                    text: "Dealer Hits Soft 17",
                    switchValue: settings.dealerHitsSoft17,
                      customization: { cell, row in
                        self.dealerHitsCell = cell
//                        (self.dealerHitsCell.accessoryView as! UISwitch).setOn(self.settings.dealerHitsSoft17, animated: false)
                      },
                      action: { _ in
                        self.settings.dealerHitsSoft17 = !self.settings.dealerHitsSoft17
                      }),
//                SwitchRow(
//                    text: "ENHC",
//                    switchValue: settings.ENHC,
//                    customization:  { (cell, row) in
//                        self.enhcCell = cell
//                    },action: { row in
//                        self.settings.ENHC = !self.settings.ENHC
//                        UIView.transition(with: self.surrenderCell.textLabel!,
//                                          duration: 0.5,
//                                      options: .transitionFlipFromTop,
//                                    animations: { [weak self] in
//                                        self!.surrenderCell.textLabel!.text = self!.settings.ENHC ? "ES10" : "Surrender"
//                                 }, completion: nil)
//
//                    }),
                
                SwitchRow(
                    text: "Surrender",
                    switchValue: settings.surrender,
                    customization: { (cell, row) in
                        self.surrenderCell = cell
                        self.surrenderCell.textLabel!.text = self.settings.ENHC ? "ES10" : "Surrender"
                    },
                    action: { _ in
                        self.settings.surrender = !self.settings.surrender
                    }),
            
                
//
//                SwitchRow(
//                    text: "ES10",
//                    switchValue: settings.ES10,
//                    customization: { (cell, row) in
//                        self.es10Cell = cell
//                    },
//                    action: { _ in }),
            ]),
            
            Section(title: "Hand Types", rows: [
                SwitchRow(text: "Pairs", switchValue: settings.splitHands,
                          customization: { cell, row in
                            self.splitCell = cell
                          },
                          action: { _ in
                            self.settings.splitHands = !self.settings.splitHands
                            //print("split: \(self.settings.splitHands)")
                          }),
                SwitchRow(text: "Soft Totals", switchValue: settings.softHands, customization: {cell,row in
                    self.softCell = cell
                }, action: { _ in
                    self.settings.softHands = !self.settings.softHands
                }),
                SwitchRow(text: "Hard Totals", switchValue: settings.hardHands, customization: {cell,row in
                    self.hardCell = cell
                }, action: { _ in
                    self.settings.hardHands = !self.settings.hardHands
                })
            ]),

            Section(title: "Number of Cards", rows: [
                SwitchRow(text: "2 card hands",  switchValue: settings.twoCardHands, customization: {cell,row in
                    self.twoHandCell = cell
                },
                          action: { _ in
                    self.settings.twoCardHands = !self.settings.twoCardHands
                            //print("two card: \(self.settings.twoCardHands)")
                    self.setupSplitControl()
                    self.setupSoftControl()
                }), //detailText: .subtitle("Pair, Soft and Hard hands. Hit, Stand, Double, Split and Surrender"),
                SwitchRow(text: "3 card hands", /*detailText: .subtitle("Hard hands only. Hit and Stand only"),*/ switchValue: settings.threeCardHands, customization: {cell,row in
                    self.threeHandCell = cell
                }, action: { _ in
                    self.settings.threeCardHands = !self.settings.threeCardHands
                }),
                SwitchRow(text: "4 card hands", /*detailText: .subtitle("Hard hands only. Hit and Stand only"),*/ switchValue: settings.fourCardHands, customization: {cell,row in
                    self.fourHandCell = cell
                }, action: { _ in
                    self.settings.fourCardHands = !self.settings.fourCardHands
                })
            ]),
            
            Section(title: "Miscellaneous", rows: [
//                SwitchRow(text: "Quick Feedback", switchValue: settings.quickFeedback, customization: { cell,row in
//                        self.quickFeedbackCell = cell
//                    }, action: { _ in
//                        self.settings.quickFeedback = !self.settings.quickFeedback
//                    }),
                SwitchRow(text: "Feedback for Mistakes Only", switchValue: settings.feedbackWhenWrong, customization: { cell,row in
                        self.feedbackWhenWrongCell = cell
                    }, action: { _ in
                        self.settings.feedbackWhenWrong = !self.settings.feedbackWhenWrong
                    })
                ]),
        
            Section(title: "", rows: [
               TapActionRow(
                    text: "Reset to defaults",
                    customization: {(cell,row) in
                        cell.textLabel?.textColor = .systemRed
                        cell.tintColor = .systemRed
                        cell.backgroundColor = .secondarySystemGroupedBackground
                        //cell.textLabel?.textColor = .systemBlue
                        cell.textLabel?.font = .systemFont(ofSize: 17, weight: .regular)//font-family: "UICTFontTextStyleBody"; font-weight: normal; font-style: normal; font-size: 17.00pt
                        cell.selectionStyle = .default
                    },
                    action: { _ in
                        (self.dealerHitsCell.accessoryView as! UISwitch).setOn(self.settings.defaults.dealerHitsSoft17, animated: true)
                        (self.dealerHitsCell.accessoryView as! UISwitch).sendActions(for: .valueChanged)
                        
//                        (self.enhcCell.accessoryView as! UISwitch).setOn(self.settings.defaults.ENHC, animated: true)
//                        (self.enhcCell.accessoryView as! UISwitch).sendActions(for: .valueChanged)
                        
                        (self.surrenderCell.accessoryView as! UISwitch).setOn(false, animated: true)
                        (self.surrenderCell.accessoryView as! UISwitch).sendActions(for: .valueChanged)
                        
                        //self.settings.threeCardHands = false
                        (self.threeHandCell.accessoryView as! UISwitch).setOn(false, animated: true)
                        (self.threeHandCell.accessoryView as! UISwitch).sendActions(for: .valueChanged)
                        
                        //self.settings.fourCardHands = false
                        (self.fourHandCell.accessoryView as! UISwitch).setOn(false, animated: true)
                        (self.fourHandCell.accessoryView as! UISwitch).sendActions(for: .valueChanged)
                        
                        //self.settings.splitHands = true
                        (self.splitCell.accessoryView as! UISwitch).setOn(true, animated: true)
                        (self.splitCell.accessoryView as! UISwitch).sendActions(for: .valueChanged)
                        //self.setupSplitControl()
                        
                        //self.settings.softHands = true
                        (self.softCell.accessoryView as! UISwitch).setOn(true, animated: true)
                        (self.softCell.accessoryView as! UISwitch).sendActions(for: .valueChanged)
                        
                        //self.settings.hardHands = true
                        (self.hardCell.accessoryView as! UISwitch).setOn(true, animated: true)
                        (self.hardCell.accessoryView as! UISwitch).sendActions(for: .valueChanged)
                        
                        // This is called after change to split hand, because this control's action handler affects split control
                        (self.twoHandCell.accessoryView as! UISwitch).setOn(true, animated: true)
                        (self.twoHandCell.accessoryView as! UISwitch).sendActions(for: .valueChanged)
                        
//                        (self.quickFeedbackCell.accessoryView as! UISwitch).setOn(Settings.shared.defaults.quickFeedback, animated: true)
//                        (self.quickFeedbackCell.accessoryView as! UISwitch).sendActions(for: .valueChanged)
                        
                        (self.feedbackWhenWrongCell.accessoryView as! UISwitch).setOn(Settings.shared.defaults.feedbackWhenWrong, animated: true)
                        (self.feedbackWhenWrongCell.accessoryView as! UISwitch).sendActions(for: .valueChanged)
                    })
            ]),
        ]
    }
    
    private func alert(message: String) {
        let alert = UIAlertController(title: "Settings required for:", message: message, preferredStyle: .alert)

        //alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

        vc.present(alert, animated: true)
    }
    
    private func setupSplitControl() {
        if settings.twoCardHands {
            splitCell.isUserInteractionEnabled = true
            splitCell.textLabel!.isEnabled = true
            (splitCell.accessoryView as! UISwitch).isEnabled = true
            (splitCell.accessoryView as! UISwitch).setOn(settings.splitHands, animated: true)
            (self.splitCell.accessoryView as! UISwitch).sendActions(for: .valueChanged)
        } else {
            splitCell.isUserInteractionEnabled = false
            splitCell.textLabel!.isEnabled = false
            (splitCell.accessoryView as! UISwitch).isEnabled = false
            (splitCell.accessoryView as! UISwitch).setOn(false, animated: true)
            (self.splitCell.accessoryView as! UISwitch).sendActions(for: .valueChanged)
        }
    }
    private func setupSoftControl() {
        if settings.twoCardHands {
            softCell.isUserInteractionEnabled = true
            softCell.textLabel!.isEnabled = true
            (softCell.accessoryView as! UISwitch).isEnabled = true
            (softCell.accessoryView as! UISwitch).setOn(settings.softHands, animated: true)
            (self.softCell.accessoryView as! UISwitch).sendActions(for: .valueChanged)
        } else {
            softCell.isUserInteractionEnabled = false
            softCell.textLabel!.isEnabled = false
            (softCell.accessoryView as! UISwitch).isEnabled = false
            (softCell.accessoryView as! UISwitch).setOn(false, animated: true)
            (self.softCell.accessoryView as! UISwitch).sendActions(for: .valueChanged)
        }
    }
    
    func forcedSettings() {
        settings.deviations = true
    }
}



