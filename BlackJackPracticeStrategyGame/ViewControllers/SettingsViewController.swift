//
//  SettingsViewController.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/24/21.
//

import UIKit
import QuickTableViewController

class SettingsViewController: QuickTableViewController {
    var gameType: GameType!
    
    var surrenderCell: UITableViewCell!
    var es10Cell: UITableViewCell!
    var enhcCell: UITableViewCell!
    var twoHandCell: UITableViewCell!
    var threeHandCell: UITableViewCell!
    var fourHandCell: UITableViewCell!
    var splitCell: UITableViewCell!
    var softCell: UITableViewCell!
    var hardCell: UITableViewCell!
    
    var settings = Settings.shared
    
    private func alert(message: String) {
        let alert = UIAlertController(title: "Settings required for:", message: message, preferredStyle: .alert)

        //alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"

        tableContents = [
            Section(title: "", rows: [
                TapActionRow(
                    text: "Start",
                    customization: {(cell,row) in
                        cell.backgroundColor = .systemGreen
                        cell.textLabel?.textColor = .white
                        cell.textLabel?.font = .systemFont(ofSize: 20, weight: .bold)
                        cell.selectionStyle = UITableViewCell.SelectionStyle.none;
                        cell.tintColor = .white
                        //cell.frame.height = cell.frame.height * 2
                    },
                    action: { _ in
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
                        
                        let vc = self.storyboard!.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
                        vc.gameType = self.gameType
                        vc.edgesForExtendedLayout = .all
                        self.navigationController?.pushViewController(vc, animated: true)
                    })
            ]),
        
            Section(title: "Rules", rows: [
                SwitchRow(
                    text: "ENHC",
                    switchValue: settings.ENHC,
                    customization:  { (cell, row) in
                        self.enhcCell = cell
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

            Section(title: "Number of Cards", rows: [
                SwitchRow(text: "2 card hands", switchValue: settings.twoCardHands, customization: {cell,row in
                    self.twoHandCell = cell
                },
                          action: { _ in
                    self.settings.twoCardHands = !self.settings.twoCardHands
                            print("two card: \(self.settings.twoCardHands)")
                    self.setupSplitControl()
                }),
                SwitchRow(text: "3 card hands", switchValue: settings.threeCardHands, customization: {cell,row in
                    self.threeHandCell = cell
                }, action: { _ in
                    self.settings.threeCardHands = !self.settings.threeCardHands
                }),
                SwitchRow(text: "4 card hands", switchValue: settings.fourCardHands, customization: {cell,row in
                    self.fourHandCell = cell
                }, action: { _ in
                    self.settings.fourCardHands = !self.settings.fourCardHands
                })
            ]),
        
            Section(title: "Type of Hand", rows: [
                SwitchRow(text: "Split", switchValue: settings.splitHands,
                          customization: { cell, row in
                            self.splitCell = cell
                          },
                          action: { _ in
                            self.settings.splitHands = !self.settings.splitHands
                            print("split: \(self.settings.splitHands)")
                          }),
                SwitchRow(text: "Soft", switchValue: settings.softHands, customization: {cell,row in
                    self.softCell = cell
                }, action: { _ in
                    self.settings.softHands = !self.settings.softHands
                }),
                SwitchRow(text: "Hard", switchValue: settings.hardHands, customization: {cell,row in
                    self.hardCell = cell
                }, action: { _ in
                    self.settings.hardHands = !self.settings.hardHands
                })
            ]),
        
            Section(title: "", rows: [
                TapActionRow(
                    text: "Reset to defaults",
                    customization: {(cell,row) in
                        cell.textLabel?.textColor = .systemRed
                    },
                    action: { _ in
                        (self.enhcCell.accessoryView as! UISwitch).setOn(false, animated: true)
                        (self.enhcCell.accessoryView as! UISwitch).sendActions(for: .valueChanged)
                        
                        (self.surrenderCell.accessoryView as! UISwitch).setOn(true, animated: true)
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
                        
                        // MAKE SURE this call is after change to split hand, because this control's action handler effects split control
                        (self.twoHandCell.accessoryView as! UISwitch).setOn(true, animated: true)
                        (self.twoHandCell.accessoryView as! UISwitch).sendActions(for: .valueChanged)
                    })
            ]),
        ]
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

    // MARK: - Actions

    private func showAlert(_ sender: Row) {
      // ...
    }
}



    
