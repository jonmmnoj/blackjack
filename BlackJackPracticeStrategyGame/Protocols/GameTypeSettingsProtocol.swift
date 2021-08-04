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
    func registerCustomViews(for tableView: UITableView)
//    static func getSettingsHelper(vc: SettingsViewController, gameType: GameType) -> GameTypeSettings
    var title: String { get set }
    
}

extension GameTypeSettings {
    func registerCustomViews(for tableView: UITableView) {
        
    }
}
