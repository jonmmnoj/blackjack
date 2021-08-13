//
//  SettingsViewController.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/24/21.
//

import UIKit
import QuickTableViewController

class SettingsViewController: QuickTableViewController {
    var gameType: GameType!
    @IBOutlet var navigationBar: UINavigationBar!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // If a shared setting was changed on another settings view, then the other views will not be updated. Need to reload setting controls in case there was a change to the settings. How should this be done?
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let gts = getSettingsHelper(for: self)
        gts.registerCustomViews(for: tableView)
        navigationBar.topItem?.title = gts.title
        navigationBar.prefersLargeTitles = true
        tableContents = gts.tableSettings
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.left.right.bottom.equalTo(view)
        }
    }
    
    private func getSettingsHelper(for vc: SettingsViewController) -> GameTypeSettings {
        switch gameType {
        case .basicStrategy:
            return  BasicStrategySettings(vc: vc)
        case .freePlay:
            return FreePlaySettings(vc: vc)
        case .runningCount:
            return RunningCountSettings(vc: vc)
        case .trueCount:
            return TrueCountSettings(vc: vc)
        case .deviations:
            return DeviationsSettings(vc: vc)
        case .charts:
            return ChartsSettings(vc: vc)
        case .none:
            return BasicStrategySettings(vc: vc)
        }
        
    }
}



    
