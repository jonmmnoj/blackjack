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
    @IBOutlet weak var detail: UILabel!
    
    override func layoutSubviews() {
        //view.backgroundColor = .systemRed
        view.layer.cornerRadius = 12
        customImageView.setImage(color: UIColor.black)
        customImageView.layer.borderWidth = 2
        customImageView.layer.borderColor = UIColor.black.withAlphaComponent(0.4).cgColor
        customImageView.layer.cornerRadius = 10
    }
}

extension UIImageView {
    func setImage(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color.withAlphaComponent(0.7)
  }
}
