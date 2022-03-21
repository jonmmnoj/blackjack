//
//  RunningCountSettings.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/26/21.
//

import UIKit
import QuickTableViewController

class RunningCountSettings: GameTypeSettings {
    var title: String = "Running Count #2"
    init(vc: SettingsViewController) {
        self.vc = vc
    }
    var vc: SettingsViewController
    var sliderView: SliderTableViewCell!
    var runningCountView: UITableViewCell!
    var spotsCell: UITableViewCell!
    var ghostHandCell: UITableViewCell!
    var tableOrientationCell: UITableViewCell!
    
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
            
            spotsCell.isUserInteractionEnabled = true
            spotsCell.textLabel!.isEnabled = true
            spotsCell.detailTextLabel?.text = String(Settings.shared.rcNumberOfSpots)
        } else { // Portrait
            ghostHandCell.isUserInteractionEnabled = true
            ghostHandCell.textLabel!.isEnabled = true
            (ghostHandCell.accessoryView as! UISwitch).isEnabled = true
            
            spotsCell.isUserInteractionEnabled = false
            spotsCell.textLabel!.isEnabled = false
            spotsCell.detailTextLabel?.text = ""
        }
    }
    
    @objc private func setAskForRunningCountSetting(notification: Notification) {
        let string = notification.object as! String
        runningCountView.detailTextLabel?.text = string
        Settings.shared.numberOfRoundsBeforeAskRunningCount = string
    }
    @objc private func setRunningCountSpotsSetting(notification: Notification) {
        let string = notification.object as! String
        spotsCell.detailTextLabel?.text = string
        Settings.shared.rcNumberOfSpots = Int(string)!
    }
    
    private func showViewSettingOptions(sectionTitle: String, data: [String], checkMarkedValue: String, notificationName: String) {
        let vc = SettingsListTableViewController(sectionTitle: sectionTitle, data: data, checkMarkedValue: checkMarkedValue, notificationName: notificationName)
        self.vc.navigationController?.pushViewController(vc, animated: true)
    }
    
    var numberOfSpotsSection: Row & RowStyle {
        //if Settings.shared.landscape {
            return NavigationRow(text: "Number of Spots", detailText: .value1(""), customization: { cell, row in
                    self.spotsCell = cell
                    self.spotsCell.detailTextLabel?.text = String(Settings.shared.rcNumberOfSpots)
                    NotificationCenter.default.addObserver(self, selector: #selector(self.setRunningCountSpotsSetting(notification:)), name: Notification.Name("RunningCountSpotsSetting"), object: nil)
                },
                  action: { row in
                let values = Settings.shared.deviceType == .phone ? [1,2,3,4,5] : [1,2,3,4,5,6,7]
                      var data = [String]()
                      for value in values {
                          data.append("\(value)")
                      }
                    let checkMarkedValue = String(Settings.shared.rcNumberOfSpots)
                      self.showViewSettingOptions(sectionTitle: row.text, data: data, checkMarkedValue: checkMarkedValue, notificationName: "RunningCountSpotsSetting")
                      return
                  })
       // }
    }
    
    var tableSettings: [Section] {
        var sections = [
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
                        gvc.gearButton.isHidden = true
                        let nvc = UINavigationController(rootViewController: gvc)
                        nvc.modalPresentationStyle = .fullScreen
                        self.vc.present(nvc, animated: true, completion: nil)
                    })
            ]),
            
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
            
            Section(title: "Card counting", rows: [
                //numberOfSpotsSection,
                NavigationRow(text: "Ask for true count every", detailText: .value1(""), customization: { cell, row in
                        self.runningCountView = cell
                    self.runningCountView.detailTextLabel?.text = Settings.shared.numberOfRoundsBeforeAskRunningCount
                    NotificationCenter.default.addObserver(self, selector: #selector(self.setAskForRunningCountSetting(notification:)), name: Notification.Name("AskRunningCountSetting"), object: nil)
                    },
                      action: { row in
                          let values = CountRounds.allCases
                          var data = [String]()
                          for value in values {
                              data.append("\(value.rawValue)")
                          }
                          let checkMarkedValue = Settings.shared.numberOfRoundsBeforeAskRunningCount
                          self.showViewSettingOptions(sectionTitle: row.text, data: data, checkMarkedValue: checkMarkedValue, notificationName: "AskRunningCountSetting")
                          return
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
                
                numberOfSpotsSection,
                
                SwitchRow(
                    text: "Ghost Hand",
                    switchValue: Settings.shared.ghostHand,
                      customization: { cell, row in
                        self.ghostHandCell = cell
                        (self.ghostHandCell.accessoryView as! UISwitch).setOn(Settings.shared.ghostHand, animated: false)
                          self.updateTableSettingControls()
                      },
                      action: { _ in
                        Settings.shared.ghostHand = !Settings.shared.ghostHand
                })
            ])
            sections.insert(tableSection, at: 1)
        }
        else { // Pad
            let tableSection = Section(title: "Table", rows: [
                
                numberOfSpotsSection
             ])
            sections.insert(tableSection, at: 1)
        }
    
    
        
        return sections
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
}
