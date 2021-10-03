//
//  SliderTableViewCell.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/26/21.
//

import UIKit
import QuickTableViewController

class SliderTableViewCell: TapActionCell {// UITableViewCell {
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let speed = Settings.shared.dealSpeed
        setText(to: speed)
        slider.setValue(Float(speed), animated: false)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let value = sender.value
        let roundedValue = round(value * 10) / 10.0
        
        setText(to: roundedValue)
        Settings.shared.dealSpeed = roundedValue
    }
    
    private func setText(to value: Float) {
        label.text = String(value) + "X"
    }
    
}
