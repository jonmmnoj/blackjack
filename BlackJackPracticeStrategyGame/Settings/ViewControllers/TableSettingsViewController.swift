//
//  TableSettingsViewController.swift
//  BlackJackPracticeStrategyGame
//
//  Created by Jon on 11/10/21.
//

import Foundation
import QuickTableViewController

class TableSettingsViewController: QuickTableViewController {
    
    var gameVC: GameViewController!
    var sliderView: SliderTableViewCell!
    var tableColorCell: UITableViewCell!
    var buttonColorCell: UITableViewCell!
    var cardColorCell: UITableViewCell!
    var gestureCell: UITableViewCell!
    var showButtonsCell: UITableViewCell!
    var leftButtonsCell: UITableViewCell!
    var useGesturesCell: UITableViewCell!
    var useButtonsCell: UITableViewCell!
    var buttonsOnLeftCell: UITableViewCell!
    var handTotalsCell: UITableViewCell!
    var cardsAskewCell: UITableViewCell!
    var dealDoubleFaceDownCell: UITableViewCell!
    var soundCell: UITableViewCell!
    var dealSpeedCell: SliderTableViewCell!
    var tableColorData: [String] {
        var data = [String]()
        let colors = TableColor.allCases
        for color in colors {
            data.append(color.rawValue)
        }
        data.sort()
        return data
    }
    var cardColorData: [String] {
        var data = [String]()
        let colors = CardColor.allCases
        for color in colors {
            data.append(color.rawValue)
        }
        return data
    }
    
    @objc private func setTableColor(notification: Notification) {
        let string = notification.object as! String
        tableColorCell.detailTextLabel?.text = string
        Settings.shared.tableColor = string
    }
    
    @objc private func setButtonColor(notification: Notification) {
        let string = notification.object as! String
        buttonColorCell.detailTextLabel?.text = string
        Settings.shared.buttonColor = string
    }
    
    @objc private func setCardColor(notification: Notification) {
        let string = notification.object as! String
        cardColorCell.detailTextLabel?.text = string
        Settings.shared.cardColor = string
    }
    
