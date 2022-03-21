//
//  TabBarController_v2.swift
//  BlackJackPracticeStrategyGame
//
//  Created by Jon on 12/25/21.
//

import UIKit

class TabBarController_v2: UITabBarController {
    
   var deviationType: DeviationType!
    override func viewWillAppear(_ animated: Bool) {
        print("view will appear")
        setupVCs()
    }
    override func viewDidLoad() {
        print("view did load")
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        //setupVCs()
    }
    
    private func setupVCs() {
        let vc1 = ChartViewController_v2()
        vc1.chartType = .pairs
        vc1.deviationType = deviationType
        
        let vc2 = ChartViewController_v2()
        vc2.chartType = .soft
        vc2.deviationType = deviationType
        
        let vc3 = ChartViewController_v2()
        vc3.chartType = .hard
        vc3.deviationType = deviationType
        
        let vc4 =  ChartViewController_v2()
        vc4.chartType = .surrender
        vc4.deviationType = deviationType
        
        viewControllers = [
            createNavController(for: vc1, title: NSLocalizedString("Pair Splitting", comment: ""), image: UIImage(systemName: "table")!),
            createNavController(for: vc2, title: NSLocalizedString("Soft Totals", comment: ""), image: UIImage(systemName: "table")!),
            createNavController(for: vc3, title: NSLocalizedString("Hard Totals", comment: ""), image: UIImage(systemName: "table")!),
            createNavController(for: vc4, title: NSLocalizedString("Surrender", comment: ""), image: UIImage(systemName: "table")!)
        ]
    }
    
    private func createNavController(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        //rootViewController.navigationController?.navigationBar.isHidden = true
        navController.tabBarItem.title = title
        
        return navController
    }
    

    
//    private struct Chart {
//        let type: ChartType
//        let deviation: DeviationType
//        
//    }
    
    //    private func getChart(type: ChartType, deviation: DeviationType) -> ChartProtocol {
    //        let chart = Chart(type: type, deviation: deviation)
    //        switch (chart.type, chart.deviation) {
    //        case (.pairs, .standard):
    //            return PairSplittingChart()
    //        case (.soft, .standard):
    //            return SoftTotalsChart()
    //        case (.hard, .standard):
    //            return HardTotalsChart()
    //        case (.surrender, .standard):
    //            return SurrenderChart()
    //
    //        case (.pairs, .hard17):
    //            return H17PairSplittingChart()
    //        case (.soft, .hard17):
    //            return H17SoftTotalsChart()
    //        case (.hard, .hard17):
    //            return H17HardTotalsChart()
    //        case (.surrender, .hard17):
    //            return H17SurrenderChart()
    //
    //        case (.pairs, .soft17):
    //            return S17PairSplittingChart()
    //        case (.soft, .soft17):
    //            return S17SoftTotalsChart()
    //        case (.hard, .soft17):
    //            return S17HardTotalsChart()
    //        case (.surrender, .soft17):
    //            return S17SurrenderChart()
    //        }
    //    }
}

enum ChartType {
    case pairs, soft, hard, surrender
}

//enum DeviationType {
//    case standard, hard17, soft17
//}


