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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Settings.shared.gameType = gameType
        let gts = getSettingsHelper(for: self)
        gts.forcedSettings()
        gts.registerCustomViews(for: tableView)
        self.navigationItem.title = gts.title
        //navigationController?.navigationBar.prefersLargeTitles = true
        tableContents = gts.tableSettings
        
        tableView.snp.makeConstraints { make in
            //make.top.equalTo(navigationController!.navigationBar.snp.bottom)
            make.left.right.bottom.top.equalTo(view)
            //make.top.equalTo(view).offset(100)
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
        case .deckRounding:
            return DeckRoundingSettings(vc: vc)
        case .none:
            return BasicStrategySettings(vc: vc)
        }
        
    }
}



    
