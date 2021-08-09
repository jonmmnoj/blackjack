//
//  DeviationInputView.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 8/2/21.
//

import UIKit

class DeviationInputView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var hitButton: UIButton!
    @IBOutlet var standButton: UIButton!
    @IBOutlet var doubleButton: UIButton!
    @IBOutlet var splitButton: UIButton!
    @IBOutlet var surrenderButton: UIButton!
    @IBOutlet var textField: UITextField!
    @IBOutlet var actionSegmentedControl: UISegmentedControl!
    @IBOutlet var lessGreaterThanSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var decrease: UIButton!
    @IBOutlet weak var increase: UIButton!
    @IBOutlet weak var positiveNegative: UIButton!
    
    
    @IBOutlet var secondRowStackView: UIStackView!
    
    lazy var actionButtons: [UIButton] = {
        return [hitButton, standButton, doubleButton, splitButton, surrenderButton]
    }()
    
    var playerAction: PlayerAction = .hit
    var lessThanGreaterThan: String = "+"
    var submitHandler: ((PlayerAction, Int, String) -> Void)!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("DeviationInputView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        let margin = hitButton.frame.width * 0.5 + 8
        secondRowStackView.layoutMargins.left = margin
        secondRowStackView.layoutMargins.right = margin
        
        resetButtonsStyle()
        
        // when rule is 0... just show running count segment control, eg. A,8 vs 6
        // when rule has nil count, just show action segment control, eg. 17 vs A
    
    }
    
    @IBAction func strategyActionSegementControlAction(_ sender: UISegmentedControl!) {
        playerAction = .hit
        switch sender.selectedSegmentIndex {
        case 0:
            playerAction = .hit
        case 1:
            playerAction = .stand
        case 2:
            playerAction = .double
        case 3:
            playerAction = .split
        case 4:
            playerAction = .surrender
        default:
            playerAction = .hit
        
        }
    }
    
    @IBAction func lessGreaterThanSegementControlAction(_ sender: UISegmentedControl!) {
        switch sender.selectedSegmentIndex {
        case 0:
            lessThanGreaterThan = "-"
        case 1:
            lessThanGreaterThan = "+"
        default:
            lessThanGreaterThan = "+"
        }
    }
    
    
    @IBAction func hitAction(_ sender: UIButton!) {
        playerAction = .hit
        resetButtonsStyle()
        styleSelectedButton(sender)
    }
    
    @IBAction func standAction(_ sender: UIButton!) {
        playerAction = .stand
        resetButtonsStyle()
        styleSelectedButton(sender)
    }
    
    @IBAction func doubleAction(_ sender: UIButton!) {
        playerAction = .double
        resetButtonsStyle()
        styleSelectedButton(sender)
    }
    
    @IBAction func splitAction(_ sender: UIButton!) {
        playerAction = .split
        resetButtonsStyle()
        styleSelectedButton(sender)
    }
    
    @IBAction func surrenderAction(_ sender: UIButton!) {
        playerAction = .surrender   
        resetButtonsStyle()
        styleSelectedButton(sender)
    }
    
    private func resetButtonsStyle() {
        for button in actionButtons {
            resetButtonStyle(button)
        }
    }
    
    private func resetButtonStyle(_ button: UIButton) {
        button.backgroundColor = .systemBackground
        button.setTitleColor(.systemBlue, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    private func styleSelectedButton(_ button: UIButton) {
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        //button.tintColor = .white
    }
    
    
    
    
    
    @objc func handleTap() {
        textField.resignFirstResponder() // dismiss keyoard
    }
    
    @IBAction func input(_ sender: UITextField) {
        //check input for value and enable/disable submit button
        //let s = textField.text ?? ""
    }
    
    @IBAction func increase(_ sender: UIButton) {
        var i = getInt()
        i += 1
        updateTextField(number: i)
    }
    @IBAction func decrease(_ sender: UIButton) {
        var i = getInt()
        i -= 1
        updateTextField(number: i)
    }
    
    @IBAction func postiveNegative(_ sender: UIButton) {
        if let text = textField.text {
            textField.text = String(Int(text)! * -1)
        }
    }
    
    func getInt() -> Int {
        let s = textField.text ?? ""
        let i = Int(s) ?? 0
        return i
    }
    
    func updateTextField(number: Int) {
        textField.text = String(number)
        submitButton.isEnabled = true
    }
   

    @IBAction func submitAction(_ sender: UIButton!) {
        submitHandler(playerAction, getInt(), lessThanGreaterThan)
    }
}
