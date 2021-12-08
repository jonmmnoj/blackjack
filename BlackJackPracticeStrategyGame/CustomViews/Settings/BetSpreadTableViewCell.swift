//
//  BetSpreadTableViewCell.swift
//  BlackJackPracticeStrategyGame
//
//  Created by Jon on 11/12/21.
//

import UIKit

class BetSpreadTableViewCell: UITableViewCell {
    //var saveSettingHandler: (() -> Void)!
    var trueCount: Int! {
        didSet {
            trueCountLabel.text = "@ TC \(trueCount!)"
            if trueCount == -3 {
                trueCountLabel.text! += "-"
            } else if trueCount == 7 {
                trueCountLabel.text! += "+"
            }
            updateTextField(number: BetSpread.getBetAmount(for: trueCount))
        }
    }
    
    @IBOutlet weak var trueCountLabel: UILabel!
    @IBOutlet weak var decreaseButton: UIButton!
    @IBOutlet weak var increaseButton: UIButton!
    @IBOutlet weak var betAmountTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        betAmountTextField.keyboardType = UIKeyboardType.numberPad
        betAmountTextField.returnKeyType = UIReturnKeyType.done
        betAmountTextField.addNumericAccessory(addPlusMinus: false)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func decreaseButtonTouchUpInside(_ sender: UIButton) {
        var i = getInt()
        i -= 1
        updateTextField(number: i)
    }
    
    @IBAction func increaseButtonTouchUpInside(_ sender: UIButton) {
        var i = getInt()
        i += 1
        updateTextField(number: i)
    }
    
    private func getInt() -> Int {
        let s = betAmountTextField.text ?? ""
        let i = Int(s) ?? 0
        return i
    }
    
    private func updateTextField(number: Int) {
        betAmountTextField.text = String(number)
        setBet(strAmount: betAmountTextField.text ?? "")
    }
    
    @IBAction func textFieldEditingChange(number: Int) {
        
        setBet(strAmount: betAmountTextField.text ?? "")
    }
    
    @IBAction func textFieldDidBeginEditing() {
        if  betAmountTextField.text == "0" {
            betAmountTextField.text = ""
        }
    }
    
    private func setBet(strAmount: String) {
        var amount = Int(strAmount) ?? 0
        BetSpread.setBet(amount: amount, for: trueCount)
    }
}
