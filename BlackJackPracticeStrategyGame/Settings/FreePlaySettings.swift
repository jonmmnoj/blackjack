//
//  FreePlaySettings.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/27/21.
//

import Foundation
import UIKit
import QuickTableViewController

class FreePlaySettings: GameTypeSettings {
    var title: String = "Free Play"
    init(vc: SettingsViewController) {
        self.vc = vc
    }
    var vc: SettingsViewController
    var radioSection: RadioSection!
    var countSection: RadioSection!
    var settings = Settings.shared
    
    var dealerHitsCell: UITableViewCell!
    var enhcCell: UITableViewCell!
    var surrenderCell: UITableViewCell!
    var dasCell: UITableViewCell!
    var resplitCell: UITableViewCell!
    var notifyCell: UITableViewCell!
    var sliderView: SliderTableViewCell!
    //var speedCell: UITableViewCell!
    

    var tableSettings: [Section] {
        
        countSection = RadioSection(title: "Ask for count every", options: [
            OptionRow(text: CountRounds.oneRound.rawValue, isSelected: Settings.shared.numberOfRoundsBeforeAskCount == CountRounds.oneRound.rawValue, action: didToggleCountSelection()),
            OptionRow(text: CountRounds.threeRounds.rawValue, isSelected: Settings.shared.numberOfRoundsBeforeAskCount == CountRounds.threeRounds.rawValue, action: didToggleCountSelection()),
            OptionRow(text: CountRounds.fiveRounds.rawValue, isSelected: Settings.shared.numberOfRoundsBeforeAskCount == CountRounds.fiveRounds.rawValue, action: didToggleCountSelection()),
            OptionRow(text: CountRounds.onceAtEnd.rawValue, isSelected: Settings.shared.numberOfRoundsBeforeAskCount == CountRounds.onceAtEnd.rawValue, action: didToggleCountSelection())
        ] /*, footer: "See RadioSection for more details."*/)
        countSection.alwaysSelectsOneOption = true
        
        radioSection = RadioSection(title: "Number of decks", options: [
            OptionRow(text: "2", isSelected: settings.numberOfDecks == 2, action: didToggleSelection()),
            OptionRow(text: "4", isSelected: settings.numberOfDecks == 4, action: didToggleSelection()),
            OptionRow(text: "6", isSelected: settings.numberOfDecks == 6, action: didToggleSelection()),
            OptionRow(text: "8", isSelected: settings.numberOfDecks == 8, action: didToggleSelection())
        ] /*, footer: "See RadioSection for more details."*/)
        
        radioSection.alwaysSelectsOneOption = true
        
        return [
            Section(title: "", rows: [
               
                TapActionRow(
                    text: "Start",
                    customization: {(cell,row) in
                        //cell.backgroundColor = .systemGreen
                        cell.textLabel?.textColor = .systemGreen
                        cell.tintColor = .systemGreen
                        cell.textLabel?.font = .systemFont(ofSize: 20, weight: .bold)
                        //cell.selectionStyle = UITableViewCell.SelectionStyle.none;
                        
                        //cell.frame.height = cell.frame.height * 2
                    },
                    action: { _ in
                        self.vc.tableView.deselectRow(at: IndexPath(row:0, section: 0), animated: true)
                        let gvc = self.vc.storyboard!.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
                        gvc.gameType = self.vc.gameType
                        gvc.edgesForExtendedLayout = .all
                        //self.vc.navigationController?.pushViewController(gvc, animated: true)
                        gvc.modalPresentationStyle = .currentContext
                        self.vc.present(gvc, animated: true, completion: nil)
                    })
            ]),
            
            Section(title: "Rules", rows: [
                SwitchRow(
                    text: "Dealer Hits Soft 17",
                    switchValue: settings.dealerHitsSoft17,
                      customization: { cell, row in
                        self.dealerHitsCell = cell
                        (self.dealerHitsCell.accessoryView as! UISwitch).setOn(self.settings.dealerHitsSoft17, animated: false)
                      },
                      action: { _ in
                        self.settings.dealerHitsSoft17 = !self.settings.dealerHitsSoft17
                      }),
                SwitchRow(
                    text: "ENHC",
                    switchValue: settings.ENHC,
                    customization:  { (cell, row) in
                        self.enhcCell = cell
                        (self.enhcCell.accessoryView as! UISwitch).setOn(self.settings.ENHC, animated: false)
                    },action: { row in
                        self.settings.ENHC = !self.settings.ENHC
                        UIView.transition(with: self.surrenderCell.textLabel!,
                                          duration: 0.5,
                                      options: .transitionFlipFromTop,
                                    animations: { [weak self] in
                                        self!.surrenderCell.textLabel!.text = self!.settings.ENHC ? "ES10" : "Surrender"
                                 }, completion: nil)

                    }),
                
                SwitchRow(
                    text: "Surrender",
                    switchValue: settings.surrender,
                    customization: { (cell, row) in
                        self.surrenderCell = cell
                        self.surrenderCell.textLabel!.text = self.settings.ENHC ? "ES10" : "Surrender"
                        (self.surrenderCell.accessoryView as! UISwitch).setOn(self.settings.surrender, animated: false)
                    },
                    action: { _ in
                        self.settings.surrender = !self.settings.surrender
                    }),
                
                SwitchRow(
                    text: "Double After Split",
                    switchValue: settings.doubleAfterSplit,
                      customization: { cell, row in
                        self.dasCell = cell
                        (self.dasCell.accessoryView as! UISwitch).setOn(self.settings.doubleAfterSplit, animated: false)
                      },
                      action: { _ in
                        self.settings.doubleAfterSplit = !self.settings.doubleAfterSplit
                      }),
//                SwitchRow(
//                    text: "Resplit Aces",
//                    switchValue: settings.resplitAces,
//                      customization: { cell, row in
//                        self.resplitCell = cell
//                      },
//                      action: { _ in
//                        self.settings.resplitAces = !self.settings.resplitAces
//                      }),
                SwitchRow(
                    text: "Notify on Strategy Mistakes",
                    switchValue: settings.notifyMistakes,
                      customization: { cell, row in
                        self.notifyCell = cell
                        (self.notifyCell.accessoryView as! UISwitch).setOn(self.settings.notifyMistakes, animated: false)
                      },
                      action: { _ in
                        self.settings.notifyMistakes = !self.settings.notifyMistakes
                      }),
            ]),
            
            Section(title: "Deal speed", rows: [
                TapActionRow<SliderTableViewCell>(
                  text: " ",
                customization: { cell, row in
                    self.sliderView = cell as? SliderTableViewCell
                },
                    action: { _ in
                        
                    }
                ),
            ]),
            
            countSection,
            
            radioSection,
            
            Section(title: "", rows: [
               TapActionRow(
                    text: "Reset to defaults",
                    customization: {(cell,row) in
                        cell.textLabel?.textColor = .systemRed
                        cell.tintColor = .systemRed
                        cell.backgroundColor = .secondarySystemGroupedBackground
                        //cell.textLabel?.textColor = .systemBlue
                        cell.textLabel?.font = .systemFont(ofSize: 17, weight: .regular)//font-family: "UICTFontTextStyleBody"; font-weight: normal; font-style: normal; font-size: 17.00pt
                        cell.selectionStyle = .default //nil//UITableViewCell.SelectionStyle.none; default
                        //cell.tintColor = .systemBlue
                    },
                    action: { _ in
                        self.sliderView.slider.setValue(Settings.shared.defaults.dealSpeed, animated: true)
                        self.sliderView.slider.sendActions(for: .valueChanged)
                        if self.sliderView.isHidden {
                            self.settings.dealSpeed = self.settings.defaults.dealSpeed
                        }
                        
                        
                        (self.dealerHitsCell.accessoryView as! UISwitch).setOn(self.settings.defaults.dealerHitsSoft17, animated: true)
                        (self.dealerHitsCell.accessoryView as! UISwitch).sendActions(for: .valueChanged)
                        // in case cell is off screen
                        if self.dealerHitsCell.isHidden {
                            self.settings.dealerHitsSoft17 = self.settings.defaults.dealerHitsSoft17
                        }
                        
                        (self.enhcCell.accessoryView as! UISwitch).setOn(self.settings.defaults.ENHC, animated: true)
                        (self.enhcCell.accessoryView as! UISwitch).sendActions(for: .valueChanged)
                        if self.enhcCell.isHidden {
                            self.settings.ENHC = self.settings.defaults.ENHC
                        }
                        
                        (self.surrenderCell.accessoryView as! UISwitch).setOn(self.settings.defaults.surrender, animated: true)
                        (self.surrenderCell.accessoryView as! UISwitch).sendActions(for: .valueChanged)
                        if self.surrenderCell.isHidden {
                            self.settings.surrender = self.settings.defaults.surrender
                        }
                        
                        (self.dasCell.accessoryView as! UISwitch).setOn(self.settings.defaults.doubleAfterSplit, animated: true)
                        (self.dasCell.accessoryView as! UISwitch).sendActions(for: .valueChanged)
                        if self.dasCell.isHidden {
                        self.settings.doubleAfterSplit = self.settings.defaults.doubleAfterSplit
                        }
                        
//                        (self.resplitCell.accessoryView as! UISwitch).setOn(self.settings.defaults.resplitAces, animated: true)
//                        (self.resplitCell.accessoryView as! UISwitch).sendActions(for: .valueChanged)
                        
                        (self.notifyCell.accessoryView as! UISwitch).setOn(self.settings.defaults.notifyMistakes, animated: true)
                        (self.notifyCell.accessoryView as! UISwitch).sendActions(for: .valueChanged)
                        if self.notifyCell.isHidden {
                            self.settings.notifyMistakes = self.settings.defaults.notifyMistakes
                        }
                        
                        if Settings.shared.numberOfRoundsBeforeAskCount != "once at the end" {
                            let indexPath = IndexPath(row: 3, section: 3)
                            self.vc.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                            self.vc.tableView.delegate?.tableView!(self.vc.tableView, didSelectRowAt: indexPath)
                        }
                        //Settings.shared.numberOfRoundsBeforeAskCount = Settings.shared.defaults.numberOfRounds
                        
                        if Settings.shared.numberOfDecks != Settings.shared.defaults.numberOfDecks {
                            let indexPath = IndexPath(row: 2, section: 4)
                            self.vc.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                            self.vc.tableView.delegate?.tableView!(self.vc.tableView, didSelectRowAt: indexPath)
                        }
                        
                    })
            ]),
        ]
    }
    
    func registerCustomViews(for tableView: UITableView) {
        let cell = UINib(nibName: "SliderTableViewCell", bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: "SliderTableViewCell")
    }
    
    private func didToggleSelection() -> (Row) -> Void {
      return { row in
        if let option = row as? OptionRowCompatible {
            if option.isSelected {
                Settings.shared.numberOfDecks = Int(row.text) ?? Settings.shared.defaults.numberOfDecks
            }
        }
      }
    }
    
    private func didToggleCountSelection() -> (Row) -> Void {
      return { row in
        if let option = row as? OptionRowCompatible {
            if option.isSelected {
                Settings.shared.numberOfRoundsBeforeAskCount = row.text
            }
        }
      }
    }
}

