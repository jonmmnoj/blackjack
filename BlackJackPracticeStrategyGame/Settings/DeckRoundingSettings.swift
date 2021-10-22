//
//  DeckRoundingSettings.swift
//  BlackJackPracticeStrategyGame
//
//  Created by Jon on 9/2/21.
//

import Foundation
import UIKit
import QuickTableViewController

class DeckRoundingSettings: GameTypeSettings {
    var title: String = "Deck Rounding"
    init(vc: SettingsViewController) {
        self.vc = vc
    }
    var vc: SettingsViewController
    var sliderView: SliderTableViewCell!
    var numberOfDecksSection: RadioSection!
    var deckFractionsSection: RadioSection!
    var deckRoundedToSection: RadioSection!
    var roundCell: UITableViewCell!
    var showCell: UITableViewCell!
    
    var settings = Settings.shared
    
    var tableSettings: [Section] {
        deckRoundedToSection = RadioSection(title: "Rounding", options: [
            OptionRow(text: "whole", isSelected: settings.deckRoundedTo == "whole", action: didToggleDeckRoundedToSelection()),
            OptionRow(text: "half", isSelected: settings.deckRoundedTo == "half", action: didToggleDeckRoundedToSelection())
        ], footer: "Always rounds down")
        deckRoundedToSection.alwaysSelectsOneOption = true
        
        numberOfDecksSection = RadioSection(title: "Number of Decks", options: [
            OptionRow(text: "2", isSelected: settings.numberOfDecks == 2, action: didToggleSelection()),
            OptionRow(text: "4", isSelected: settings.numberOfDecks == 4, action: didToggleSelection()),
            OptionRow(text: "6", isSelected: settings.numberOfDecks == 6, action: didToggleSelection()),
            OptionRow(text: "8", isSelected: settings.numberOfDecks == 8, action: didToggleSelection())
        ] /*, footer: "See RadioSection for more details."*/)
        numberOfDecksSection.alwaysSelectsOneOption = true
        
        deckFractionsSection = RadioSection(title: "Amount Discarded", options: [
            OptionRow(text: "wholes", isSelected: settings.deckFraction == "whole", action: didToggleDeckFractionSelection()),
            OptionRow(text: "halves", isSelected: settings.deckFraction == "half", action: didToggleDeckFractionSelection()),
//            OptionRow(text: "third", isSelected: settings.deckFraction == "third", action: didToggleDeckFractionSelection()),
            OptionRow(text: "quarters", isSelected: settings.deckFraction == "quarter", action: didToggleDeckFractionSelection())
        ] )//, footer: "")
        deckFractionsSection.alwaysSelectsOneOption = true
        
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
                        self.vc.tableView.deselectRow(at: IndexPath(row:0, section: 0), animated: true)
                        let gvc = self.vc.storyboard!.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
                        gvc.gameType = self.vc.gameType
                        gvc.modalPresentationStyle = .overFullScreen
                        self.vc.present(gvc, animated: true, completion: nil)
                    })
            ]),
            
            deckRoundedToSection,
            numberOfDecksSection,
            deckFractionsSection,
            
            Section(title: "Miscellaneous", rows: [
                SwitchRow(text: "Show Amount Discarded", detailText: .subtitle(""), switchValue: settings.showDiscardedRemainingDecks, customization: {cell,row in
                    self.showCell = cell
                }, action: { _ in
                    self.settings.showDiscardedRemainingDecks = !self.settings.showDiscardedRemainingDecks
                }),
                SwitchRow(text: "Round Last 3 Decks to Half", detailText: .subtitle(""), switchValue: settings.roundLastThreeDecksToHalf, customization: {cell,row in
                    self.roundCell = cell
                }, action: { _ in
                    self.settings.roundLastThreeDecksToHalf = !self.settings.roundLastThreeDecksToHalf
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
    


    
    private func didToggleSelection() -> (Row) -> Void {
      return { row in
        if let option = row as? OptionRowCompatible {
            if option.isSelected {
                Settings.shared.numberOfDecks = Int(row.text)!
            }
        }
      }
    }
    
    private func didToggleDeckFractionSelection() -> (Row) -> Void {
      return { row in
        if let option = row as? OptionRowCompatible {
            if option.isSelected {
                Settings.shared.deckFraction = row.text
            }
        }
      }
    }
    private func didToggleDeckRoundedToSelection() -> (Row) -> Void {
      return { row in
        if let option = row as? OptionRowCompatible {
            if option.isSelected {
                Settings.shared.deckRoundedTo = row.text
            }
        }
      }
    }
}

