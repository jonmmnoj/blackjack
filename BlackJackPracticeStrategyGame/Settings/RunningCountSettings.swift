//
//  RunningCountSettings.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/26/21.
//

import Foundation
import UIKit
import QuickTableViewController

class RunningCountSettings: GameTypeSettings {
    var title: String = "Running Count"
    init(vc: SettingsViewController) {
        self.vc = vc
    }
    var vc: SettingsViewController
    var sliderView: SliderTableViewCell!
    var radioSection: RadioSection!
    
    var tableSettings: [Section] {
        
        radioSection = RadioSection(title: "Ask for count every", options: [
            OptionRow(text: CountRounds.oneRound.rawValue, isSelected: Settings.shared.numberOfRoundsBeforeAskRunningCount == CountRounds.oneRound.rawValue, action: didToggleSelection()),
            OptionRow(text: CountRounds.threeRounds.rawValue, isSelected: Settings.shared.numberOfRoundsBeforeAskRunningCount == CountRounds.threeRounds.rawValue, action: didToggleSelection()),
            OptionRow(text: CountRounds.fiveRounds.rawValue, isSelected: Settings.shared.numberOfRoundsBeforeAskRunningCount == CountRounds.fiveRounds.rawValue, action: didToggleSelection()),
            OptionRow(text: CountRounds.onceAtEnd.rawValue, isSelected: Settings.shared.numberOfRoundsBeforeAskRunningCount == CountRounds.onceAtEnd.rawValue, action: didToggleSelection())
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
                        cell.selectionStyle = .default
                    },
                
                    action: { _ in
                        
                        self.sliderView.slider.setValue(Settings.shared.defaults.dealSpeed, animated: true)
                        self.sliderView.slider.sendActions(for: .valueChanged)
                        
                        if Settings.shared.numberOfRoundsBeforeAskRunningCount != Settings.shared.defaults.numberOfRoundsBeforeAskRunningCount {
                            let indexPath = IndexPath(row: 0, section: 2)
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
                Settings.shared.numberOfRoundsBeforeAskRunningCount = row.text
            }
        }
      }
    }
    
    func forcedSettings() {
        //Settings.shared.number
    }
}
