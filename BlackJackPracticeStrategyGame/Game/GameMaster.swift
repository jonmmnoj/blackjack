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
    lazy var gameStrategyPattern: GameTypeStrategyPatternProtocol = {
        return gameType.getStrategyPattern(gameMaster: self)
    }()
    var dealer: Dealer!
    var players: [Player] = []
    var player: Player!
    var delegate: GameViewDelegate!
    var dealerBusy = false
    var tableView: UIView // ideally, GM does not have to work with table, only dealer, and then dealer works with table?
    //var table: Table
    var gameState: GameState! // save game state when using dealer, dealer might use table, which uses animations, gameMaster has to wait for animations to finish, table tells master when animations are finished
    //var countMaster: CountMaster
    var navBarHeight: CGFloat = 0
    var dealerHand: Hand {
        let x = Settings.shared.showDiscardTray ? 0 + Settings.shared.cardWidth + 3 : tableView.center.x - Settings.shared.cardWidth
        return Hand(dealToPoint: CGPoint(x: x , y: 50), adjustmentX: Card.width + 2, adjustmentY: 0, owner: self.dealer) // old x: table.center.x - Settings.shared.cardWidth
    }
    var playerHand: Hand {
        return Hand(dealToPoint: CGPoint(x: tableView.center.x - Settings.shared.cardWidth * 0.7, y: tableView.frame.height - Settings.shared.cardSize - Settings.shared.cardSize * 0.30), adjustmentX: Settings.shared.cardSize * 0.2, adjustmentY: Settings.shared.cardSize * 0.2, owner: player)
    }
    
    init(gameType: GameType, table: UIView) {
        self.gameType = gameType
        self.tableView = table
    }
    
    func startGame() {
        CardCounter.shared.reset()
        //gameStrategyPattern = gameType.getStrategyPattern(gameMaster: self)
        setupDealer(table: tableView)
        setupPlayer()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.dealCards()
        }
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
        gameStrategyPattern.inputReceived(action: type)
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
        
        // NOTE:  Should this condition logic go in the GameTypeProtocol class, eg. FreePlayGameType class??
        if hand.cards.count > 2 {
            print("alert: > 2 cards")
            waitForPlayerInput()
            return
        }
        if hand.isSplitHand && !Settings.shared.doubleAfterSplit {
            print("alert: no DAS")
            waitForPlayerInput()
            return
        }
        
        self.dealer.deal(to: hand, isDouble: true)
        self.gameState = .dealtDouble
    }
    
    func playerSplits() {
        let hand = player.activatedHand!
        
        // NOTE:  Should this condition logic go in the GameTypeProtocol class, eg. FreePlayGameType class??
//        if !hand.canSplit {
//            print("can't split")
//            waitForPlayerInput()
//            return
//        }
        self.dealer.splitHand(for: hand)
        self.gameState = .dealtSplit
    }
    
    func playerStands() {
        let hand = player.activatedHand!
        hand.set(state: .stand)
        if !hand.isFirstHand {
            moveCards(to: .left)
        } else {
            playerHasMoreHandsOrDealersTurn()
        }
    }
    
    func playerSurrenders() {
        let hand = player.activatedHand!
        hand.set(state: .surrender)
        if !hand.isFirstHand {
            moveCards(to: .left)
        } else {
            playerHasMoreHandsOrDealersTurn()
        }
    }
}

extension GameMaster {
    func resume() {
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
            let hand = player.activatedHand!
            if (Rules.didBust(hand: hand)) {
                handleBust(hand: hand)
            } else {
                hand.set(state: .double)
                if !hand.isFirstHand {
                    moveCards(to: .left)
                } else {
                    playerHasMoreHandsOrDealersTurn()
                }
            }
        case .dealtSplit:
            if player.activatedHand!.state == .splitAces {
                revealFaceDownCard()
            } else {
                moveCards(to: .right)
            }
        case .movedAllCards:
            if playerHasBlackjack && player.activatedHand!.state == .incomplete {
                self.player.activatedHand!.set(state: .blackjack)
                discard(hand: player.activatedHand!)
            } else {
                playerHasMoreHandsOrDealersTurn()
            }
        case .discardedHand, .busted:
            if player.activatedHand!.isSplitHand && !player.activatedHand!.isFirstHand {
                moveCards(to: .left)
            } else {
                playerHasMoreHandsOrDealersTurn()
            }
        case .revealedFaceDownCard:
            if Rules.isSoftOrHardSeventeenOrGreater(hand: self.dealer.activatedHand!) || (dealerHasBlackjack || player.hands.count == 1 && player.hands.first?.state == .blackjack) || player.allHandsBust() {
                discardAllHands()
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.dealer.moveCardToNewPositionOnTable()
                }
                self.gameState = .movedRevealCard
            }
        case .movedRevealCard:
            self.dealer.dealtToAtLeast17()
            self.gameState = .dealtToAtLeast17
        case .dealtToAtLeast17:
            self.discardAllHands()
        case .discardedAllHands:
            tasksForEndOfRound()
        case .tappedBackButton:
            print("back button")
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
            if player.activatedHand!.isFirstHand {
                self.delegate.playerInput(enabled: false)
                revealFaceDownCard()
            } else {
                discard(hand: player.activatedHand!)
            }
        
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
        gameStrategyPattern.waitForPlayerInput()
        
//        if gameStrategyPattern.automaticPlay {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                let pAction = self.getPlayerAction()
//                self.inputReceived(type: pAction)
//            }
//        } else {
//            dealer.indicateDealerIsReadyForPlayerInput(on: player.activatedHand!)
//            delegate.playerInput(enabled: true)
//        }
    }
    
    func discard(hand: Hand) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.dealer.discard(hand: self.player.activatedHand!)
            self.gameState = .discardedHand
        }
    }
    
    func revealFaceDownCard() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.dealer.revealCard()
        }
        self.gameState = .revealedFaceDownCard
    }
    
    func discardAllHands() {
        let wait: Double = gameType == .runningCount ? 2.0 : 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + wait) {
            self.dealer.discard(hand: self.dealer.activatedHand!)
            self.player.hands.forEach {
                self.dealer.discard(hand: $0)
            }
            self.player.clearHands()
            self.gameState = .discardedAllHands
        }
    }
    
    func handleBust(hand: Hand) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            hand.set(state: .bust)
            self.gameState = .busted
            
            
            //self.resume()
            
            // NOTE/UPDATE: Code was just calling resume().... instead of discarding.... I think skippped discarding for some reason but I don't remember the exact reason.  Was it to do with card counting? Anyway, going to comment out resume() and call discard() instead, and can put a gameType condition, or whatever is needed, to make the option to skip discarding and just resume play, ie. don't discard any hands until the round is over, and all cards are discarded at the same time.
            // UPDATE: maybe it was to avoid discarding first hand when bust...?
            
            if hand.isFirstHand {
                self.resume()
            } else {
                self.discard(hand: hand)
            }
        }
    }
    
    func askForInsurance() {
        // TODO:
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
