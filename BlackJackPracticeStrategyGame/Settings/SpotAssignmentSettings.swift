//
//  SpotAssignmentSetting.swift
//  BlackJackPracticeStrategyGame
//
//  Created by Jon on 12/14/21.
//

import UIKit
import QuickTableViewController

class SpotAssignmentSettings: GameTypeSettings {
    var title: String = ""
    init(vc: SettingsViewController) {
        self.vc = vc
    }
    var vc: SettingsViewController
    var spot1Cell: UITableViewCell!
    var spot2Cell: UITableViewCell!
    var spot3Cell: UITableViewCell!
    var spot4Cell: UITableViewCell!
    var spot5Cell: UITableViewCell!
    var spot6Cell: UITableViewCell!
    var spot7Cell: UITableViewCell!
    
    
    @objc private func setSpotOneAssignmentSetting(notification: Notification) {
        let string = notification.object as! String
        spot1Cell.detailTextLabel?.text = string
        Settings.shared.spotOneAssignment = string
    }
    @objc private func setSpotTwoAssignmentSetting(notification: Notification) {
        let string = notification.object as! String
        spot2Cell.detailTextLabel?.text = string
        Settings.shared.spotTwoAssignment = string
    }
    @objc private func setSpotThreeAssignmentSetting(notification: Notification) {
        let string = notification.object as! String
        spot3Cell.detailTextLabel?.text = string
        Settings.shared.spotThreeAssignment = string
    }
    @objc private func setSpotFourAssignmentSetting(notification: Notification) {
        let string = notification.object as! String
        spot4Cell.detailTextLabel?.text = string
        Settings.shared.spotFourAssignment = string
    }
    @objc private func setSpotFiveAssignmentSetting(notification: Notification) {
        let string = notification.object as! String
        spot5Cell.detailTextLabel?.text = string
        Settings.shared.spotFiveAssignment = string
    }
    @objc private func setSpotSixAssignmentSetting(notification: Notification) {
        let string = notification.object as! String
        spot6Cell.detailTextLabel?.text = string
        Settings.shared.spotSixAssignment = string
    }
    @objc private func setSpotSevenAssignmentSetting(notification: Notification) {
        let string = notification.object as! String
        spot7Cell.detailTextLabel?.text = string
        Settings.shared.spotSevenAssignment = string
    }
    
