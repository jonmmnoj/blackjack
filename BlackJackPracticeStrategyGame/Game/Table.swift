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
    
    var offScreenCardStartPoint: CGPoint {
        return CGPoint(x: view.frame.width, y: 0)
    }
    
    var offScreenDiscardPoint: CGPoint {
        return CGPoint(x: 0 - Card.width, y: 0)
    }
    
    init(view table: UIView, gameMaster: GameMaster) {
        //table.backgroundColor = .black
        table.backgroundColor = #colorLiteral(red: 0, green: 0.4666666667, blue: 0.06124987284, alpha: 1)
        self.view = table
        self.gameMaster = gameMaster
        
        self.arrowView = UIImageView(image: UIImage(named: "down_arrow"))
    }
    
    func showIndicator(on hand: Hand) {
        let point = hand.nextCardPoint
        let frame = CGRect(x: point.x, y: point.y - 50, width: 25, height: 25)
        arrowView.frame = frame
        self.view.addSubview(arrowView)
        arrowView.alpha = 1
        
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping:0.1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            //self.arrowView.alpha = 0
            self.arrowView.frame = frame.offsetBy(dx: 0, dy: 5)
        }) { _ in
            //self.arrowView.removeFromSuperview()
        }
    }
    
    func stopIndicator() {
        self.arrowView.removeFromSuperview()
    }
    
    func animateDeal(card: Card, delayAnimation isDelay: Bool = true) {
        if card.view == nil { card.createViews() }
        moveCardOffScreen(card)
        self.view.addSubview(card.view!)
        animate(card, delayAnimation: isDelay)
    }
    
    func animateMove(card: Card) {
        animate(card, move: true)
    }
        
    private func animate(_ card: Card, delayAnimation: Bool = true, move: Bool = false, rotate: Bool = false) {
        self.isBusy = true
        self.totalAnimationsNotComplete += 1
        self.view.bringSubviewToFront(card.view!)
        let delay = delayAnimation ? TimeInterval(self.totalAnimationsNotComplete) : 0
        UIView.animate(withDuration: 0.5, delay: delay, options: [.curveLinear , .allowUserInteraction], animations: {
            card.updateFrame()
            if card.isDouble {
                card.view!.setTransformRotation(toDegrees: 90)
            }
          }, completion: { finished in
            self.animationComplete()
            if !move {
                CardCounter.shared.count(card: card)
            }
          })
    }
    
    func animateDiscard(card: Card) {
        self.isBusy = true
        self.totalAnimationsNotComplete += 1
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear , .allowUserInteraction], animations: {
            card.set(dealPoint: self.offScreenDiscardPoint)
            card.updateFrame()
          }, completion: { finished in
            self.animationComplete()
            card.destroyViews()
            
          })
    }
    
    func animateReveal(card: Card) {
        card.backView!.isHidden = true
        card.faceView!.isHidden = false
        
        //self.isBusy = true
        self.totalAnimationsNotComplete += 1
        
        UIView.transition(from: card.backView!, to: card.faceView!, duration: 0.5, options: .transitionFlipFromRight, completion: { finished in
            self.animationComplete()
            CardCounter.shared.count(card: card)
            
        })
    }
    
    private func animationComplete() {
        self.totalAnimationsNotComplete -= 1
        self.isWaitingForAnimationToComplete()
    }
    
    // should rename to something the refers to calling GameMaster.resume()
    private func isWaitingForAnimationToComplete() {
        if self.totalAnimationsNotComplete > 0 {
            //print("animations not complete")
        } else {
            //print("animations complete")
            gameMaster.resume()
        }
        //return self.totalAnimationsNotComplete > 0
    }
    
    private func moveCardOffScreen(_ card: Card) {
        card.view!.frame = CGRect(x: offScreenCardStartPoint.x, y: offScreenCardStartPoint.y, width: Card.width, height: Card.height)
        card.backView!.frame = card.view!.bounds
        card.faceView!.frame = card.view!.bounds
    }
    
    func moveAllCards(for player: Player, to direction: MoveCardsDirection, byAdjustmentX adjustmentXX: CGFloat = 0) {
        var adjustmentX: CGFloat = 200.0
        adjustmentX *= direction == .right ? -1 : 1
        for hand in player.hands {
            var newPoint = hand.nextCardPoint
            newPoint.x += adjustmentX
            hand.set(nextCardPoint: newPoint)
            for card in hand.cards {
                UIView.animate(withDuration: 0.5, delay: TimeInterval(self.totalAnimationsNotComplete), options: [.curveLinear , .allowUserInteraction], animations: {

                    var newPoint = card.dealPoint!
                    newPoint.x += adjustmentX
                    // adjust for doubled card behavior
                    if card.isDouble && direction == .left {
                        newPoint.x += 30
                        newPoint.y += 30
                    }
                    
                    card.set(dealPoint: newPoint)
                    card.updateFrame()
                }, completion: { finished in
                    //self.animationComplete()
                    //card.destroyViews()
                    
                    
                  })
            }
        }
    }
}

extension UIView {
    func setTransformRotation(toDegrees angleInDegrees: CGFloat) {
        let angleInRadians = angleInDegrees / 180.0 * CGFloat.pi
        let rotation = self.transform.rotated(by: angleInRadians)
        self.transform = rotation
    }
}
