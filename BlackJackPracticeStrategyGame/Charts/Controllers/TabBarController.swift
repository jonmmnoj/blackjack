//
//  TabBarController.swift
//  PrettyExample
//
//  Created by JON on 6/25/21.
//

import UIKit

@available(iOS 13.0, *)
class TabBarController: UITabBarController {
    
    var deviationType: DeviationType!
    
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
        setupVCs(deviation: self.deviationType)
    }
    
    enum ChartType {
        case pairs, soft, hard, surrender
    }
    
    enum DeviationType {
        case standard, hard17, soft17
    }
    
    private struct Chart {
        let type: ChartType
        let deviation: DeviationType
        
    }
    
    private func getChart(type: ChartType, deviation: DeviationType) -> ChartProtocol {
        let chart = Chart(type: type, deviation: deviation)
        switch (chart.type, chart.deviation) {
        case (.pairs, .standard):
            return PairSplittingChart()
        case (.soft, .standard):
            return SoftTotalsChart()
        case (.hard, .standard):
            return HardTotalsChart()
        case (.surrender, .standard):
            return SurrenderChart()
            
        case (.pairs, .hard17):
            return H17PairSplittingChart()
        case (.soft, .hard17):
            return H17SoftTotalsChart()
        case (.hard, .hard17):
            return H17HardTotalsChart()
        case (.surrender, .hard17):
            return H17SurrenderChart()
            
        case (.pairs, .soft17):
            return S17PairSplittingChart()
        case (.soft, .soft17):
            return S17SoftTotalsChart()
        case (.hard, .soft17):
            return S17HardTotalsChart()
        case (.surrender, .soft17):
            return S17SurrenderChart()
//
        default:
            return SurrenderChart()

        }
    }
    
    private func setupVCs(deviation: DeviationType) {
        let vc1 =  storyboard?.instantiateViewController(identifier: "ChartViewController") as! ChartViewController
        vc1.chart = getChart(type: .pairs, deviation: deviation)
        let vc2 =  storyboard?.instantiateViewController(identifier: "ChartViewController") as! ChartViewController
        vc2.chart = getChart(type: .soft, deviation: deviation)
        let vc3 =  storyboard?.instantiateViewController(identifier: "ChartViewController") as! ChartViewController
        vc3.chart = getChart(type: .hard, deviation: deviation)
        let vc4 =  storyboard?.instantiateViewController(identifier: "ChartViewController") as! ChartViewController
        vc4.chart = getChart(type: .surrender, deviation: deviation)
        
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
        
        return navController
    }
}

