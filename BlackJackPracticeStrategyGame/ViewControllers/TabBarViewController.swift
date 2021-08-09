//
//  TabBarViewController.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/29/21.
//

import UIKit


class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("tab bar vc will disappear")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        super.viewWillAppear(animated)

        // Create Tab one
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        vc.gameType = .freePlay
        vc.edgesForExtendedLayout = .all
        //navigationController?.pushViewController(vc, animated: true)
        let tabOneBarItem = UITabBarItem(title: "Free Play", image: UIImage(named: "defaultImage.png"), selectedImage: UIImage(named: "selectedImage.png"))
        
        vc.tabBarItem = tabOneBarItem
    
        // Create Tab two
        //let tabTwo = TabTwoViewController()
        let vc2 = self.storyboard!.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        vc2.gameType = .basicStrategy
        vc2.edgesForExtendedLayout = .all
        let tabTwoBarItem2 = UITabBarItem(title: "Basic Strategy", image: UIImage(named: "defaultImage2.png"), selectedImage: UIImage(named: "selectedImage2.png"))
        
        vc2.tabBarItem = tabTwoBarItem2
        
        let vc3 = self.storyboard!.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        vc3.gameType = .runningCount
        vc3.edgesForExtendedLayout = .all
        let tabTwoBarItem3 = UITabBarItem(title: "Running Count", image: UIImage(named: "defaultImage3.png"), selectedImage: UIImage(named: "selectedImage3.png"))
        vc3.tabBarItem = tabTwoBarItem3
        
        let vc4 = self.storyboard!.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        vc4.gameType = .deviations
        vc4.edgesForExtendedLayout = .all
        let tabTwoBarItem4 = UITabBarItem(title: "Deviations", image: UIImage(named: "defaultImage3.png"), selectedImage: UIImage(named: "selectedImage3.png"))
        vc4.tabBarItem = tabTwoBarItem4
        
        let vc5 = self.storyboard!.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        vc5.gameType = .charts
        let tabTwoBarItem5 = UITabBarItem(title: "Charts", image: UIImage(named: "defaultImage3.png"), selectedImage: UIImage(named: "selectedImage3.png"))
        vc5.tabBarItem = tabTwoBarItem5
        
        
        self.viewControllers = [vc4, vc2, vc5, vc3, vc]
    }
    
    // UITabBarControllerDelegate method
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        //print("Selected \(viewController.title!)")
    }
}
