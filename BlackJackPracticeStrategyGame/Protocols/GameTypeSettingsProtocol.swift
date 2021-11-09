//
//  GameTypeSettingsProtocol.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/26/21.
//

import Foundation
import QuickTableViewController

protocol GameTypeSettings {
    var tableSettings: [Section] { get }
    var title: String { get set }
    func registerCustomViews(for tableView: UITableView)
    func forcedSettings()
        //func selectedSettingOption()
    
}

extension GameTypeSettings {
    func registerCustomViews(for tableView: UITableView) {}
    func forcedSettings() {}
}
