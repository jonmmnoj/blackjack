//
//  TrueCountSettings.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 8/10/21.
//

import Foundation
import UIKit
import QuickTableViewController

class TrueCountSettings: GameTypeSettings {
    
    var title: String = "True Count"
    init(vc: SettingsViewController) {
        self.vc = vc
    }
    var vc: SettingsViewController
    var sliderView: SliderTableViewCell!
    //var numberOfDecksSection: RadioSection!
    var deckFractionsSection: RadioSection!
    var deckRoundedToSection: RadioSection!
    var roundCell: UITableViewCell!
    var showCell: UITableViewCell!
    var numberOfDecksViewCell: UITableViewCell!
    var deckRoundedToCell: UITableViewCell!
    var deckFractionCell: UITableViewCell!
    var maxRunningCountCell: UITableViewCell!
    var highCountBias: UITableViewCell!
   
    @objc private func setNumberOfDecksSetting(notification: Notification) {
        let string = notification.object as! String
        numberOfDecksViewCell.detailTextLabel?.text = string
        Settings.shared.numberOfDecks = Int(string)!
    }
    @objc private func setDeckRoundedToSetting(notification: Notification) {
        let string = notification.object as! String
        deckRoundedToCell.detailTextLabel?.text = string
        Settings.shared.deckRoundedTo = string
    }
    @objc private func setDeckFractionSetting(notification: Notification) {
        let string = notification.object as! String
        deckFractionCell.detailTextLabel?.text = string
        Settings.shared.deckFraction = string
    }
    @objc private func setMaxRunningCountSetting(notification: Notification) {
        let string = notification.object as! String
        maxRunningCountCell.detailTextLabel?.text = string
        Settings.shared.maxRunningCount = Int(string)!
    }
    private func showViewSettingOptions(sectionTitle: String, data: [String], checkMarkedValue: String, notificationName: String) {
        let vc = SettingsListTableViewController(sectionTitle: sectionTitle, data: data, checkMarkedValue: checkMarkedValue, notificationName: notificationName)
        //vc.title = $0.text //+ ($0.detailText?.text ?? "")
        self.vc.navigationController?.pushViewController(vc, animated: true)
    }
    
    var settings = Settings.shared
    
