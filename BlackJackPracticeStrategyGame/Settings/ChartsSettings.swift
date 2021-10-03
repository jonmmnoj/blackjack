//
//  ChartSettings.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 8/6/21.
//

import UIKit
import QuickTableViewController

class ChartsSettings: GameTypeSettings {
    var title: String = "Charts"
    init(vc: SettingsViewController) {
        self.vc = vc
    }
    var vc: SettingsViewController
    var sliderView: SliderTableViewCell!
    var radioSection: RadioSection!
    
    var tableSettings: [Section] {
        
        return [
            Section(title: "", rows: [
                NavigationRow(
                    text: "Basic Strategy",
                    detailText: .none,
                    action: { _ in
                    AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeRight, andRotateTo: UIInterfaceOrientation.landscapeRight)

                    let sb = UIStoryboard(name: "Chart", bundle: nil)
                    let tbc = sb.instantiateViewController(identifier: "TabBarController") as! TabBarController
                    self.vc.present(tbc, animated: false)
                }),
            ]),
        ]
    }
}
