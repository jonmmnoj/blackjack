//
//  Card.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/6/21.
//

import Foundation
import UIKit

class Card {
    static var height: CGFloat = Settings.shared.cardSize
    static var width: CGFloat {
        return (self.height * 0.708).rounded() //0.708
    }
    var rotateAnimation: Bool {
        return isDouble || isSplitAce
    }
    var isSplitAce: Bool = false {
        didSet {
            if isSplitAce {
                
            }
        }
    }
    var hand: Hand?
    var value: CardValue
    var suit: CardSuit
    var view: UIView?
    var faceView: UIImageView?
    var backView: UIImageView?
    var dealPoint: CGPoint!
    var isFaceDown: Bool = false
    var isDouble: Bool = false
    var wasDealt: Bool = false
    
    init(value: CardValue, suit: CardSuit) {
        self.value = value
        self.suit = suit
    }
    
    func set(dealPoint: CGPoint) {
        self.dealPoint = dealPoint
    }
    
    func updateFrame() {
        let frame = CGRect(x: self.dealPoint.x, y: self.dealPoint.y, width: Card.width, height: Card.height)
        self.view!.frame = frame
    }
    
    func dealFaceDown() {
        self.isFaceDown = true
    }
    
    func animateDeal() {
        
    }
    
    func animateDiscard() {
        
    }
    
    func destroyViews() {
        self.view!.removeFromSuperview()
        self.view!.removeFromSuperview()
        self.backView!.removeFromSuperview()
        self.view = nil
        self.faceView = nil
        self.backView = nil
        self.isFaceDown = false
    }
    
    func createViews() {
        let view = UIView()
        //view.backgroundColor = .black
        
        let back = UIImageView()
        back.image = UIImage(named:"red_back")
        back.isHidden = !isFaceDown
        
        let front = UIImageView()
        front.image = UIImage(named:imageName())
        front.isHidden = isFaceDown

        view.addSubview(front)
        view.addSubview(back)
        
        self.view = view
        self.faceView = front
        self.backView = back
    }
    
    func imageName() -> String {
        return String("\(self.value.rawValue)\(self.suit.letter)")
    }
}


//class CardView: UIView {
//    var isFaceDown: Bool = false
//    //var backView: UILabel
//    //var frontView: UILabel
//    
//    init(frame: CGRect, value: CardValue, suit: CardSuit) {
//        super.init(frame: frame)
//        
//        self.layer.borderWidth = 10
//        self.layer.borderColor = UIColor.black.cgColor
//        
////        self.backView = UILabel()
////        self.backView.backgroundColor = .blue
////        self.backView.layer.borderWidth = 10
////        self.backView.layer.borderColor = UIColor.black.cgColor
////        self.backView.isHidden = !isFaceDown
////        self.backView.frame = self.bounds
////
////        self.frontView = UILabel()
////        self.frontView.backgroundColor = .red
////        self.frontView.layer.borderWidth = 10
////        self.frontView.layer.borderColor = UIColor.black.cgColor
////        self.frontView.text = " \(value.rawValue) \(suit.rawValue)"
////        self.frontView.textAlignment = .left
////        self.frontView.isHidden = isFaceDown
////        self.frontView.frame = self.bounds
////
////        self.addSubview(frontView)
////        self.addSubview(backView)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    
//}


