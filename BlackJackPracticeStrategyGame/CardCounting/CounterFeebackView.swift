//
//  CounterFeebackView.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/16/21.
//

import UIKit

class CounterFeebackView: UIView {

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
        yourAnswerLabel.text = "Your answer: \(input)"
        actualLabel.text = "Actual: \(actualCount)"
        imageView.image = UIImage(named: s)
    }

}