   var tableSettings: [Section] {
//        deckRoundedToSection = RadioSection(title: "Rounding", options: [
//            OptionRow(text: "whole", isSelected: settings.deckRoundedTo == "whole", action: didToggleDeckRoundedToSelection()),
//            OptionRow(text: "half", isSelected: settings.deckRoundedTo == "half", action: didToggleDeckRoundedToSelection())
//        ], footer: "Always rounds down")
//        deckRoundedToSection.alwaysSelectsOneOption = true
        
//        numberOfDecksSection = RadioSection(title: "Number of Decks", options: [
//            OptionRow(text: "2", isSelected: settings.numberOfDecks == 2, action: didToggleSelection()),
//            OptionRow(text: "4", isSelected: settings.numberOfDecks == 4, action: didToggleSelection()),
//            OptionRow(text: "6", isSelected: settings.numberOfDecks == 6, action: didToggleSelection()),
//            OptionRow(text: "8", isSelected: settings.numberOfDecks == 8, action: didToggleSelection())
//        ] /*, footer: "See RadioSection for more details."*/)
//        numberOfDecksSection.alwaysSelectsOneOption = true
        
//        deckFractionsSection = RadioSection(title: "Amount Discarded", options: [
//            OptionRow(text: "wholes", isSelected: settings.deckFraction == "wholes", action: didToggleDeckFractionSelection()),
//            OptionRow(text: "halves", isSelected: settings.deckFraction == "halves", action: didToggleDeckFractionSelection()),
////            OptionRow(text: "third", isSelected: settings.deckFraction == "third", action: didToggleDeckFractionSelection()),
//            OptionRow(text: "quarters", isSelected: settings.deckFraction == "quarters", action: didToggleDeckFractionSelection())
//        ] )//, footer: "")
//        deckFractionsSection.alwaysSelectsOneOption = true
        
        return [
            Section(title: "", rows: [
               
                TapActionRow(
                    text: "Start",
                    customization: {(cell,row) in
                        //cell.backgroundColor = .systemGreen
                        cell.textLabel?.textColor = .systemGreen
                        cell.tintColor = .systemGreen
                        cell.textLabel?.font = .systemFont(ofSize: 20, weight: .bold)
                        cell.selectionStyle = UITableViewCell.SelectionStyle.none;
                        
                        //cell.frame.height = cell.frame.height * 2
                    },
                    action: { _ in
                        self.playClickSound()
                        
                        self.vc.tableView.deselectRow(at: IndexPath(row:0, section: 0), animated: true)
                        let gvc = self.vc.storyboard!.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
                        gvc.gameType = Settings.shared.gameType
                        gvc.gearButton.isHidden = true
                        let nvc = UINavigationController(rootViewController: gvc)
                        nvc.modalPresentationStyle = .fullScreen
                        self.vc.present(nvc, animated: true, completion: nil)
                        //gvc.modalPresentationStyle = .overFullScreen
                        //self.vc.present(gvc, animated: true, completion: nil)
                    })
            ]),
            
            Section(title: "Deck settings", rows: [
                NavigationRow(text: "Number of Decks", detailText: .value1(""), customization: { cell, row in
                        self.numberOfDecksViewCell = cell
                        self.numberOfDecksViewCell.detailTextLabel?.text = String(Settings.shared.numberOfDecks)
                    NotificationCenter.default.addObserver(self, selector: #selector(self.setNumberOfDecksSetting(notification:)), name: Notification.Name("NumberOfDecksSetting"), object: nil)
                    },
                              action: { row in
                        let values = NumberOfDecks.allCases
                        var data = [String]()
                        for value in values {
                            data.append("\(value.rawValue)")
                        }
                      self.showViewSettingOptions(sectionTitle: row.text, data: data, checkMarkedValue: String(Settings.shared.numberOfDecks), notificationName: "NumberOfDecksSetting")
                        return
                    }),
                NavigationRow(text: "Divisor rounding", detailText: .value1(""), customization: { cell, row in
                        self.deckRoundedToCell = cell
                        self.deckRoundedToCell.detailTextLabel?.text = String(Settings.shared.deckRoundedTo)
                    NotificationCenter.default.addObserver(self, selector: #selector(self.setDeckRoundedToSetting(notification:)), name: Notification.Name("DeckRoundedToSetting"), object: nil)
                    },
                              action: { row in
                        let values = DeckRoundedTo.allCases
                        var data = [String]()
                        for value in values {
                            data.append("\(value.rawValue)")
                        }
                      self.showViewSettingOptions(sectionTitle: row.text, data: data, checkMarkedValue: String(Settings.shared.deckRoundedTo), notificationName: "DeckRoundedToSetting")
                        return
                    }),
                SwitchRow(text: "Round Last 3 Decks to Half", detailText: .subtitle(""), switchValue: settings.roundLastThreeDecksToHalf, customization: {cell,row in
                    self.roundCell = cell
                }, action: { _ in
                    self.settings.roundLastThreeDecksToHalf = !self.settings.roundLastThreeDecksToHalf
                }),
                NavigationRow(text: "Amount of deck discarded", detailText: .value1(""), customization: { cell, row in
                        self.deckFractionCell = cell
                        self.deckFractionCell.detailTextLabel?.text = String(Settings.shared.deckFraction)
                    NotificationCenter.default.addObserver(self, selector: #selector(self.setDeckFractionSetting(notification:)), name: Notification.Name("DeckFractionSetting"), object: nil)
                    },
                              action: { row in
                        let values = DeckFraction.allCases
                        var data = [String]()
                        for value in values {
                            data.append("\(value.rawValue)")
                        }
                        self.showViewSettingOptions(sectionTitle: row.text, data: data, checkMarkedValue: String(Settings.shared.deckFraction), notificationName: "DeckFractionSetting")
                        return
                    }),
                
                NavigationRow(text: "Maximum +/- Running Count", detailText: .value1(""), customization: { cell, row in
                        self.maxRunningCountCell = cell
                    self.maxRunningCountCell.detailTextLabel?.text = String(Settings.shared.maxRunningCount)
                    NotificationCenter.default.addObserver(self, selector: #selector(self.setMaxRunningCountSetting(notification:)), name: Notification.Name("MaxRunningCountSetting"), object: nil)
                    },
                        action: { row in
                            var data = [String]()
                            let nums: [Int] = Array(20...40)
                            for n in nums.reversed() {
                                data.append("\(n)")
                            }
                            self.showViewSettingOptions(sectionTitle: row.text, data: data, checkMarkedValue: String(Settings.shared.maxRunningCount), notificationName: "MaxRunningCountSetting")
                        return
                    }),
                SwitchRow(text: "High Running Count Bias", detailText: .subtitle(""), switchValue: settings.highRunningCountBias, customization: {cell,row in
                    self.highCountBias = cell
                }, action: { _ in
                    self.settings.highRunningCountBias = !self.settings.highRunningCountBias
                }),
                
            ]),
            
            //deckRoundedToSection,
            //numberOfDecksSection,
            //deckFractionsSection,
            
            Section(title: "Assistance", rows: [
                SwitchRow(text: "Show Amount Discarded/Remaining", detailText: .subtitle(""), switchValue: settings.showDiscardedRemainingDecks, customization: {cell,row in
                    self.showCell = cell
                }, action: { _ in
                    self.settings.showDiscardedRemainingDecks = !self.settings.showDiscardedRemainingDecks
                }),
                
            ])

//            Section(title: "", rows: [
//               TapActionRow(
//                    text: "Reset to defaults",
//                    customization: {(cell,row) in
//                        cell.textLabel?.textColor = .systemRed
//                        cell.tintColor = .systemRed
//                        cell.backgroundColor = .secondarySystemGroupedBackground
//                        //cell.textLabel?.textColor = .systemBlue
//                        cell.textLabel?.font = .systemFont(ofSize: 17, weight: .regular)//font-family: "UICTFontTextStyleBody"; font-weight: normal; font-style: normal; font-size: 17.00pt
//                        cell.selectionStyle = .default
//                    },
//
//                    action: { _ in
//
//                        self.sliderView.slider.setValue(Settings.shared.defaults.dealSpeed, animated: true)
//                        self.sliderView.slider.sendActions(for: .valueChanged)
//
//                        if Settings.shared.numberOfRoundsBeforeAskCount != Settings.shared.defaults.numberOfRoundsBeforeAskCount.rawValue {
//                            let indexPath = IndexPath(row: 0, section: 2)
//                            self.vc.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
//                            self.vc.tableView.delegate?.tableView!(self.vc.tableView, didSelectRowAt: indexPath)
//                        }
//
//                    })
//            ]),
        ]
    }
    


    
//    private func didToggleSelection() -> (Row) -> Void {
//      return { row in
//        if let option = row as? OptionRowCompatible {
//            if option.isSelected {
//                Settings.shared.numberOfDecks = Int(row.text)!
//            }
//        }
//      }
//    }
//
//    private func didToggleDeckFractionSelection() -> (Row) -> Void {
//      return { row in
//        if let option = row as? OptionRowCompatible {
//            if option.isSelected {
//                Settings.shared.deckFraction = row.text
//            }
//        }
//      }
//    }
//    private func didToggleDeckRoundedToSelection() -> (Row) -> Void {
//      return { row in
//        if let option = row as? OptionRowCompatible {
//            if option.isSelected {
//                Settings.shared.deckRoundedTo = row.text
//            }
//        }
//      }
//    }
}
