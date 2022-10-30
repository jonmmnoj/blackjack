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
    //var radioSection: RadioSection!
    var countSection: RadioSection!
    var settings = Settings.shared
    
    var deviationsCell: UITableViewCell!
    var discardTrayCell: UITableViewCell!
    var dealerHitsCell: UITableViewCell!
    //var enhcCell: UITableViewCell!
    var surrenderCell: UITableViewCell!
    var dasCell: UITableViewCell!
    var resplitCell: UITableViewCell!
    var notifyCell: UITableViewCell!
    var placeBetsCell: UITableViewCell!
    var sliderView: SliderTableViewCell!
    var penetrationViewCell: UITableViewCell!
    var numberOfDecksViewCell: UITableViewCell!
    var trueCountCell: UITableViewCell!
    var betSpreadCell: UITableViewCell!
    var ghostHandCell: UITableViewCell!
    var countBiasCell: UITableViewCell!
    var spotAssignmentCell: UITableViewCell!
    var tableOrientationCell: UITableViewCell!

    var navigateToOption: String?
    
    @objc private func setPenentrationSetting(notification: Notification) {
        let string = notification.object as! String
        penetrationViewCell.detailTextLabel?.text = string
        let selectedValue = Penetration.convertToDouble(string: string)
        Settings.shared.penetration = selectedValue
    }
    
    @objc private func setNumberOfDecksSetting(notification: Notification) {
        let string = notification.object as! String
        numberOfDecksViewCell.detailTextLabel?.text = string
        Settings.shared.numberOfDecks = Int(string)!
    }
    @objc private func setTableOrientationSetting(notification: Notification) {
        let string = notification.object as! String
        tableOrientationCell.detailTextLabel?.text = string
        Settings.shared.tableOrientation = string
        updateTableSettingControls()
    }
    
    private func updateTableSettingControls() {
        if Settings.shared.tableOrientation == TableOrientation.landscape.rawValue {
            ghostHandCell.isUserInteractionEnabled = false
            ghostHandCell.textLabel!.isEnabled = false
            (ghostHandCell.accessoryView as! UISwitch).isEnabled = false
            (ghostHandCell.accessoryView as! UISwitch).setOn(false, animated: true)
            (self.ghostHandCell.accessoryView as! UISwitch).sendActions(for: .valueChanged)
            //Settings.shared.ghostHand = false
            
            spotAssignmentCell.isUserInteractionEnabled = true
            spotAssignmentCell.textLabel!.isEnabled = true
        } else { // Portrait
            ghostHandCell.isUserInteractionEnabled = true
            ghostHandCell.textLabel!.isEnabled = true
            (ghostHandCell.accessoryView as! UISwitch).isEnabled = true
            
            spotAssignmentCell.isUserInteractionEnabled = false
            spotAssignmentCell.textLabel!.isEnabled = false
        }
    }
    
    @objc private func setAskForTrueCountSetting(notification: Notification) {
        let string = notification.object as! String
        trueCountCell.detailTextLabel?.text = string
        Settings.shared.numberOfRoundsBeforeAskTrueCount = string
    }
    
    @objc private func setBetSpreadSetting(notification: Notification) {
        betSpreadCell.detailTextLabel?.text = Settings.shared.betSpread ? "On" : "Off"
    }
    
    private func showViewSettingOptions(sectionTitle: String, data: [String], checkMarkedValue: String, notificationName: String, isBetSpreadTable: Bool = false) {
        let vc = SettingsListTableViewController(sectionTitle: sectionTitle, data: data, checkMarkedValue: checkMarkedValue, notificationName: notificationName)
        if isBetSpreadTable {
            vc.isBetSpreadTable = true
        }
        self.vc.navigationController?.pushViewController(vc, animated: true)
    }
    
    var tableSettings: [Section] {
        var sections = [
            Section(title: "", rows: [
               
                TapActionRow(
                    text: "Start",
                    customization: {(cell,row) in
                        cell.textLabel?.textColor = .systemGreen
                        cell.tintColor = .systemGreen
                        cell.textLabel?.font = .systemFont(ofSize: 20, weight: .bold)
                    },
                    action: { _ in
                        self.playClickSound()
                        
                        if Settings.shared.tableOrientation == TableOrientation.landscape.rawValue {
                            //let value = UIInterfaceOrientation.landscapeLeft.rawValue
                            //UIDevice.current.setValue(value, forKey: "orientation")
                            if Settings.shared.deviceType == .phone {
                                AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeLeft, andRotateTo: UIInterfaceOrientation.landscapeLeft)
                            }
                        } else if Settings.shared.tableOrientation == TableOrientation.portrait.rawValue {
                            //let value = UIInterfaceOrientation.portrait.rawValue
                            //UIDevice.current.setValue(value, forKey: "orientation")
                            if Settings.shared.deviceType == .phone {
                                AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
                            }
                        }
                        
                        self.vc.tableView.deselectRow(at: IndexPath(row:0, section: 0), animated: true)
                        let gvc = self.vc.storyboard!.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
                        gvc.gameType = Settings.shared.gameType
                        let nvc = UINavigationController(rootViewController: gvc)
                        nvc.modalPresentationStyle = .fullScreen
                        self.vc.present(nvc, animated: true, completion: nil)
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
                
                NavigationRow(text: "Penetration", detailText: .value1(""), customization: { cell, row in
                        self.penetrationViewCell = cell
                        self.penetrationViewCell.detailTextLabel?.text = Penetration.getStringValue(for: Settings.shared.penetration)
                        NotificationCenter.default.addObserver(self, selector: #selector(self.setPenentrationSetting(notification:)), name: Notification.Name("PenetrationSetting"), object: nil)
                    },
                      action: { row in
                          let values = Penetration.penetrationValues
                          var data = [String]()
                          for value in values {
                              data.append(Penetration.getStringValue(for: value))
                          }
                          let checkMarkedValue = Penetration.getStringValue(for: Settings.shared.penetration)
                          self.showViewSettingOptions(sectionTitle: row.text, data: data, checkMarkedValue: checkMarkedValue, notificationName: "PenetrationSetting")
                          return
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
                
               
                    
            ]),
            
            
            Section(title: "Strategy & Card Counting", rows: [
                
               
            
                SwitchRow(
                    text: "Notify on Mistakes",
                    switchValue: settings.notifyMistakes,
                      customization: { cell, row in
                        self.notifyCell = cell
                        (self.notifyCell.accessoryView as! UISwitch).setOn(self.settings.notifyMistakes, animated: false)
                      },
                      action: { _ in
                        self.settings.notifyMistakes = !self.settings.notifyMistakes
                          //self.setupWatchBetSpread()
                      }),
                
//                SwitchRow(
//                    text: "Place Bets",
//                    switchValue: settings.placeBets,
//                      customization: { cell, row in
//                        self.placeBetsCell = cell
//                        (self.placeBetsCell.accessoryView as! UISwitch).setOn(self.settings.placeBets, animated: false)
//                      },
//                      action: { _ in
//                        self.settings.placeBets = !self.settings.placeBets
//                      }),
//
//                NavigationRow(text: "Monitor Bet Spread", detailText: .value1(""), customization: { cell, row in
//                        self.betSpreadCell = cell
//                        self.betSpreadCell.detailTextLabel?.text = Settings.shared.betSpread ? "On" : "Off"
//                        NotificationCenter.default.addObserver(self, selector: #selector(self.setBetSpreadSetting(notification:)), name: Notification.Name("BetSpreadSetting"), object: nil)
//                    },
//                      action: { row in
//                          var data = BetSpread.trueCounts
//                          data.insert("switch row", at: 0)
//                          let checkMarkedValue = "-99"
//                          self.showViewSettingOptions(sectionTitle: row.text, data: data, checkMarkedValue: checkMarkedValue, notificationName: "BetSpreadSetting", isBetSpreadTable: true)
//                          return
//                      }),
                
                
                
//                SwitchRow(
//                    text: "Show Discard Tray",
//                    switchValue: settings.showDiscardTray,
//                    customization:  { (cell, row) in
//                        self.discardTrayCell = cell
//                        (self.discardTrayCell.accessoryView as! UISwitch).setOn(self.settings.showDiscardTray, animated: false)
//                    },action: { row in
//                        self.settings.showDiscardTray = !self.settings.showDiscardTray
//                    }),
                
                SwitchRow(
                    text: "Use Deviations",
                    switchValue: settings.deviations,
                      customization: { cell, row in
                        self.deviationsCell = cell
                        (self.deviationsCell.accessoryView as! UISwitch).setOn(self.settings.deviations, animated: false)
                      },
                      action: { _ in
                        self.settings.deviations = !self.settings.deviations
                      }),
                
                NavigationRow(text: "Ask for true count every", detailText: .value1(""), customization: { cell, row in
                        self.trueCountCell = cell
                    self.trueCountCell.detailTextLabel?.text = Settings.shared.numberOfRoundsBeforeAskTrueCount
                    NotificationCenter.default.addObserver(self, selector: #selector(self.setAskForTrueCountSetting(notification:)), name: Notification.Name("AskTrueCountSetting"), object: nil)
                    },
                      action: { row in
                          let values = CountRounds.allCases
                          var data = [String]()
                          for value in values {
                              data.append("\(value.rawValue)")
                          }
                          let checkMarkedValue = Settings.shared.numberOfRoundsBeforeAskTrueCount
                          self.showViewSettingOptions(sectionTitle: row.text, data: data, checkMarkedValue: checkMarkedValue, notificationName: "AskTrueCountSetting")
                          return
                      }),
                
                SwitchRow(
                    text: "Positive Count Bias",
                    switchValue: settings.countBias,
                      customization: { cell, row in
                        self.countBiasCell = cell
                        (self.countBiasCell.accessoryView as! UISwitch).setOn(self.settings.countBias, animated: false)
                      },
                      action: { _ in
                        self.settings.countBias = !self.settings.countBias
                      }),
                
                
            ]),
            
            Section(title: "Bets", rows: [
                
                SwitchRow(
                    text: "Place Bets",
                    switchValue: settings.placeBets,
                      customization: { cell, row in
                        self.placeBetsCell = cell
                        (self.placeBetsCell.accessoryView as! UISwitch).setOn(self.settings.placeBets, animated: false)
                      },
                      action: { _ in
                        self.settings.placeBets = !self.settings.placeBets
                      }),
                
                NavigationRow(text: "Monitor Bet Spread", detailText: .value1(""), customization: { cell, row in
                    self.betSpreadCell = cell
                    self.betSpreadCell.detailTextLabel?.text = Settings.shared.betSpread ? "On" : "Off"
                    NotificationCenter.default.addObserver(self, selector: #selector(self.setBetSpreadSetting(notification:)), name: Notification.Name("BetSpreadSetting"), object: nil)
                },
                  action: { row in
                      var data = BetSpread.trueCounts
                      data.insert("switch row", at: 0)
                      let checkMarkedValue = "-99"
                      self.showViewSettingOptions(sectionTitle: row.text, data: data, checkMarkedValue: checkMarkedValue, notificationName: "BetSpreadSetting", isBetSpreadTable: true)
                      return
                  }),
            ]),
            
            
            //Section(title: "Miscellaneous", rows: [
//                SwitchRow(
//                    text: "Ghost Hand",
//                    switchValue: settings.ghostHand,
//                      customization: { cell, row in
//                        self.ghostHandCell = cell
//                        (self.ghostHandCell.accessoryView as! UISwitch).setOn(self.settings.ghostHand, animated: false)
//                      },
//                      action: { _ in
//                        self.settings.ghostHand = !self.settings.ghostHand
//                      }),
//                SwitchRow(
//                    text: "Positive Count Bias",
//                    switchValue: settings.countBias,
//                      customization: { cell, row in
//                        self.countBiasCell = cell
//                        (self.countBiasCell.accessoryView as! UISwitch).setOn(self.settings.countBias, animated: false)
//                      },
//                      action: { _ in
//                        self.settings.countBias = !self.settings.countBias
//                      }),
//            ]),
            
            //countSection,
            
            //radioSection,
            
            Section(title: "Deal speed", rows: [
                TapActionRow<SliderTableViewCell>(
                  text: " ",
                customization: { cell, row in
                    self.sliderView = cell as? SliderTableViewCell
                    self.sliderView.initHandler = { slider in
                        return Settings.shared.dealSpeed
                    }
                    self.sliderView.setTextHandler = { value in
                        let percentage = Int(value * 10)
                        var message = "\(percentage)%"
                        if percentage == 0 { message = "<\(1)%" }
                        return message
                        
                    }
                    self.sliderView.changedValueHandler = { value in
                        let step: Float = 0.5
                        let roundedValue = round(value / step) * step
                        Settings.shared.dealSpeed = roundedValue
                        return roundedValue
                    }
                    self.sliderView.setup()
                },
                    action: { _ in
                        
                    }
                ),
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
                        cell.selectionStyle = .default //nil//UITableViewCell.SelectionStyle.none; default
                        //cell.tintColor = .systemBlue
                    },
                    action: { _ in
                        if self.sliderView.slider != nil {
                            self.sliderView.slider.setValue(Settings.shared.defaults.dealSpeed, animated: true)
                            self.sliderView.slider.sendActions(for: .valueChanged)
                            if self.sliderView.isHidden {
                                self.settings.dealSpeed = self.settings.defaults.dealSpeed
                            }
                        }
                        
                        
                        (self.dealerHitsCell.accessoryView as! UISwitch).setOn(self.settings.defaults.dealerHitsSoft17, animated: true)
                        (self.dealerHitsCell.accessoryView as! UISwitch).sendActions(for: .valueChanged)
                        // in case cell is off screen
                        if self.dealerHitsCell.isHidden {
                            self.settings.dealerHitsSoft17 = self.settings.defaults.dealerHitsSoft17
                        }
                        
                        (self.deviationsCell.accessoryView as! UISwitch).setOn(self.settings.defaults.deviations, animated: true)
                        (self.deviationsCell.accessoryView as! UISwitch).sendActions(for: .valueChanged)
                        // in case cell is off screen
                        if self.deviationsCell.isHidden {
                            self.settings.deviations = self.settings.defaults.deviations
                        }
                        
                        (self.discardTrayCell.accessoryView as! UISwitch).setOn(self.settings.defaults.showDiscardTray, animated: true)
                        (self.discardTrayCell.accessoryView as! UISwitch).sendActions(for: .valueChanged)
                        if self.discardTrayCell.isHidden {
                            self.settings.showDiscardTray = self.settings.defaults.showDiscardTray
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
                        
                        (self.placeBetsCell.accessoryView as! UISwitch).setOn(self.settings.defaults.placeBets, animated: true)
                        (self.placeBetsCell.accessoryView as! UISwitch).sendActions(for: .valueChanged)
                        if self.placeBetsCell.isHidden {
                            self.settings.placeBets = self.settings.defaults.placeBets
                        }
                        
                        if self.settings.numberOfDecks != self.settings.defaults.numberOfDecks {
                            self.settings.numberOfDecks = self.settings.defaults.numberOfDecks
                            NotificationCenter.default.post(name: Notification.Name("NumberOfDecksSetting"), object: String(self.settings.defaults.numberOfDecks))
                        }
                        
                        if self.settings.penetration != self.settings.defaults.penetration {
                            self.settings.penetration = self.settings.defaults.penetration
                            NotificationCenter.default.post(name: Notification.Name("PenetrationSetting"), object: Penetration.getStringValue(for: self.settings.defaults.penetration))
                        }
                        
                        if self.settings.numberOfRoundsBeforeAskTrueCount != self.settings.defaults.numberOfRoundsBeforeAskTrueCount {
                            self.settings.numberOfRoundsBeforeAskTrueCount = self.settings.defaults.numberOfRoundsBeforeAskTrueCount
                            NotificationCenter.default.post(name: Notification.Name("AskTrueCountSetting"), object: self.settings.defaults.numberOfRoundsBeforeAskTrueCount)
                        }
                        
                        if self.settings.betSpread != self.settings.defaults.betSpread {
                            self.settings.betSpread = self.settings.defaults.betSpread
                            NotificationCenter.default.post(name: Notification.Name("BetSpreadSetting"), object: nil)
                        }
                        
                        if (self.ghostHandCell != nil) {
                            (self.ghostHandCell.accessoryView as! UISwitch).setOn(self.settings.defaults.ghostHand, animated: true)
                            (self.ghostHandCell.accessoryView as! UISwitch).sendActions(for: .valueChanged)
                            if self.ghostHandCell.isHidden {
                                self.settings.ghostHand = self.settings.defaults.ghostHand
                            }
                        }
                        (self.countBiasCell.accessoryView as! UISwitch).setOn(self.settings.defaults.countBias, animated: true)
                        (self.countBiasCell.accessoryView as! UISwitch).sendActions(for: .valueChanged)
                        if self.countBiasCell.isHidden {
                            self.settings.countBias = self.settings.defaults.countBias
                        }
                        
                        Settings.shared.resetSpotAssignments()
                        
                        
//                        if Settings.shared.numberOfRoundsBeforeAskTrueCount != Settings.shared.defaults.numberOfRoundsBeforeAskTrueCount {
//                            let indexPath = IndexPath(row: 3, section: 3)
//                            self.vc.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
//                            self.vc.tableView.delegate?.tableView!(self.vc.tableView, didSelectRowAt: indexPath)
//                        }
                        
//                        if Settings.shared.numberOfDecks != Settings.shared.defaults.numberOfDecks {
//                            let indexPath = IndexPath(row: 2, section: 4)
//                            self.vc.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
//                            self.vc.tableView.delegate?.tableView!(self.vc.tableView, didSelectRowAt: indexPath)
//                        }
                        
                    })
            ]),
        ]
        
        if Settings.shared.deviceType == .phone {
            let tableSection = Section(title: "Table", rows: [
                NavigationRow(text: "Orientation", detailText: .value1(""), customization: { cell, row in
                        self.tableOrientationCell = cell
                        self.tableOrientationCell.detailTextLabel?.text = Settings.shared.tableOrientation
                        NotificationCenter.default.addObserver(self, selector: #selector(self.setTableOrientationSetting(notification:)), name: Notification.Name("TableOrientationSetting"), object: nil)
                        
                    },
                      action: { row in
                          let values = TableOrientation.allCases
                          var data = [String]()
                          for value in values {
                              data.append(value.rawValue)
                          }
                          let checkMarkedValue = Settings.shared.tableOrientation
                          self.showViewSettingOptions(sectionTitle: row.text, data: data, checkMarkedValue: checkMarkedValue, notificationName: "TableOrientationSetting")
                          return
                }),
                
                NavigationRow(text: "Spot Assignments", detailText: .value1(""), customization: { cell, row in
                        self.spotAssignmentCell = cell
                        self.spotAssignmentCell.detailTextLabel?.text = ""
                    
                    },
                      action: { row in
                          let vc = SettingsViewController()
                          vc.subSettings = true
                          let sas = SpotAssignmentSettings(vc: self.vc)
                          //sas.title = self.title
                          vc.subSettingsGTS = sas
                          self.vc.navigationController?.pushViewController(vc, animated: true)
                        
                }),
                
                SwitchRow(
                    text: "Ghost Hand",
                    switchValue: settings.ghostHand,
                      customization: { cell, row in
                        self.ghostHandCell = cell
                        (self.ghostHandCell.accessoryView as! UISwitch).setOn(self.settings.ghostHand, animated: false)
                          self.updateTableSettingControls()
                      },
                      action: { _ in
                        self.settings.ghostHand = !self.settings.ghostHand
                }),
                
                SwitchRow(
                    text: "Show Discard Tray",
                    switchValue: settings.showDiscardTray,
                    customization:  { (cell, row) in
                        self.discardTrayCell = cell
                        (self.discardTrayCell.accessoryView as! UISwitch).setOn(self.settings.showDiscardTray, animated: false)
                    },action: { row in
                        self.settings.showDiscardTray = !self.settings.showDiscardTray
                    }),
            ])
            sections.insert(tableSection, at: 1)
        }
        else { // Pad
            let tableSection = Section(title: "Table", rows: [
                
                NavigationRow(text: "Spot Assignments", detailText: .value1(""), customization: { cell, row in
                        self.spotAssignmentCell = cell
                        self.spotAssignmentCell.detailTextLabel?.text = ""
                    
                    },
                      action: { row in
                          let vc = SettingsViewController()
                          vc.subSettings = true
                          let sas = SpotAssignmentSettings(vc: self.vc)
                          //sas.title = self.title
                          vc.subSettingsGTS = sas
                          self.vc.navigationController?.pushViewController(vc, animated: true)
                        
                }),
                
                SwitchRow(
                    text: "Show Discard Tray",
                    switchValue: settings.showDiscardTray,
                    customization:  { (cell, row) in
                        self.discardTrayCell = cell
                        (self.discardTrayCell.accessoryView as! UISwitch).setOn(self.settings.showDiscardTray, animated: false)
                    },action: { row in
                        self.settings.showDiscardTray = !self.settings.showDiscardTray
                    }),
             ])
            sections.insert(tableSection, at: 1)
        }
    
    
        
        return sections
    }
    
    func registerCustomViews(for tableView: UITableView) {
        let cell = UINib(nibName: "SliderTableViewCell", bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: "SliderTableViewCell")
    }
    
}

