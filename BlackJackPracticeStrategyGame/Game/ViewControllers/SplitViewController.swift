//
//  SplitViewController.swift
//  BlackJackPracticeStrategyGame
//
//  Created by Jon on 12/9/21.
//

import UIKit

class SplitViewController: UISplitViewController,
                           UISplitViewControllerDelegate {
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        preferredSplitBehavior = .displace //.displace
        preferredDisplayMode = .oneBesideSecondary
        if Settings.shared.deviceType == .phone {
            preferredDisplayMode = .secondaryOnly
        }
        //presentsWithGesture = true
        //self.preferredSplitBehavior = .tile
        let fraction = 0.60
        preferredPrimaryColumnWidthFraction = fraction
        
        //maximumPrimaryColumnWidth = 0.55
        //minimumPrimaryColumnWidth = 0.55
        
        maximumPrimaryColumnWidth =  max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        minimumPrimaryColumnWidth = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) * fraction
        
        let leftNavController = viewControllers.first as! UINavigationController
        let mv = leftNavController.viewControllers.first as! MainMenuViewController
        let rightNavController = viewControllers.last as! UINavigationController
        let dv = rightNavController.viewControllers.first as! SettingsViewController
        //dv.gameType = GameType.freePlay
        mv.delegate = dv
        
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        //print("collapse secondary")
        return true
    }
    
    override func collapseSecondaryViewController(_ secondaryViewController: UIViewController, for splitViewController: UISplitViewController) {
        //print("collapse secondary")
    }
    
    func splitViewControllerDidCollapse(_ svc: UISplitViewController) {
        //print("did collapse")
    }
}
