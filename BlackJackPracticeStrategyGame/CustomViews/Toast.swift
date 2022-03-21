//
//  Toast.swift
//  BlackJackPracticeStrategyGame
//
//  Created by Jon on 10/2/21.
//

import UIKit

class Toast {
    static func show(message: String, controller: UIViewController, for hand: Hand? = nil) {
        // Container
        let toastContainer = UIView(frame: CGRect())
        toastContainer.backgroundColor = UIColor.white//.withAlphaComponent(0.6)
        toastContainer.alpha = 0.0
        toastContainer.layer.cornerRadius = 10;
        toastContainer.clipsToBounds  =  true
        // corner radius
        toastContainer.layer.cornerRadius = 10
        // border
        toastContainer.layer.borderWidth = 0.5//1.0
        toastContainer.layer.borderColor = UIColor.black.cgColor
        // shadow
        toastContainer.layer.shadowColor = UIColor.black.cgColor
        toastContainer.layer.shadowOffset = CGSize(width: 3, height: 3)
        toastContainer.layer.shadowOpacity = 0.7
        toastContainer.layer.shadowRadius = 4.0

        // Label
        let toastLabel = UILabel(frame: CGRect())
        toastLabel.textColor = UIColor.black
        toastLabel.textAlignment = .center;
        //toastLabel.font.withSize(12.0)
        toastLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        toastLabel.text = message
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0
        
        toastContainer.addSubview(toastLabel)
        controller.view.addSubview(toastContainer)

        // Constraints
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false

        let a1 = NSLayoutConstraint(item: toastLabel, attribute: .leading, relatedBy: .equal, toItem: toastContainer, attribute: .leading, multiplier: 1, constant: 15)
        let a2 = NSLayoutConstraint(item: toastLabel, attribute: .trailing, relatedBy: .equal, toItem: toastContainer, attribute: .trailing, multiplier: 1, constant: -15)
        let a3 = NSLayoutConstraint(item: toastLabel, attribute: .bottom, relatedBy: .equal, toItem: toastContainer, attribute: .bottom, multiplier: 1, constant: -15)
        let a4 = NSLayoutConstraint(item: toastLabel, attribute: .top, relatedBy: .equal, toItem: toastContainer, attribute: .top, multiplier: 1, constant: 15)
        toastContainer.addConstraints([a1, a2, a3, a4])
        
        if let hand = hand {
            let cardView = hand.cards.first!.view
            let c4 = NSLayoutConstraint(item: toastContainer, attribute: .leading, relatedBy: .equal, toItem: controller.view, attribute: .leading, multiplier: 1, constant: cardView!.frame.minX + Card.width * 0.2)
            let c5 = NSLayoutConstraint(item: toastContainer, attribute: .top, relatedBy: .equal, toItem: controller.view, attribute: .top, multiplier: 1, constant: cardView!.frame.minY - Card.height * 0.5)
            controller.view.addConstraints([c4, c5])
        } else {
            let c4 = NSLayoutConstraint(item: toastContainer, attribute: .centerX, relatedBy: .equal, toItem: controller.view, attribute: .centerX, multiplier: 1, constant: 0)
            let c5 = NSLayoutConstraint(item: toastContainer, attribute: .centerY, relatedBy: .equal, toItem: controller.view, attribute: .centerY, multiplier: 1, constant: 0)
            controller.view.addConstraints([c4, c5])
        }

        // Animation
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1.0, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }
}
