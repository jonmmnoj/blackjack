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
        } else if gameType == .deviations_v2 {
            initDeviationsV2()
        } else {
            initRunningCount()
        }
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
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        if !Settings.shared.surrender {
            actionSegmentedControl.setEnabled(false, forSegmentAt: 4)
        }
        
        submitButton.backgroundColor = UIColor(hex: TableColor(rawValue: Settings.shared.buttonColor)!.buttonCode)
        submitButton.setTitleColor(.white, for: .normal)
        
        increase.tintColor = UIColor(hex: TableColor(rawValue: Settings.shared.buttonColor)!.buttonCode)
        decrease.tintColor = UIColor(hex: TableColor(rawValue: Settings.shared.buttonColor)!.buttonCode)
        
               
        textField.keyboardType = UIKeyboardType.numberPad
        textField.returnKeyType = UIReturnKeyType.done
        textField.addNumericAccessory(addPlusMinus: true)
        
        submitButton.snp.removeConstraints()
        submitButton.snp.makeConstraints { make in
            make.height.equalTo(75)
        }
    }
    
    private func initRunningCount() {
        titleLabel.text = "Running Count"
        actionStackView.isHidden = true
        //textFieldStackView.isHidden = true
        lessGreaterThanStackView.isHidden = true
        runningCountStackView.isHidden = true
    }
    
    private func initDeviationsV2() {
        titleLabel.text = "True Count"
        actionStackView.isHidden = true
        //textFieldStackView.isHidden = true
        lessGreaterThanStackView.isHidden = true
        runningCountStackView.isHidden = true
        increase.isHidden = true
        //increase.isEnabled = false
        decrease.isHidden = true
        //decrease.isEnabled = false
        //textField.content
        submitButton.isHidden = true
        submitButton.isEnabled = false
        submitButton.snp.removeConstraints()
        submitButton.snp.makeConstraints { make in
            make.height.equalTo(0)
        }
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
    
    private func getInt() -> Int {
        let s = textField.text ?? ""
        let i = Int(s) ?? 0
        return i
    }
    
    private func updateTextField(number: Int) {
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
    
    @IBAction func textFieldDidBeginEditing() {
        if  textField.text == "0" {
            textField.text = ""
        }
    }
}
