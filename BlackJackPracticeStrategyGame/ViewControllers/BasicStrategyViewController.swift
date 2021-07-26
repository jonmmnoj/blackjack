//
//  BasicStrategyViewController.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/21/21.
//

import Foundation
import UIKit

class BasicStrategyViewController: UIViewController, FeedbackViewDelegate {
    var delegate: GameViewDelegate!
    var complete: (() -> Void)!
    var playerAction: PlayerAction!
    var correctAction: PlayerAction!
    
    @IBOutlet weak var feedbackView: FeedbackView!

    override func viewWillAppear(_ animated: Bool) {
        feedbackView.delegate = self
        feedbackView.updateViewForBasicStrategy(isCorrect: playerAction == correctAction, playerAction: playerAction , correctAction: correctAction)
    }
    
    func dimiss() {
        delegate.dismissViewController {
            self.complete()
        }
    }
}
