//
//  RunningCountSettings_v2.swift
//  BlackJackPracticeStrategyGame
//
//  Created by Jon on 11/28/21.
//

import UIKit
import QuickTableViewController

class RunningCountSettings_v2: GameTypeSettings {
    var title: String = "Running Count #1"
    init(vc: SettingsViewController) {
        self.vc = vc
    }
    var vc: SettingsViewController
    var sliderView: SliderTableViewCell!
    var numberOfDecksCell: UITableViewCell!
    var numberOfStacksCell: UITableViewCell!
    var dealPairsCell: UITableViewCell!
    
    @objc private func setNumberOfDecksSetting(notification: Notification) {
        let string = notification.object as! String
        numberOfDecksCell.detailTextLabel?.text = string
        Settings.shared.rcNumberOfCards = Int(string)!
    }
    @objc private func setNumberOfStacksSetting(notification: Notification) {
        let string = notification.object as! String
        numberOfStacksCell.detailTextLabel?.text = string
        Settings.shared.rcNumberOfStacks = Int(string)!
    }
    
    private func showViewSettingOptions(sectionTitle: String, data: [String], checkMarkedValue: String, notificationName: String) {
        let vc = SettingsListTableViewController(sectionTitle: sectionTitle, data: data, checkMarkedValue: checkMarkedValue, notificationName: notificationName)
        //vc.title = $0.text //+ ($0.detailText?.text ?? "")
        self.vc.navigationController?.pushViewController(vc, animated: true)
    }
    
    var tableSettings: [Section] {
        
        
        
//        radioSection = RadioSection(title: "Ask for count every", options: [
//            OptionRow(text: CountRounds.oneRound.rawValue, isSelected: Settings.shared.numberOfRoundsBeforeAskRunningCount == CountRounds.oneRound.rawValue, action: didToggleSelection()),
//            OptionRow(text: CountRounds.threeRounds.rawValue, isSelected: Settings.shared.numberOfRoundsBeforeAskRunningCount == CountRounds.threeRounds.rawValue, action: didToggleSelection()),
//            OptionRow(text: CountRounds.fiveRounds.rawValue, isSelected: Settings.shared.numberOfRoundsBeforeAskRunningCount == CountRounds.fiveRounds.rawValue, action: didToggleSelection()),
//            OptionRow(text: CountRounds.onceAtEnd.rawValue, isSelected: Settings.shared.numberOfRoundsBeforeAskRunningCount == CountRounds.onceAtEnd.rawValue, action: didToggleSelection())
//        ] /*, footer: "See RadioSection for more details."*/)
//        radioSection.alwaysSelectsOneOption = true
        
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
                        //gvc.gearButton.isHidden = true
                        let nvc = UINavigationController(rootViewController: gvc)
                        nvc.modalPresentationStyle = .fullScreen
                        self.vc.present(nvc, animated: true, completion: nil)
                        //gvc.modalPresentationStyle = .overFullScreen
                        //self.vc.present(gvc, animated: true, completion: nil)
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
            
            Section(title: "", rows: [
                NavigationRow(text: "Number of Cards", detailText: .value1(""), customization: { cell, row in
                        self.numberOfDecksCell = cell
                    self.numberOfDecksCell.detailTextLabel?.text = "\(Settings.shared.rcNumberOfCards)"
                    NotificationCenter.default.addObserver(self, selector: #selector(self.setNumberOfDecksSetting(notification:)), name: Notification.Name("AskNumberOfDecksSetting"), object: nil)
                    },
                      action: { row in
                         
                          let data = ["52", "104", "156", "208", "260", "312"]
                          let checkMarkedValue = "\(Settings.shared.rcNumberOfCards)"
                          self.showViewSettingOptions(sectionTitle: row.text, data: data, checkMarkedValue: checkMarkedValue, notificationName: "AskNumberOfDecksSetting")
                          return
                      }),
                NavigationRow(text: "Number of Stacks", detailText: .value1(""), customization: { cell, row in
                        self.numberOfStacksCell = cell
                    self.numberOfStacksCell.detailTextLabel?.text = "\(Settings.shared.rcNumberOfStacks)"
                    NotificationCenter.default.addObserver(self, selector: #selector(self.setNumberOfStacksSetting(notification:)), name: Notification.Name("AskNumberOfStacksSetting"), object: nil)
                    },
                      action: { row in
                         
                          let data = ["1", "2", "3", "4"]
                          let checkMarkedValue = "\(Settings.shared.rcNumberOfStacks)"
                          self.showViewSettingOptions(sectionTitle: row.text, data: data, checkMarkedValue: checkMarkedValue, notificationName: "AskNumberOfStacksSetting")
                          return
                      }),
                SwitchRow(
                    text: "Deal in Pairs",
                    switchValue: Settings.shared.rcDealInPairs,
                      customization: { cell, row in
                        self.dealPairsCell = cell
                      },
                      action: { _ in
                          Settings.shared.rcDealInPairs = !Settings.shared.rcDealInPairs
                      }),
            
            ]),
            
            //radioSection,
            
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
//                        if Settings.shared.numberOfRoundsBeforeAskRunningCount != Settings.shared.defaults.numberOfRoundsBeforeAskRunningCount {
//                            let indexPath = IndexPath(row: 0, section: 2)
//                            self.vc.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
//                            self.vc.tableView.delegate?.tableView!(self.vc.tableView, didSelectRowAt: indexPath)
//                        }
//                        
//                        if Settings.shared.numberOfRoundsBeforeAskRunningCount != Settings.shared.defaults.numberOfRoundsBeforeAskRunningCount {
//                            Settings.shared.numberOfRoundsBeforeAskRunningCount = Settings.shared.defaults.numberOfRoundsBeforeAskRunningCount
//                            NotificationCenter.default.post(name: Notification.Name("AskRunningCountSetting"), object: Settings.shared.defaults.numberOfRoundsBeforeAskRunningCount)
//                        }
//                        
//                    })
//            ]),
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
