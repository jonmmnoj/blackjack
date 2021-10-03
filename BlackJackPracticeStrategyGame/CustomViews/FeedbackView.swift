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
        backgroundColor = .secondarySystemBackground
        dismissButton.layer.borderWidth = 1
        dismissButton.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    func updateView(isCorrect: Bool, input: Int, actualCount: Int) {
        let s = isCorrect ? "right" : "wrong"
        let image = UIImage(named: s)
        imageView.image = image
        yourAnswerLabel.text = "Your answer: \(input)"
        actualLabel.text = "Actual: \(actualCount)"
    }
    
    func updateViewForBasicStrategy(isCorrect: Bool, playerAction: String, correctAction: String) {
        let s = isCorrect ? "right" : "wrong"
        imageView.image = UIImage(named: s)
        //yourAnswerLabel.text = "Your answer: \(playerAction)"
        actualLabel.text = "\(correctAction)"
        actualLabel.textColor = .systemGreen
        
        let myMutableString = NSMutableAttributedString(string: "Your answer: \(playerAction)", attributes: [NSAttributedString.Key.font: yourAnswerLabel.font! ])
        
        let color: UIColor = isCorrect ? .systemGreen : .systemRed
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSRange(location: 13, length: playerAction.count))
        
        yourAnswerLabel.attributedText = myMutableString
        
    }
    
    func updateViewForDeviation(isCorrect: Bool, playerAction: String, correctAction: String) {
        let s = isCorrect ? "right" : "wrong"
        imageView.image = UIImage(named: s)
        //yourAnswerLabel.text = "Your answer: \(playerAction)"
        actualLabel.text = "\(correctAction)"
        actualLabel.textColor = .systemGreen
        
        let myMutableString = NSMutableAttributedString(string: "Your answer: \(playerAction)", attributes: [NSAttributedString.Key.font: yourAnswerLabel.font! ])
        
        let color: UIColor = isCorrect ? .systemGreen : .systemRed
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSRange(location: 13, length: playerAction.count))
        
        yourAnswerLabel.attributedText = myMutableString
        
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        delegate?.dimiss()
    }

}
