//
//  SliderTableViewCell.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/26/21.
//

import UIKit
import QuickTableViewController

class SliderTableViewCell: TapActionCell {// UITableViewCell {
    var initHandler: ((UISlider) -> Float)!
    var changedValueHandler: ((Float) -> Float)!
    var setTextHandler: ((Float) -> String)!
    
    @IBOutlet var slider: UISlider!
    @IBOutlet var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setup() {
        guard slider != nil else {
            return
            //slider = SliderTableViewCell

        }
        let initValue = initHandler(slider)
        setText(to: initValue)
        slider.setValue(Float(initValue), animated: false)
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let roundedValue = changedValueHandler(sender.value)
        sender.value = roundedValue
        setText(to: roundedValue)
    }
    
    private func setText(to value: Float) {
        let str = setTextHandler(value)
        label.text = String(str)
    }
}
