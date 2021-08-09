//
//  TabBarController.swift
//  PrettyExample
//
//  Created by JON on 6/25/21.
//  Copyright © 2021 nlampi. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class TabBarController: UITabBarController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeRight, andRotateTo: UIInterfaceOrientation.landscapeRight)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("chart tab vc will disappear")
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        setupVCs()
    }
    
    private func setupVCs() {
        let vc1 =  storyboard?.instantiateViewController(identifier: "ChartViewController") as! ChartViewController
        vc1.chart = PairSplittingChart()
        let vc2 =  storyboard?.instantiateViewController(identifier: "ChartViewController") as! ChartViewController
        vc2.chart = SoftTotalsChart()
        let vc3 =  storyboard?.instantiateViewController(identifier: "ChartViewController") as! ChartViewController
        vc3.chart = HardTotalsChart()
        let vc4 =  storyboard?.instantiateViewController(identifier: "ChartViewController") as! ChartViewController
        vc4.chart = SurrenderChart()
        
        viewControllers = [
            createNavController(for: vc1, title: NSLocalizedString("Pair Splits", comment: ""), image: UIImage(systemName: "table")!),
            createNavController(for: vc2, title: NSLocalizedString("Soft Totals", comment: ""), image: UIImage(systemName: "table")!),
            createNavController(for: vc3, title: NSLocalizedString("Hard Totals", comment: ""), image: UIImage(systemName: "table")!),
            createNavController(for: vc4, title: NSLocalizedString("Surrender", comment: ""), image: UIImage(systemName: "table")!)
        ]
    }
    
    private func createNavController(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        rootViewController.navigationController?.navigationBar.isHidden = true
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        
        return navController
    }
    
//    private func addNavButtons(to vc: UIViewController) {
////        let add = UIBarButtonItem(barButtonSystemItem: .add, target: vc, action: #selector(testButtonTouchUpInside))
//        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Quiz", style: .plain, target: vc, action: #selector("quizButtonTouchUpInside"))]
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

