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