    private func showViewSettingOptions(sectionTitle: String, data: [String], checkMarkedValue: String, notificationName: String, isBetSpreadTable: Bool = false) {
        let vc = SettingsListTableViewController(sectionTitle: sectionTitle, data: data, checkMarkedValue: checkMarkedValue, notificationName: notificationName)
        if isBetSpreadTable {
            vc.isBetSpreadTable = true
        }
        //vc.title = $0.text //+ ($0.detailText?.text ?? "")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    var cardSizeFactorOnLoad: Float!
    var cardColorOnLoad: String!
    var showHandValueOnLoad: Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        cardSizeFactorOnLoad = Settings.shared.cardSizeFactor
        cardColorOnLoad = Settings.shared.cardColor
        showHandValueOnLoad = Settings.shared.showHandTotal
        registerCustomViews(for: tableView)
        
        tableContents = [
            
            Section(title: "Colors", rows: [
            
            NavigationRow(text: "Table Color", detailText: .value1(""), customization: { cell, row in
                    self.tableColorCell = cell
                    self.tableColorCell.detailTextLabel?.text = Settings.shared.tableColor
                    NotificationCenter.default.addObserver(self, selector: #selector(self.setTableColor(notification:)), name: Notification.Name("TableColorSetting"), object: nil)
                },
                  action: { row in
                      let checkMarkedValue = Settings.shared.tableColor
                      self.showViewSettingOptions(sectionTitle: row.text, data: self.tableColorData, checkMarkedValue: checkMarkedValue, notificationName: "TableColorSetting")
                      return
                  }),
            
            NavigationRow(text: "Button Color", detailText: .value1(""), customization: { cell, row in
                    self.buttonColorCell = cell
                self.buttonColorCell.detailTextLabel?.text = Settings.shared.buttonColor
                NotificationCenter.default.addObserver(self, selector: #selector(self.setButtonColor(notification:)), name: Notification.Name("ButtonColorSetting"), object: nil)
            },
              action: { row in
                  let checkMarkedValue = Settings.shared.buttonColor
                  self.showViewSettingOptions(sectionTitle: row.text, data: self.tableColorData, checkMarkedValue: checkMarkedValue, notificationName: "ButtonColorSetting")
                  return
              }),
            
            NavigationRow(text: "Card Color", detailText: .value1(""), customization: { cell, row in
                    self.cardColorCell = cell
                    self.cardColorCell.detailTextLabel?.text = Settings.shared.cardColor
                NotificationCenter.default.addObserver(self, selector: #selector(self.setCardColor(notification:)), name: Notification.Name("CardColorSetting"), object: nil)
            },
              action: { row in
                  let checkMarkedValue = Settings.shared.cardColor
                  self.showViewSettingOptions(sectionTitle: row.text, data: self.cardColorData, checkMarkedValue: checkMarkedValue, notificationName: "CardColorSetting")
                  return
              }),
            ]),
            
            Section(title: "Input", rows: [
                SwitchRow(
                    text: "Use Gestures",
                    switchValue: Settings.shared.useGestures,
                    //icon: .named("gear"),
                    customization: { cell, row in
                        self.useGesturesCell = cell
                      },
                    action: { _ in
                        Settings.shared.useGestures = !Settings.shared.useGestures
                      }),
                
                SwitchRow(
                    text: "Use Buttons",
                    switchValue: Settings.shared.useButtons,
                      customization: { cell, row in
                        self.useButtonsCell = cell
                      },
                      action: { _ in
                        Settings.shared.useButtons = !Settings.shared.useButtons
                      }),
                
                SwitchRow(
                    text: "Buttons on Left Side",
                    switchValue: Settings.shared.buttonsOnLeft,
                      customization: { cell, row in
                        self.buttonsOnLeftCell = cell
                      },
                      action: { _ in
                        Settings.shared.buttonsOnLeft = !Settings.shared.buttonsOnLeft
                      }),
                
                
            ]),
            
            Section(title: "Miscellaneous", rows: [
                SwitchRow(
                    text: "Show Hand Totals",
                    switchValue: Settings.shared.showHandTotal,
                      customization: { cell, row in
                        self.handTotalsCell = cell
                      },
                      action: { _ in
                        Settings.shared.showHandTotal = !Settings.shared.showHandTotal
                      }),
                SwitchRow(
                    text: "Sound Effects",
                    switchValue: Settings.shared.soundOn,
                      customization: { cell, row in
                        self.soundCell = cell
                      },
                      action: { _ in
                        Settings.shared.soundOn = !Settings.shared.soundOn
                      }),
                SwitchRow(
                    text: "Cards Dealt Askew",
                    switchValue: Settings.shared.cardsAskew,
                      customization: { cell, row in
                        self.cardsAskewCell = cell
                      },
                      action: { _ in
                        Settings.shared.cardsAskew = !Settings.shared.cardsAskew
                      }),
    
                SwitchRow(
                    text: "Deal Double Face Down",
                    switchValue: Settings.shared.dealDoubleFaceDown,
                      customization: { cell, row in
                        self.dealDoubleFaceDownCell = cell
                      },
                      action: { _ in
                        Settings.shared.dealDoubleFaceDown = !Settings.shared.dealDoubleFaceDown
                      }),
                ]),
            
            
            Section(title: "UI Scale", rows: [
                TapActionRow<SliderTableViewCell>(
                  text: " ",
                customization: { cell, row in
                    self.sliderView = cell as? SliderTableViewCell
                    self.sliderView.initHandler = { slider in
                        slider.maximumValue = 5.5
                        slider.minimumValue = 4.5
                      //  print(Settings.shared.cardSizeFactor)
                        return Settings.shared.cardSizeFactor
                    }
                    self.sliderView.setTextHandler = { value in
                        let num = Int(((value - 5.0) * 10).rounded())
                        var str = "\(num)"
                        if num > 0 { str = "+" + str }
                        return str
                        
                    }
                    self.sliderView.changedValueHandler = { value in
                        let step: Float = 0.1
                        let roundedValue = round(value / step) * step
                        Settings.shared.cardSizeFactor = roundedValue
                        return roundedValue
                    }
                    self.sliderView.setup()
                },
                    action: { _ in
                        
                    }
                ),
            ]),
            
            Section(title: "Deal speed", rows: [
                TapActionRow<SliderTableViewCell>(
                  text: " ",
                customization: { cell, row in
                    self.dealSpeedCell = cell as? SliderTableViewCell
                    self.dealSpeedCell.initHandler = { slider in
                        return Settings.shared.dealSpeed
                    }
                    self.dealSpeedCell.setTextHandler = { value in
                        let percentage = Int(value * 10)
                        var message = "\(percentage)%"
                        if percentage == 0 { message = "<\(1)%" }
                        return message
                        
                    }
                    self.dealSpeedCell.changedValueHandler = { value in
                        let step: Float = 0.5
                        let roundedValue = round(value / step) * step
                        Settings.shared.dealSpeed = roundedValue
                        return roundedValue
                    }
                    self.dealSpeedCell.setup()
                },
                    action: { _ in
                        
                    }
                ),
            ])
        ]
      }

      // MARK: - Actions

      private func showAlert(_ sender: Row) {
          gameVC.gameMaster.tableView.backgroundColor = .red
      }
    
    func registerCustomViews(for tableView: UITableView) {
        let cell = UINib(nibName: "SliderTableViewCell", bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: "SliderTableViewCell")
    }

    
}
