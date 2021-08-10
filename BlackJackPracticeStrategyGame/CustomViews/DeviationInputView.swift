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
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet weak var decrease: UIButton!
    @IBOutlet weak var increase: UIButton!
   
    @IBOutlet var textField: UITextField!
    @IBOutlet var textFieldStackView: UIStackView!

    @IBOutlet var actionSegmentedControl: UISegmentedControl!
    @IBOutlet var actionStackView: UIStackView!
    
    @IBOutlet var lessGreaterThanSegmentedControl: UISegmentedControl!
    @IBOutlet var lessGreaterThanStackView: UIStackView!
    
    @IBOutlet var runningCountSegmentedControl: UISegmentedControl!
    @IBOutlet var runningCountStackView: UIStackView!

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
    }
    
    private func initRunningCount() {
        titleLabel.text = "Running Count"
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
