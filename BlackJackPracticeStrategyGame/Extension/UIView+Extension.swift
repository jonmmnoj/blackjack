//
//  UIView+Extension.swift
//  BlackJackPracticeStrategyGame
//
//  Created by Jon on 4/30/22.
//

import UIKit

extension UIView {
    func addShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 1.0
    }
}
