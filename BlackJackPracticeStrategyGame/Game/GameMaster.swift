//
//  GameMaster.swift
//  PrettyExample
//
//  Created by JON on 7/6/21.
//  Copyright © 2021 nlampi. All rights reserved.
//

import Foundation
import UIKit



class GameMaster {
    var gameType: GameType
    var gameStrategyPattern: GameTypeStrategyPatternProtocol!
    var dealer: Dealer!
    var players: [Player] = []
    var player: Player!
    var delegate: GameViewDelegate! {
        didSet {
            //countMaster.delegate = self.delegate
        }
    }
    var dealerBusy = false
    var table: UIView // ideally, GM does not have to work with table, only dealer, and then dealer works with table?
    //var table: Table
    var gameState: GameState! // save game state when using dealer, dealer might use table, which uses animations, gameMaster has to wait for animations to finish, table tells master when animations are finished
    //var countMaster: CountMaster
    var navBarHeight: CGFloat!
    var dealerHand: Hand {
        return Hand(dealToPoint: CGPoint(x: 10, y: 60 + navBarHeight), adjustmentX: Card.width + 3, adjustmentY: 0, owner: self.dealer)
    }
    var playerHand: Hand {
        return Hand(dealToPoint: CGPoint(x: 10, y: table.frame.height - 250), adjustmentX: 50, adjustmentY: 50, owner: player)
    }
    
    init(gameType: GameType, table: UIView) {
        self.gameType = gameType
        self.table = table
    }
    
    func startGame() {
        gameStrategyPattern = gameType.getStrategyPattern(gameMaster: self)
        setupDealer(table: table)
        setupPlayer()
        dealCards()
    }
    
    func dealCards() {
        gameStrategyPattern.dealCards()
        self.gameState = .dealtCards
    }
    
    func setupDealer(table view: UIView) {
        let table = Table(view: view, gameMaster: self) // table tells GM when animations are complete so GM can sync game flow with player input and player UI visuals
        self.dealer = Dealer(table: table)
        let hand = dealerHand//Hand(dealToPoint: CGPoint(x: 20 + navBarHeight, y: 50), adjustmentX: Card.width + 3, adjustmentY: 0, owner: self.dealer)
        self.dealer.add(hand: hand)
    }
    
    func setupPlayer() {
        let player = Player()
        self.players.append(player)
        self.player = players.first!
        self.players.forEach {
            self.dealer.access(to: $0)
        }
        
        let hand = playerHand//Hand(dealToPoint: CGPoint(x: 10, y: table.frame.height - 300), adjustmentX: 50, adjustmentY: 50, owner: player)
        player.add(hand: hand)
        
        
        
    }
    
    func tasksForEndOfRound() {
        gameStrategyPattern.tasksForEndOfRound()
        // call CardCounterMaster, see if it's time to ask the player what the count is.
        // CCM.isTimeToAskForCount?() //
//        if countGame && countMaster.isTimeToAskForCount() {
//            countMaster.endOfRoundTasks(gameMaster: self, completion: {
//                self.prepareForNewRound()
//            })// let countMaster call back to GameMaster when task is complete
//            print("GM waiting on CM")
//        } else {
//            prepareForNewRound()
//        }
    }
    
    func prepareForNewRound() {
        // maybe player could do this? like reset the hand he has, give the player a position on the table, like a starting point for all the player's cards
        var hand = playerHand//Hand(dealToPoint: CGPoint(x: 10, y: table.frame.height - 300), adjustmentX: 50, adjustmentY: 50, owner: player)
        player.add(hand: hand)
        // same thinking for dealer
        hand = dealerHand//Hand(dealToPoint: CGPoint(x: 20 + navBarHeight, y: 50), adjustmentX: Card.width + 3, adjustmentY: 0, owner: self.dealer)
        self.dealer.add(hand: hand)
        
        dealCards()
    }
}

// Player Inputs - Hit, Double, Split, Stand

extension GameMaster {
    func inputReceived(type: PlayerAction) {
        self.dealer.stopIndicator()
        self.delegate.playerInput(enabled: false)
        gameStrategyPattern.inputReceived(type: type)
    }
    
    func playerHits() {
        let player = self.players.first!
        let hand = player.activatedHand!
        self.dealer.deal(to: hand)
        self.gameState = .dealtHit
    }
    
