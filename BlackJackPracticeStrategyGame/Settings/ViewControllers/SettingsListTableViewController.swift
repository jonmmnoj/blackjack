//
//  SettingsListTableViewController.swift
//  BlackJackPracticeStrategyGame
//
//  Created by Jon on 11/9/21.
//

import Foundation
import UIKit

class SettingsListTableViewController: UITableViewController {

    var sectionTitle: String
    var data: [String]
    var checkMarkedValue: String
    var notificationName: String
    var isBetSpreadTable: Bool = false
    
    init(sectionTitle: String, data: [String], checkMarkedValue: String, notificationName: String) {
        self.sectionTitle = sectionTitle
        self.data = data
        self.checkMarkedValue = checkMarkedValue
        self.notificationName = notificationName
        super.init(style: .plain)
        var cell = UINib(nibName: "BetSpreadTableViewCell", bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: "BetSpreadTableViewCell")
        cell = UINib(nibName: "SwitchTableViewCell", bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: "SwitchTableViewCell")
        tableView.rowHeight = 44
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isBetSpreadTable {
                if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchTableViewCell") as! SwitchTableViewCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "BetSpreadTableViewCell") as! BetSpreadTableViewCell
                cell.trueCount = Int(data[indexPath.row])
                return cell
            }
        } else {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "CellReuseIdentifier")
            cell.textLabel?.text = data[indexPath.row]
            cell.accessoryType = checkMarkedValue == data[indexPath.row] ? .checkmark : .none
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        let string = cell.textLabel?.text ?? ""
        NotificationCenter.default.post(name: Notification.Name(notificationName), object: string)
        navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if isBetSpreadTable { return "Enter the dollar amount" }
        return nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if isBetSpreadTable {
            NotificationCenter.default.post(name: Notification.Name(notificationName), object: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let view = view as! UITableViewHeaderFooterView
        view.textLabel?.textAlignment = .center
    }

}
