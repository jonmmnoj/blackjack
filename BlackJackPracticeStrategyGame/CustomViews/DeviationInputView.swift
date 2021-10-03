//
//  DeviationInputView.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 8/2/21.
//

import UIKit

class DeviationInputView: UIView {
    var deviation: Deviation!
    var playerAction: PlayerAction = .hit
    var lessThanGreaterThan: String = "+"
    var runningCount: String = "+"
    var deviationSubmitHandler: ((PlayerAction, Int, String, String) -> Void)!
    var runningCountSubmitHandler: ((Int) -> Void)!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var decrease: UIButton!
    @IBOutlet weak var increase: UIButton!
   
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textFieldStackView: UIStackView!

    @IBOutlet weak var actionSegmentedControl: UISegmentedControl!
    @IBOutlet weak var actionStackView: UIStackView!
    
    @IBOutlet weak var lessGreaterThanSegmentedControl: UISegmentedControl!
    @IBOutlet weak var lessGreaterThanStackView: UIStackView!
    
    @IBOutlet weak var runningCountSegmentedControl: UISegmentedControl!
    @IBOutlet weak var runningCountStackView: UIStackView!

    init(frame: CGRect, deviation: Deviation) {
        super.init(frame: frame)
        self.deviation = deviation
        commonInit()
        initDeviation()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        initRunningCount()
    }
    
    init(frame: CGRect, gameType: GameType) {
        super.init(frame: frame)
        commonInit()
        if gameType == .freePlay {
            initTrueCount()
        } else {
            initRunningCount()
        }
        
        textField.keyboardType = UIKeyboardType.numberPad
        textField.returnKeyType = UIReturnKeyType.done
        textField.addNumericAccessory(addPlusMinus: true)
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
        
        if !Settings.shared.surrender {
            actionSegmentedControl.setEnabled(false, forSegmentAt: 4)
        }
        
        submitButton.layer.borderWidth = 1
        submitButton.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    private func initRunningCount() {
        titleLabel.text = "Running Count"
        actionStackView.isHidden = true
        //textFieldStackView.isHidden = true
        lessGreaterThanStackView.isHidden = true
        runningCountStackView.isHidden = true
    }
    
    private func initTrueCount() {
        titleLabel.text = "True Count"
        actionStackView.isHidden = true
        //textFieldStackView.isHidden = true
        lessGreaterThanStackView.isHidden = true
        runningCountStackView.isHidden = true
    }
    
    private func initDeviation() {
        titleLabel.text = "Deviation"
        if deviation.count == nil { // count not relevant, eg 17 v A
            textFieldStackView.isHidden = true
            lessGreaterThanStackView.isHidden = true
            runningCountStackView.isHidden = true
        }else if deviation.count == 0 { // running count, eg 16 v 10
            textFieldStackView.isHidden = true
            lessGreaterThanStackView.isHidden = true
        } else { // true count
            runningCountStackView.isHidden = true
        }
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
    
    @IBAction func runningCountSegementControlAction(_ sender: UISegmentedControl!) {
        switch sender.selectedSegmentIndex {
        case 0:
            runningCount = "-"
        case 1:
            runningCount = "+"
        default:
            runningCount = "+"
        }
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
        if deviation != nil {
            deviationSubmitHandler(playerAction, getInt(), lessThanGreaterThan, runningCount)
        } else {
            runningCountSubmitHandler(getInt())
        }
        
    }
}
