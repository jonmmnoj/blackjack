//
//  SessionStatsViewController.swift
//  BlackJackPracticeStrategyGame
//
//  Created by Jon on 1/3/22.
//

import UIKit

class SessionStatsViewController: UIViewController {
    
    var dismissAction: (() -> ())!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func dismissButtonAction(_ sender: UIButton!) {
        
        dismissAction()
    }
}
