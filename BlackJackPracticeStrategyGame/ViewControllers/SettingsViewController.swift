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

    override func viewDidLoad() {
        super.viewDidLoad()
        let gts = getSettingsHelper(for: self)
        gts.registerCustomViews(for: tableView)
        navigationBar.topItem?.title = gts.title
        navigationBar.prefersLargeTitles = true
        //navigationBar.isTranslucent = false
        tableContents = gts.tableSettings
        //title = "Settings"
        //self.tabBarController?.title = "Title"
        
//        let label = UILabel()
//        label.text = "Hello"
//        view.addSubview(label)
//        label.snp.makeConstraints { make in
//            make.top.equalTo(view)
//            make.left.right.equalTo(view)
//            make.height.equalTo(100)
//        }
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
            return BasicStrategySettings(vc: vc)
        case .deviations:
            return DeviationsSettings(vc: vc)
        case .charts:
            return ChartsSettings(vc: vc)
        case .none:
            return BasicStrategySettings(vc: vc)
        }
        
    }
}



    
