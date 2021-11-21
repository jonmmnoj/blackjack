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
    var tableColorData: [String] {
        var data = [String]()
        let colors = TableColor.allCases
        for color in colors {
            data.append(color.rawValue)
        }
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

    override func viewDidLoad() {
        super.viewDidLoad()
        cardSizeFactorOnLoad = Settings.shared.cardSizeFactor
        cardColorOnLoad = Settings.shared.cardColor
        registerCustomViews(for: tableView)
        
        tableContents = [
            Section(title: "UI Scale", rows: [
                TapActionRow<SliderTableViewCell>(
                  text: " ",
                customization: { cell, row in
                    self.sliderView = cell as? SliderTableViewCell
                    self.sliderView.initHandler = { slider in
                        slider.maximumValue = 5.5
                        slider.minimumValue = 4.5
                        print(Settings.shared.cardSizeFactor)
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
            
            Section(title: "", rows: [
            
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
            
//            SwitchRow(
//                text: "UI Gestures",
//                switchValue: Settings.shared.placeBets,
//                  customization: { cell, row in
//                    self.placeBetsCell = cell
//                    (self.placeBetsCell.accessoryView as! UISwitch).setOn(self.settings.placeBets, animated: false)
//                  },
//                  action: { _ in
//                    Settings.shared.placeBets = !Settings.shared.placeBets
//                  }),
//
//
//            SwitchRow(
//                text: "Use Buttons",
//                switchValue: Settings.shared.placeBets,
//                  customization: { cell, row in
//                    self.placeBetsCell = cell
//                    (self.placeBetsCell.accessoryView as! UISwitch).setOn(self.settings.placeBets, animated: false)
//                  },
//                  action: { _ in
//                      Settings.shared.placeBets = !Settings.shared.placeBets
//                  }),
//
//
//            SwitchRow(
//                text: "Buttons on left side",
//                switchValue: Settings.shared.placeBets,
//                  customization: { cell, row in
//                    self.placeBetsCell = cell
//                    (self.placeBetsCell.accessoryView as! UISwitch).setOn(self.settings.placeBets, animated: false)
//                  },
//                  action: { _ in
//                      Settings.shared.placeBets = !Settings.shared.placeBets
//                  }),
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

    override func viewWillDisappear(_ animated: Bool) {
        // update card sizes
        // update discard tray size
        // update buttons size or hide/show (right or left)
        // enable/disable gestures
        // update table colors
        gameVC.gameMaster!.dealer.table.view.backgroundColor = UIColor(hex: TableColor(rawValue: Settings.shared.tableColor)!.tableCode)
        gameVC.gameMaster!.dealer.table.discardTray.button.backgroundColor = UIColor(hex: TableColor(rawValue: Settings.shared.buttonColor)!.buttonCode)
        gameVC.setButtonColor()
        
       
        
        if cardSizeFactorOnLoad != Settings.shared.cardSizeFactor {
            gameVC.adjustStackviewSizeForScaleChange()
            gameVC.gameMaster.dealer.table.discardTray.adjustSizeForScaleChange()
            
            var changeX: CGFloat = 0
            var changeY: CGFloat = 0
            for (i, hand) in gameVC.gameMaster!.player!.hands.enumerated() {
                if i == 0 {
                    changeX = hand.originPoint.x - gameVC.gameMaster!.playerHandDealPoint.x
                    changeY = hand.originPoint.y - gameVC.gameMaster!.playerHandDealPoint.y
                }
                hand.adjustForScaleChange(dealPoint: gameVC.gameMaster!.playerHandDealPoint, adjustmentX: gameVC.gameMaster!.playerAdjustmentXorY, adjustmentY: gameVC.gameMaster!.playerAdjustmentXorY, changeInDealPointX: changeX, changeInDealPointY: changeY)
                
                for card in hand.cards {
                    //card.adjustSizeForScaleChange()
                    card.adjustSizeForScaleChange(changeX: changeX, changeY: changeY)
                    //card.layoutSublayers(of: card.view!.layer)
                }
                if hand === gameVC.gameMaster!.player!.activatedHand {
                    gameVC.gameMaster!.dealer!.table.stopIndicator()
                    gameVC.gameMaster!.dealer!.table.showIndicator(on: hand)
                }
            }
            
            for (i, hand) in gameVC.gameMaster!.dealer!.hands.enumerated() {
                if i == 0 {
                    changeX = hand.originPoint.x - gameVC.gameMaster!.dealerHandDealPoint.x
                    changeY = hand.originPoint.y - gameVC.gameMaster!.dealerHandDealPoint.y
                }
                hand.adjustForScaleChange(dealPoint: gameVC.gameMaster!.dealerHandDealPoint, adjustmentX: gameVC.gameMaster!.dealerHandAdjustmentX, adjustmentY: gameVC.gameMaster!.dealerHandAdjustmentY, changeInDealPointX: changeX, changeInDealPointY: changeY)
                for card in hand.cards {
                    //card.adjustSizeForScaleChange()
                    card.adjustSizeForScaleChange(changeX: changeX, changeY: changeY)
                    //card.layoutSublayers(of: card.view!.layer)
                    
                }
            }
        }
        
        if cardColorOnLoad != Settings.shared.cardColor {
            for hand in gameVC.gameMaster!.dealer!.hands {
                for card in hand.cards {
                    if card.isFaceDown {
                        card.backView?.image = UIImage(named: card.backImageName())
                    }
                }
            }
        }
        
//        gm.dealer.table.view.setNeedsDisplay()
//        gm.dealer.table.view.setNeedsLayout()
//        gm.dealer.table.view.layoutIfNeeded()
//
//       gameVC.view.setNeedsDisplay()
//        gameVC.view.setNeedsLayout()
//        gameVC.view.layoutIfNeeded()
        
    }
}
