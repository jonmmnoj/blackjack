//
//  MainMenuViewController.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/22/21.
//

import Foundation
import UIKit

class MainMenuViewController: UIViewController {
    @IBOutlet weak var freePlayButton: UIButton!
    @IBOutlet weak var basicStrategyButton: UIButton!
    @IBOutlet weak var runningCountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0, green: 0.4666666667, blue: 0.06124987284, alpha: 1)
       
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
           self.navigationController!.navigationBar.shadowImage = UIImage()
           self.navigationController!.navigationBar.isTranslucent = true
    }
        
    @IBAction func freePlay(_ sender: UIButton) {
        pushViewController(gameType: .freePlay)
    }
    
    @IBAction func basicStrategy(_ sender: UIButton) {
        pushViewController(gameType: .basicStrategy)
    }
    
    @IBAction func runningCount(_ sender: UIButton) {
        pushViewController(gameType: .runningCount)
    }
    
    private func pushViewController(gameType: GameType) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        vc.gameType = gameType
        vc.edgesForExtendedLayout = .all
        navigationController?.pushViewController(vc, animated: true)
    }
}
