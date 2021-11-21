//
//  SwitchTableViewCell.swift
//  BlackJackPracticeStrategyGame
//
//  Created by Jon on 11/12/21.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var uiSwitch: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        uiSwitch.isOn = Settings.shared.betSpread
        label.text = "On/Off Switch"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func switchTouchUpInside(_ sender: UISwitch) {
        Settings.shared.betSpread = sender.isOn
    }
    //    @IBAction func switchTouchUpInside(_ sender: UISwitch) {
//        Settings.shared.betSpread = sender.isOn
//    }
}
