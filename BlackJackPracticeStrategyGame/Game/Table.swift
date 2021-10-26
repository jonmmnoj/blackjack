//
//  Table.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/6/21.
//

import Foundation
import UIKit

class Table {
    var view: UIView
    var isBusy: Bool = false
    var gameMaster: GameMaster
    var totalAnimationsNotComplete = 0
    var cardViews: [UILabel] = []
    var cardViewIndex: Int = 0
    var arrowView: UIImageView
    lazy var discardTray: DiscardTrayView = {
        let view = DiscardTrayView(frame: .zero)
        view.delegate = gameMaster.delegate
        return view
    }()
    
    var offScreenCardStartPoint: CGPoint {
        return CGPoint(x: view.frame.width, y: 0)
    }
    
    var offScreenDiscardPoint: CGPoint {
        return CGPoint(x: 0 - Card.width, y: discardTray.frame.minY)
    }
    
    init(view table: UIView, gameMaster: GameMaster) {
        table.backgroundColor = Settings.shared.defaults.tableColor
        self.view = table
        self.gameMaster = gameMaster
        self.arrowView = UIImageView(image: UIImage(named: "down_arrow"))
        self.view.addSubview(discardTray)
        if !Settings.shared.showDiscardTray || Settings.shared.gameType != .freePlay {
            discardTray.isHidden = true
        }
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    func showIndicator(on hand: Hand) {
        let point = hand.nextCardPoint
        let dim = Settings.shared.cardWidth / 5
        let frame = CGRect(x: point.x, y: point.y - dim * 2, width: dim, height: dim)
        arrowView.frame = frame
        self.view.addSubview(arrowView)
        arrowView.alpha = 1
        
        UIView.animate(withDuration: 0.5, delay: 0,   options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
            self.arrowView.frame = frame.offsetBy(dx: 0, dy: 5)
        })
    }
    
    func stopIndicator() {
        self.arrowView.removeFromSuperview()
    }
    
    func animateDeal(card: Card, delayAnimation isDelay: Bool = true) {
        if totalAnimationsNotComplete == 0 {
            firstCard = true
        }
        self.totalAnimationsNotComplete += 1
        if card.view == nil { card.createViews() }
        moveCardOffScreen(card)
        self.view.addSubview(card.view!)
        animate(card, delayAnimation: isDelay)
    }
    
    func animateMove(card: Card) {
        self.totalAnimationsNotComplete += 1
        animate(card, move: true)
    }
    
    private var firstCard: Bool = true
    private var dealSpeed: Float {
        if firstCard {
            firstCard = false
            return Float(self.totalAnimationsNotComplete)
        }
        let speed = (Float(self.totalAnimationsNotComplete) * Settings.dealSpeedFactor) - (Settings.dealSpeedFactor - 1.0)
        return speed
    }
    
    private func animate(_ card: Card, delayAnimation: Bool = true, move: Bool = false, rotate: Bool = false) {
        self.isBusy = true
        self.view.bringSubviewToFront(card.view!)
        let delay = delayAnimation ? TimeInterval(dealSpeed) : 0
        UIView.animate(withDuration: 0.5, delay: delay, options: [.curveLinear , .allowUserInteraction], animations: {
            card.updateFrame()
            if card.rotateAnimation {
                card.view!.setTransformRotation(toDegrees: 90)
            }
          }, completion: { finished in
            self.animationComplete()
            if !move {
                self.updateCount(card: card)
            }
          })
    }
    
