//
//  MenuTableViewCell.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 8/15/21.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var customImageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func layoutSubviews() {
        //view.backgroundColor = .systemRed
        view.layer.cornerRadius = 10
        customImageView.setImageColor(color: .white)
    }
    
}

extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}