    func playerDoubles() {
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
        self.dealer.splitHand(for: hand)
        self.gameState = .dealtSplit
    }
    
    func playerStands() {
        let hand = player.activatedHand!
        hand.set(state: .stand)
        if hand.isSplitHand {
            moveCards(to: .left)
        } else {
            playerHasMoreHandsOrDealersTurn()
        }
    }
    
    func playerSurrenders() {
        let hand = player.activatedHand!
        hand.set(state: .surrender)
        if hand.isSplitHand {
            moveCards(to: .left)
        } else {
            playerHasMoreHandsOrDealersTurn()
        }
    }
}

extension GameMaster {
    func resume() {
        //print("\(gameState.debugDescription)")
        switch gameState {
        
        case .dealtCards:
            // assume one hand game -- need to change for 2-hand games
           //if dealer has ace ask insurance
            if playerHasBlackjack {
                player.activatedHand!.set(state: .blackjack)
                revealFaceDownCard()
            } else if dealerHasBlackjack {
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
        case .dealtSplit:
            moveCards(to: .right)
        case .movedAllCards:
            if playerHasBlackjack && player.activatedHand!.state == .incomplete {
                self.player.activatedHand!.set(state: .blackjack)
                //self.dealer.discard(hand: player.activatedHand!)
                //self.gameState = .discardedHand
                discard(hand: player.activatedHand!)
            } else {
                playerHasMoreHandsOrDealersTurn()
            }
        case .discardedHand, .busted:
            if player.activatedHand!.isSplitHand {
                moveCards(to: .left)
            } else {
                playerHasMoreHandsOrDealersTurn()
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
        case .dealtH17:
            // figure out hands that won lost tie
            // discard all and deal again
            self.discardAllHands()
        
        case .discardedAllHands:
            tasksForEndOfRound()
            //prepareForNewRound()
            //dealCards()
        
        
        default:
            print("GameMaster.resume() default case")
        }
    }
    
    func moveCards(to direction: MoveCardsDirection) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.dealer.moveCards(for: self.player, to: direction)
            self.gameState = .movedAllCards
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.resume()
            }
        }
    }
    
    func playerHasMoreHandsOrDealersTurn() {
        player.searchForIncompleteHand()
       
        if (player.activatedHand == nil) {
            self.delegate.playerInput(enabled: false)
            revealFaceDownCard()
        } else if playerHasBlackjack {
            self.player.activatedHand!.set(state: .blackjack)
            //self.dealer.discard(hand: player.activatedHand!)
            discard(hand: player.activatedHand!)
        } else {
            waitForPlayerInput()
        }
    }
    
    func getPlayerAction() -> PlayerAction {
        var playerCardValues: [Int] = []
        for card in player.activatedHand!.cards {
            playerCardValues.append(card.value.rawValue)
        }
        let action = BasicStrategy.getPlayerAction(dealerCardValue: dealer.activatedHand!.cards.last!.value.rawValue, playerCardValues: playerCardValues )
        print("\(action.rawValue): \(playerCardValues)")

        let pAction: PlayerAction = PlayerAction(rawValue: action.rawValue)!
        
        return pAction
    }
    
    func waitForPlayerInput() {
        if gameStrategyPattern.automaticPlay {
            let pAction = getPlayerAction()
            inputReceived(type: pAction)
        } else {
            dealer.indicateDealerIsReadyForPlayerInput(on: player.activatedHand!)
            delegate.playerInput(enabled: true)
        }
    }
    
    func discard(hand: Hand) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.dealer.discard(hand: self.player.activatedHand!)
            self.gameState = .discardedHand
        }
    }
    
    func revealFaceDownCard() {
        self.dealer.revealCard()
        self.gameState = .revealedFaceDownCard
    }
    
    func discardAllHands() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.dealer.discard(hand: self.dealer.activatedHand!)
            self.player.hands.forEach {
                self.dealer.discard(hand: $0)
            }
            self.player.clearHands()
            self.gameState = .discardedAllHands
        }
    }
    
    func handleBust(hand: Hand) {
        


//        hand.set(state: .bust)
//        self.discard(hand: hand)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            hand.set(state: .bust)
            self.gameState = .busted
            self.resume()
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