    func animateDiscard(card: Card) {
        self.isBusy = true
        self.totalAnimationsNotComplete += 1
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear , .allowUserInteraction], animations: {
            card.set(dealPoint: self.offScreenDiscardPoint)
            card.updateFrame()
            if let label = card.hand?.valueLabelView {
                label.removeFromSuperview()
            }
          }, completion: { finished in
            self.animationComplete()
            card.destroyViews()
            CardCounter.shared.discard()
            self.discardTray.updateViews()
          })
    }
    
    func animateReveal(card: Card) {
        card.backView!.isHidden = true
        card.faceView!.isHidden = false
        self.totalAnimationsNotComplete += 1
        
        UIView.transition(from: card.backView!, to: card.faceView!, duration: 0.5, options: .transitionFlipFromRight, completion: { finished in
            card.isFaceDown = false
            self.animationComplete()
            self.updateCount(card: card)
        })
    }
    
    private func updateCount(card: Card) {
        card.wasDealt = true
        CardCounter.shared.count(card: card)
        discardTray.updateViews()
        card.hand?.updateValueOfHand(for: self)
    }
    
    
    
    private func animationComplete() {
        self.totalAnimationsNotComplete -= 1
        self.isWaitingForAnimationToComplete()
    }
    
    // should rename to something the refers to calling GameMaster.resume()?
    private func isWaitingForAnimationToComplete() {
        if self.totalAnimationsNotComplete > 0 {
        } else {
            gameMaster.resume()
        }
    }
    
    private func moveCardOffScreen(_ card: Card) {
        card.view!.frame = CGRect(x: offScreenCardStartPoint.x, y: offScreenCardStartPoint.y, width: Card.width, height: Card.height)
        card.backView!.frame = card.view!.bounds
        card.faceView!.frame = card.view!.bounds
    }
    
    func moveAllCards(for player: Player, to direction: MoveCardsDirection, startIndex: Int? = nil) {
        var adjustmentX: CGFloat = Settings.shared.cardSize // 200
        adjustmentX *= direction == .right ? -1 : 1
        for (i, hand) in player.hands.enumerated() {
            if startIndex != nil {
                if i < startIndex! { continue }
            }
            var newPoint = hand.nextCardPoint
            newPoint.x += adjustmentX
            hand.set(nextCardPoint: newPoint)
            
            if let view = hand.valueLabelView {
                UIView.animate(withDuration: 0.5, delay: TimeInterval(self.totalAnimationsNotComplete), options: [.curveLinear , .allowUserInteraction], animations: {
                    let frame = CGRect(x: view.frame.minX + adjustmentX, y: view.frame.minY, width: view.frame.width, height: view.frame.height)
                    view.frame = frame
                })
            }
            
            for card in hand.cards {
                UIView.animate(withDuration: 0.5, delay: TimeInterval(self.totalAnimationsNotComplete), options: [.curveLinear , .allowUserInteraction], animations: {
                    var newPoint = card.dealPoint!
                    newPoint.x += adjustmentX
                    if card.rotateAnimation && direction == .left {
                        newPoint.x += Settings.shared.cardSize * 0.15//30
                        newPoint.y += Settings.shared.cardSize * 0.15//30
                    }
                    card.set(dealPoint: newPoint)
                    card.updateFrame()
                }, completion: { finished in
                    
                    // why no animation complete??
                    
                })
            }
        }
    }
    
//    func show(view inputView: DeviationInputView) {
//        self.view.addSubview(inputView)
//        inputView.snp.makeConstraints { make in
//            make.center.equalTo(self.view)
//            make.width.greaterThanOrEqualTo(self.view.snp.width).offset(-50)
//            //make.left.equalTo(table)(50)
//           // make.right.equalTo(table).offset(-50)
//            make.height.lessThanOrEqualTo(250)
//        }
//    }
    
    lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .radial
        gradient.colors = [
            UIColor.clear.cgColor,
            //Settings.shared.defaults.tableColor
            UIColor.black.withAlphaComponent(0.3).cgColor,
//            UIColor.green.cgColor,
//            UIColor.yellow.cgColor,
//            UIColor.orange.cgColor,
//            UIColor.red.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
        let endY = 0.5 + view.frame.size.width / view.frame.size.height / 2
        gradient.endPoint = CGPoint(x: 1, y: endY)
        return gradient
    }()
}

extension UIView {
    func setTransformRotation(toDegrees angleInDegrees: CGFloat) {
        let angleInRadians = angleInDegrees / 180.0 * CGFloat.pi
        let rotation = self.transform.rotated(by: angleInRadians)
        self.transform = rotation
    }
}
