//
//  SettingsViewController.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/24/21.
//

import UIKit
import QuickTableViewController

protocol SplitViewDelegate {
    func gameTypeSelected(_ type: GameType)
}

extension SettingsViewController: SplitViewDelegate {
    func gameTypeSelected(_ type: GameType) {
        let gts = getSettingsHelper(for: self)
        tableContents = gts.tableSettings
        self.navigationItem.title = gts.title
    }
}

class SettingsViewController: QuickTableViewController {
    
    var subSettings = false
    var subSettingsGTS: GameTypeSettings?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalTo(view)
        }
        
        var gts: GameTypeSettings!
        if subSettings {
            gts = subSettingsGTS
            
        } else {
            gts = getSettingsHelper(for: self)
        }
        gts.forcedSettings()
        gts.registerCustomViews(for: tableView)
        self.navigationItem.title = gts.title
        tableContents = gts.tableSettings

        
    }
    
    private func getSettingsHelper(for vc: SettingsViewController) -> GameTypeSettings {
        switch Settings.shared.gameType {
        case .basicStrategy:
            return  BasicStrategySettings(vc: vc)
        case .freePlay:
            return FreePlaySettings(vc: vc)
        case .runningCount:
            return RunningCountSettings(vc: vc)
        case .runningCount_v2:
            return RunningCountSettings_v2(vc: vc)
        case .trueCount:
            return TrueCountSettings(vc: vc)
        case .deviations:
            return DeviationsSettings(vc: vc)
        case .deviations_v2:
            return DeviationsSettings_v2(vc: vc)
        case .charts:
            return ChartsSettings(vc: vc)
        case .deckRounding:
            return DeckRoundingSettings(vc: vc)
        //default:
            
        //case .none:
          //  return BasicStrategySettings(vc: vc)
        }
        
    }
}



    
