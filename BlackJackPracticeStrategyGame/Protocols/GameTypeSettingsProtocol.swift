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
    func playClickSound()
    
}

extension GameTypeSettings {
    func registerCustomViews(for tableView: UITableView) {
        let cell = UINib(nibName: "SliderTableViewCell", bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: "SliderTableViewCell")
    }
    func forcedSettings() {}
    func playClickSound() {
        SoundPlayer.shared.playSound(.click)
    }
}
