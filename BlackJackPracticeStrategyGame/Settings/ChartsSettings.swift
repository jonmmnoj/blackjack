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
                        self.actionHandler(deviationType: .none)
                    }
                ),
            ]),
            Section(title: "", rows: [
                NavigationRow(
                    text: "Hard 17 Deviations",
                    detailText: .none,
                    action: { _ in
                        self.actionHandler(deviationType: .hard17)
                    }
                ),
            ]),
            Section(title: "", rows: [
                NavigationRow(
                    text: "Soft 17 Deviations",
                    detailText: .none,
                    action: { _ in
                        self.actionHandler(deviationType: .soft17)
                    }
                ),
            ]),
            
//            Section(title: "", rows: [
//                NavigationRow(
//                    text: "Basic Strategy",
//                    detailText: .none,
//                    action: { _ in
//                        if Settings.shared.deviceType == .phone {
//                    AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeLeft, andRotateTo: UIInterfaceOrientation.landscapeLeft)
//                        }
//
//                    let sb = UIStoryboard(name: "Chart", bundle: nil)
//                    let tbc = sb.instantiateViewController(identifier: "TabBarController") as! TabBarController
//                    tbc.deviationType = .standard
//                        tbc.modalPresentationStyle = .fullScreen
//                    self.vc.present(tbc, animated: false)
//                }),
//            ]),
//
//            Section(title: "", rows: [
//                NavigationRow(
//                    text: "Hard 17 Deviations",
//                    detailText: .none,
//                    action: { _ in
//                    AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeLeft, andRotateTo: UIInterfaceOrientation.landscapeLeft)
//
//                    let sb = UIStoryboard(name: "Chart", bundle: nil)
//                    let tbc = sb.instantiateViewController(identifier: "TabBarController") as! TabBarController
//                    tbc.deviationType = .hard17
//                        tbc.modalPresentationStyle = .fullScreen
//                    self.vc.present(tbc, animated: false)
//                }),
//            ]),
//
//            Section(title: "", rows: [
//                NavigationRow(
//                    text: "Soft 17 Deviations",
//                    detailText: .none,
//                    action: { _ in
//                    AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeLeft, andRotateTo: UIInterfaceOrientation.landscapeLeft)
//
//                    let sb = UIStoryboard(name: "Chart", bundle: nil)
//                    let tbc = sb.instantiateViewController(identifier: "TabBarController") as! TabBarController
//                    tbc.deviationType = .soft17
//                        tbc.modalPresentationStyle = .fullScreen
//                    self.vc.present(tbc, animated: false)
//                }),
//            ]),
        ]
    }
    
    func actionHandler(deviationType: DeviationType) {
        if Settings.shared.deviceType == .phone {
            AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeLeft, andRotateTo: UIInterfaceOrientation.landscapeLeft)
        }
        let vc = TabBarController_v2()
        vc.deviationType = deviationType
        vc.modalPresentationStyle = .fullScreen
        self.vc.present(vc, animated: false)
    }
}
