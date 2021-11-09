//
//  SettingsListTableViewController.swift
//  BlackJackPracticeStrategyGame
//
//  Created by Jon on 11/9/21.
//

import Foundation
import UIKit

class SettingsListTableViewController: UITableViewController {

    var data: [String]!

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)
        let cell = UITableViewCell(style: .default, reuseIdentifier: "CellReuseIdentifier")
        cell.textLabel?.text = data[indexPath.row]
        cell.accessoryType = Settings.shared.penetration == Penetration.convertToDouble(string: data[indexPath.row]) ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        //cell.accessoryType = .checkmark
        let string = cell.textLabel?.text ?? ""
        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: string)
        
        navigationController?.popViewController(animated: true)
        
    }

}