    var tableSettings: [Section] {
        var rows = [
            NavigationRow(text: "1st Spot", detailText: .value1(""), customization: { cell, row in
                self.spot1Cell = cell
                self.spot1Cell.detailTextLabel?.text = Settings.shared.spotOneAssignment
                
                NotificationCenter.default.addObserver(self, selector: #selector(self.setSpotOneAssignmentSetting(notification:)), name: Notification.Name("SpotOneAssignmentSetting"), object: nil)
                },
                  action: { row in
                      let values = SpotAssignment.allCases
                      var data = [String]()
                      for value in values {
                          data.append("\(value.rawValue)")
                      }
                      let checkMarkedValue = Settings.shared.spotOneAssignment
                      self.showViewSettingOptions(sectionTitle: row.text, data: data, checkMarkedValue: checkMarkedValue, notificationName: "SpotOneAssignmentSetting")
                      return
                  }),
            NavigationRow(text: "2nd Spot", detailText: .value1(""), customization: { cell, row in
                self.spot2Cell = cell
                self.spot2Cell.detailTextLabel?.text = Settings.shared.spotTwoAssignment
                
                NotificationCenter.default.addObserver(self, selector: #selector(self.setSpotTwoAssignmentSetting(notification:)), name: Notification.Name("SpotTwoAssignmentSetting"), object: nil)
                },
                  action: { row in
                      let values = SpotAssignment.allCases
                      var data = [String]()
                      for value in values {
                          data.append("\(value.rawValue)")
                      }
                      let checkMarkedValue = Settings.shared.spotTwoAssignment
                      self.showViewSettingOptions(sectionTitle: row.text, data: data, checkMarkedValue: checkMarkedValue, notificationName: "SpotTwoAssignmentSetting")
                      return
                  }),
            NavigationRow(text: "3rd Spot", detailText: .value1(""), customization: { cell, row in
                self.spot3Cell = cell
                self.spot3Cell.detailTextLabel?.text = Settings.shared.spotThreeAssignment
                
                NotificationCenter.default.addObserver(self, selector: #selector(self.setSpotThreeAssignmentSetting(notification:)), name: Notification.Name("SpotThreeAssignmentSetting"), object: nil)
                },
                  action: { row in
                      let values = SpotAssignment.allCases
                      var data = [String]()
                      for value in values {
                          data.append("\(value.rawValue)")
                      }
                      let checkMarkedValue = Settings.shared.spotThreeAssignment
                      self.showViewSettingOptions(sectionTitle: row.text, data: data, checkMarkedValue: checkMarkedValue, notificationName: "SpotThreeAssignmentSetting")
                      return
                  }),
            NavigationRow(text: "4th Spot", detailText: .value1(""), customization: { cell, row in
                self.spot4Cell = cell
                self.spot4Cell.detailTextLabel?.text = Settings.shared.spotFourAssignment
                
                NotificationCenter.default.addObserver(self, selector: #selector(self.setSpotFourAssignmentSetting(notification:)), name: Notification.Name("SpotFourAssignmentSetting"), object: nil)
                },
                  action: { row in
                      let values = SpotAssignment.allCases
                      var data = [String]()
                      for value in values {
                          data.append("\(value.rawValue)")
                      }
                      let checkMarkedValue = Settings.shared.spotFourAssignment
                      self.showViewSettingOptions(sectionTitle: row.text, data: data, checkMarkedValue: checkMarkedValue, notificationName: "SpotFourAssignmentSetting")
                      return
                  }),
            NavigationRow(text: "5th Spot", detailText: .value1(""), customization: { cell, row in
                self.spot5Cell = cell
                self.spot5Cell.detailTextLabel?.text = Settings.shared.spotFiveAssignment
                
                NotificationCenter.default.addObserver(self, selector: #selector(self.setSpotFiveAssignmentSetting(notification:)), name: Notification.Name("SpotFiveAssignmentSetting"), object: nil)
                },
                  action: { row in
                      let values = SpotAssignment.allCases
                      var data = [String]()
                      for value in values {
                          data.append("\(value.rawValue)")
                      }
                      let checkMarkedValue = Settings.shared.spotFiveAssignment
                      self.showViewSettingOptions(sectionTitle: row.text, data: data, checkMarkedValue: checkMarkedValue, notificationName: "SpotFiveAssignmentSetting")
                      return
                  })
        ]
        
        if Settings.shared.deviceType != .phone {
            rows.append(
                NavigationRow(text: "6th Spot", detailText: .value1(""), customization: { cell, row in
                self.spot6Cell = cell
                self.spot6Cell.detailTextLabel?.text = Settings.shared.spotSixAssignment
                
                NotificationCenter.default.addObserver(self, selector: #selector(self.setSpotSixAssignmentSetting(notification:)), name: Notification.Name("SpotSixAssignmentSetting"), object: nil)
                },
                  action: { row in
                      let values = SpotAssignment.allCases
                      var data = [String]()
                      for value in values {
                          data.append("\(value.rawValue)")
                      }
                      let checkMarkedValue = Settings.shared.spotSixAssignment
                      self.showViewSettingOptions(sectionTitle: row.text, data: data, checkMarkedValue: checkMarkedValue, notificationName: "SpotSixAssignmentSetting")
                      return
                  }))
            rows.append(NavigationRow(text: "7th Spot", detailText: .value1(""), customization: { cell, row in
                self.spot7Cell = cell
                self.spot7Cell.detailTextLabel?.text = Settings.shared.spotSevenAssignment
                
                NotificationCenter.default.addObserver(self, selector: #selector(self.setSpotSevenAssignmentSetting(notification:)), name: Notification.Name("SpotSevenAssignmentSetting"), object: nil)
                },
                  action: { row in
                      let values = SpotAssignment.allCases
                      var data = [String]()
                      for value in values {
                          data.append("\(value.rawValue)")
                      }
                      let checkMarkedValue = Settings.shared.spotSevenAssignment
                      self.showViewSettingOptions(sectionTitle: row.text, data: data, checkMarkedValue: checkMarkedValue, notificationName: "SpotSevenAssignmentSetting")
                      return
                  }))
            
        }
        
        return [Section(title: "Spot Assignment", rows: rows)]
    }
    
    private func showViewSettingOptions(sectionTitle: String, data: [String], checkMarkedValue: String, notificationName: String) {
        let vc = SettingsListTableViewController(sectionTitle: sectionTitle, data: data, checkMarkedValue: checkMarkedValue, notificationName: notificationName)
        self.vc.navigationController?.pushViewController(vc, animated: true)
    }
}


