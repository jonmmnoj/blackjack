//
//  Card.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/6/21.
//

import Foundation
import UIKit

class Card {
    static var height: CGFloat {
        return Settings.shared.cardHeight
    }
    static var width: CGFloat {
        return (self.height * 0.708).rounded() //0.708
    }
    var rotateAnimation: Bool {
        guard Settings.shared.landscape == false else { return false }
        return isDouble || rotateForSplitAce || customRotation
    }
    var hasAdjustedForRotatedMoveLeft = false
    var hasAdjustedForRotatedMoveRight = false
    var rotateForSplitAce: Bool = false
    var wasTransformed: Bool = false
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
    var rotationDegrees: CGFloat = 90
    var customRotation = false
    var adjustDealPoint = true
    var customDealDelay: Double?
    var isPenetrationCard = false
    
    init(value: CardValue, suit: CardSuit) {
        self.value = value
        self.suit = suit
    }
    
    func set(dealPoint: CGPoint) {
        self.dealPoint = dealPoint
    }
    
    // So that card is dealt away from edge of screen
    private func updateFrameForDealer() {
        let previousCard = hand!.cards[hand!.cards.count - 2]
        let newDealPointX = previousCard.dealPoint.x
        let newDealPointY = previousCard.dealPoint.y + Card.height * 0.5 //Hand.dealerHandAdjustmentY + Card.height * 0.5
        let newDealPoint = CGPoint(x: newDealPointX, y: newDealPointY)
        self.dealPoint = newDealPoint
        self.hand?.nextCardPoint = CGPoint(x: newDealPoint.x, y: newDealPoint.y)
        let newAdjustmentX = Hand.dealerHandAdjustmentXAfterReveal * -1
        self.hand?.adjustmentX = newAdjustmentX
    }
    
    func setNewDealPoint(_ newDealPoint: CGPoint) {
        
    }
    
    func updateFrame() {
        guard self.dealPoint != nil else { return }
        
        if let hand = self.hand {
            // if card is close to discard tray or edge of screen, and isn't being discarded
            if hand.owner.isDealer && Settings.shared.landscape && dealPoint.x < Card.width + 3 && dealPoint.x > 0 {
                updateFrameForDealer()
            }
        }
        
        let frame = CGRect(x: self.dealPoint.x, y: self.dealPoint.y, width: Card.width, height: Card.height)
        self.view!.frame = frame
        
    }
    
    func adjustSizeForScaleChange() {
        let frame = CGRect(x: self.dealPoint.x, y: self.dealPoint.y, width: Card.width, height: Card.height)
        self.view!.frame = frame
        self.layoutSublayers(of: self.view!.layer)
    }
    
    func adjustSizeForScaleChange(changeX: CGFloat, changeY: CGFloat) {
        let frame = CGRect(x: self.view!.frame.minX - changeX, y: self.view!.frame.minY - changeY, width: Card.width, height: Card.height)
        self.view!.frame = frame
        self.layoutSublayers(of: self.view!.layer)
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
        //view.layer.borderColor = UIColor.red.cgColor
        //view.layer.borderWidth = 2
        //view.backgroundColor = .black
        
        let back = UIImageView()
        back.image = UIImage(named: backImageName())
        back.isHidden = !isFaceDown
        if isPenetrationCard {
            back.image = nil
            back.backgroundColor = .yellow//UIColor.init(hex: "#b82e25")

            back.layer.cornerRadius = 10
            back.layer.borderWidth = 1
            back.layer.borderColor = UIColor.init(hex: "#c7c703")?.cgColor
        }
        
        let front = UIImageView()
        front.image = UIImage(named: imageName())
        front.isHidden = isFaceDown

        view.addSubview(front)
        view.addSubview(back)
        
        self.view = view
        self.faceView = front
        self.backView = back
    }
    
    func backImageName() -> String {
        var str: String = Settings.shared.cardColor.lowercased()
        str += "_back2"
        return str//"fish"//str
    }
    
    func imageName() -> String {
        return String("\(self.value.stringValue)\(self.suit.letter)")
    }
    
    func layoutSublayers(of layer: CALayer) {
        if layer == self.view?.layer {
            layer.sublayers?.forEach {
                // By disabling actions we make sure that
                // frame changes for sublayers are applied immediately without animation
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                $0.frame = layer.bounds
                CATransaction.commit()
            }
        }
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


