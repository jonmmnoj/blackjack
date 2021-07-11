//
//  GameMaster.swift
//  PrettyExample
//
//  Created by JON on 7/6/21.
//  Copyright © 2021 nlampi. All rights reserved.
//

import Foundation
import UIKit

protocol GameMasterDelegate {
    func playerInput(enabled: Bool)
}

class GameMaster {
    var dealer: Dealer!
    var players: [Player] = []
    var player: Player!
    var delegate: GameMasterDelegate!
    var dealerBusy = false
    var table: UIView // ideally, GM does not have to work with table, only dealer, and then dealer works with table?
    var gameState: GameState! // save game state when using dealer, dealer might use table, which uses animations, gameMaster has to wait for animations to finish, table tells master when animations are finished
    
    init(table: UIView) {
        self.table = table
        setupDealer(table: table)
        setupPlayer()
    }
    
    func startGame() {
        dealCards()
    }
    
    func setupDealer(table view: UIView) {
        let table = Table(view: view, gameMaster: self) // table tells GM when animations are complete so GM can sync game flow with player input and player UI visuals
        self.dealer = Dealer(table: table)
        let hand = Hand(dealToPoint: CGPoint(x: 10, y: 50), adjustmentX: Card.width + 3, adjustmentY: 0, owner: self.dealer)
        self.dealer.add(hand: hand)
    }
    
    func setupPlayer() {
        let player = Player()
        let hand = Hand(dealToPoint: CGPoint(x: 10, y: table.frame.height - 300), adjustmentX: 50, adjustmentY: 50, owner: player)
        player.add(hand: hand)
        self.players.append(player)
        self.players.forEach {
            self.dealer.access(to: $0)
        }
        self.player = players.first!
    }
    
    func prepareForNewRound() {
        var hand = Hand(dealToPoint: CGPoint(x: 10, y: table.frame.height - 300), adjustmentX: 50, adjustmentY: 50, owner: player)
        player.add(hand: hand)
        
        hand = Hand(dealToPoint: CGPoint(x: 10, y: 50), adjustmentX: Card.width + 3, adjustmentY: 0, owner: self.dealer)
        self.dealer.add(hand: hand)
    }
}

// Player Inputs - Hit, Double, Split, Stand

extension GameMaster {
    func playerHits() {
        self.delegate.playerInput(enabled: false)
        let player = self.players.first!
        let hand = player.activatedHand!
        self.dealer.deal(to: hand)
        self.gameState = .dealtHit
    }
    
    func playerDoubles() {
        self.delegate.playerInput(enabled: false)
        let player = self.players.first!
        let hand = player.activatedHand!
        self.dealer.deal(to: hand, isDouble: true)
        self.gameState = .dealtDouble
    }
    
    func playerSplits() {
        let hand = player.activatedHand!
        if !hand.canSplit {
            print("can't split")
            return
        }
        self.delegate.playerInput(enabled: false)
        self.dealer.splitHand(for: hand)
        self.gameState = .dealtSplit
    }
    
    func playerStands() {
        // check if stand was on a split hand, if yes, shift cards over
        let hand = player.activatedHand!
        hand.set(state: .stand)
        if hand.isSplitHand {
            dealer.moveCards(for: player, to: .left)
        } else {
            playerHasMoreHandsOrDealersTurn()
        }
        
//        player.searchForIncompleteHand()
//        if player.activatedHand != nil {
//            waitForPlayerInput()
//        } else {
//            self.delegate.playerInput(enabled: false)
//            revealFaceDownCard()
//        }
    }
}

extension GameMaster {
    func resume() {
        print("\(gameState.debugDescription)")
        switch gameState {
        case .dealtSplit:
            moveCards(to: .right)
        case .dealtCards:
            // assume one hand game -- need to change for 2-hand games
           //if dealer has ace ask insurance
            if playerHasBlackjack {
                player.activatedHand!.set(state: .blackjack)
                revealFaceDownCard()
            }
            if dealerHasBlackjack {
                revealFaceDownCard()
            } else {
                waitForPlayerInput()
            }
        case .dealtHit:
            let hand = player.activatedHand!
            if (Rules.didBust(hand: hand)) {
                handleBust(hand: hand)
            } else {
                waitForPlayerInput()
            }
        case .dealtDouble:
            //check for bust
            let hand = player.activatedHand!
            if (Rules.didBust(hand: hand)) {
                handleBust(hand: hand)
            } else {
                hand.set(state: .double)
                if hand.isSplitHand {
                    moveCards(to: .left)
                } else {
                    playerHasMoreHandsOrDealersTurn()
                }
            }
        case .revealedFaceDownCard:
            if Rules.isHardSeventeenOrGreater(hand: self.dealer.activatedHand!) || (dealerHasBlackjack || player.hands.count == 1 && player.hands.first?.state == .blackjack) || player.allHandsBust() {
                discardAllHands()
            } else {
                self.dealer.moveCardToNewPositionOnTable()
                self.gameState = .movedRevealCard
            }
        case .movedRevealCard:
            self.dealer.dealToHard17()
            self.gameState = .dealtH17
        case .discardedAllHands:
            prepareForNewRound()
            dealCards()
        case .dealtH17:
            // figure out hands that won lost tie
            // discard all and deal again
            self.discardAllHands()
        case .movedAllCards:
            playerHasMoreHandsOrDealersTurn()
        case .discardedHand:
            if player.activatedHand!.isSplitHand {
                moveCards(to: .left)
            } else {
                playerHasMoreHandsOrDealersTurn()
            }
        default:
            print("GameMaster.resume() default case")
        }
    }
    
    func moveCards(to direction: MoveCardsDirection) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.dealer.moveCards(for: self.player, to: direction)
            self.gameState = .movedAllCards
            self.resume()
        }
    }
    
    func playerHasMoreHandsOrDealersTurn() {
        player.searchForIncompleteHand()
        if (player.activatedHand == nil) {
            self.delegate.playerInput(enabled: false)
            revealFaceDownCard()
        } else {
            waitForPlayerInput()
        }
    }
    
    func dealCards() {
        self.dealer.dealCardToPlayers()
        self.dealer.dealCardToSelf()
        self.dealer.dealCardToPlayers()
        self.dealer.dealCardToSelf()
        self.gameState = .dealtCards
    }
    
    func waitForPlayerInput() {
        delegate.playerInput(enabled: true)
    }
    
    func revealFaceDownCard() {
        self.dealer.revealCard()
        self.gameState = .revealedFaceDownCard
    }
    
    func discardAllHands() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.dealer.discard(hand: self.dealer.activatedHand!)
            self.player.hands.forEach {
                self.dealer.discard(hand: $0)
            }
            self.player.clearHands()
            self.gameState = .discardedAllHands
        }
    }
    
    func handleBust(hand: Hand) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.dealer.discard(hand: hand)
            hand.set(state: .bust)
            self.gameState = .discardedHand
        }
    }
    
    func askForInsurance() {
        // todo
    }
    
    func checkIfSplit(hand: Hand) {
        if hand.isSplitHand {
            
        }
    }
}

extension GameMaster {
    
    var playerHasBlackjack: Bool {
        return Rules.hasBlackjack(hand: player.activatedHand!)
    }
    
    var dealerHasBlackjack: Bool {
        return Rules.hasBlackjack(hand: dealer.activatedHand!)
    }
}
