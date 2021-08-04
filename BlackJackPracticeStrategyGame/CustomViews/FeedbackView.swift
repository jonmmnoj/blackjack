//
//  CounterFeebackView.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/16/21.
//

import UIKit

protocol FeedbackViewDelegate {
    func dimiss()
}

class FeedbackView: UIView {
    var delegate: FeedbackViewDelegate?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var actualLabel: UILabel!
    @IBOutlet weak var yourAnswerLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        setupView()
    }

    private func setupView() {
    
    }
    
    func updateView(isCorrect: Bool, input: Int, actualCount: Int) {
        let s = isCorrect ? "right" : "wrong"
        imageView.image = UIImage(named: s)
        yourAnswerLabel.text = "Your answer: \(input)"
        actualLabel.text = "Actual: \(actualCount)"
        
    }
    
    func updateViewForBasicStrategy(isCorrect: Bool, playerAction: PlayerAction, correctAction: PlayerAction) {
        let s = isCorrect ? "right" : "wrong"
        imageView.image = UIImage(named: s)
        yourAnswerLabel.text = "Your answer: \(playerAction.rawValue)"
        actualLabel.text = "Actual: \(correctAction.rawValue)"
        
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        delegate?.dimiss()
    }

}
