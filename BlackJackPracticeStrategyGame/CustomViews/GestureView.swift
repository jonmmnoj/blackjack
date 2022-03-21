//
//  GestureView.swift
//  BlackJackPracticeStrategyGame
//
//  Created by Jon on 3/20/22.
//

import UIKit

class GestureView: UIView {
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var surrenderLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var dismissButton: UIButton!
    var dismissHandler: (() -> Void)!
 
    required init() {
        super.init(frame: .zero)
        commonInit()
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("GestureView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        topLabel.backgroundColor = UIColor(hex: TableColor(rawValue: Settings.shared.buttonColor)!.buttonCode)
        topLabel.textColor = .white
        
        dismissButton.backgroundColor = UIColor(hex: TableColor(rawValue: Settings.shared.buttonColor)!.buttonCode)
        dismissButton.setTitleColor(.white, for: .normal)
        
        surrenderLabel.adjustsFontSizeToFitWidth = true
    }
    
    @IBAction func dismissAction(_ sender: UIButton!) {
        dismissHandler()
    }
}
