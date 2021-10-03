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
    var tableView: UIView
    var gameState: GameState!
    var navBarHeight: CGFloat = 0
    var dealerHand: Hand {

        var x = tableView.center.x - Settings.shared.cardWidth
        if Settings.shared.showDiscardTray {
            if UIScreen.main.bounds.width / 2 < Settings.shared.cardWidth * 2 {
                x = Settings.shared.cardWidth + 3
            }
        }
        return Hand(dealToPoint: CGPoint(x: x , y: 50), adjustmentX: Card.width + 2, adjustmentY: 0, owner: self.dealer) 
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
        setupDealer()
        setupPlayer()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.dealCards()
        }
    }
    
    func dealCards() {
        gameStrategyPattern.dealCards()
        self.gameState = .dealtCards
    }
    
    func setupDealer() {
        let table = Table(view: tableView, gameMaster: self) // table tells GM when animations are complete so GM can sync game flow with player input and player UI visuals
        self.dealer = Dealer(table: table)//, numberOfDecks: Settings.shared.numberOfDecks)
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
                player.activatedHand!.set(state: .blackjack)
                //discard(hand: player.activatedHand!)
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
            if Rules.isSoftOrHardSeventeenOrGreater(hand: dealer.activatedHand!) || (dealerHasBlackjack || player.hands.count == 1 && player.hands.first?.state == .blackjack) || player.allHandsBust() {
                
                gameState = .moveToRightMostHandToScore
                resume()
                //discardAllHands()
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.dealer.moveCardToNewPositionOnTable()
                }
                gameState = .movedRevealCard
            }
        case .movedRevealCard:
            dealer.dealtToAtLeast17()
            gameState = .dealtToAtLeast17
        case .dealtToAtLeast17:
        //discardAllHands()
        
            // at this point, before discarding all hands, the dealer needs to compare his hand to the player's hands to determine what hands won, lost, or pushed.
            // Need to move to the had that has not been scored, then show a toast for the result
            // Then move to the next hand, until there are no more hands
            // After all that, the hands can be discarded
            
            gameState = .moveToRightMostHandToScore
            resume()
            
            
            
        case .moveToRightMostHandToScore:
            print("move to right most hand to score")
            // for the first time, move to the right most hand
            let numberOfHands = player.hands.count
            for _ in 1..<numberOfHands {
                dealer.table.moveAllCards(for: player, to: .right)
            }
            gameState = .movedToHandToScore
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.resume()
            }
            
            
            // after that, just move to the left one at a time, until at first hand position
            // need to get the hand that needs to be scored
            // then call table to move cards as needed
            // if only the first hand, then no need to move cards
            // then set gameState to movedToHandScore
           
        case .moveToNextHandToScore:
            print("move to next hand to score")
            dealer.table.moveAllCards(for: player, to: .left)
            gameState = .movedToHandToScore
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.resume()
            }
            
        case .movedToHandToScore:
            print("moved to hand to score")
            let hand = player.nextHandToScore!
            let dealerHandValue = Rules.value(of: dealer.activatedHand!)
            let playerHandValue = Rules.value(of: hand)
            var message = ""
            if dealerHandValue == playerHandValue {
                message = "Push"
                hand.result = .push
            } else if playerHandValue > dealerHandValue {
                message = "Won"
                hand.result = .won
            } else {
                message = "Lost"
                hand.result = .lost
            }
            
            if hand.state == .bust {
                message = "Lost"
                hand.result = .lost
            }
            else if Rules.didBust(hand: dealer.activatedHand!) {
                message = "Won"
                hand.result = .won
            }
           
            delegate.showToast(message: message)
            gameState = .showedToast
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                self.resume()
            }
            // Compare the dealer and player values
            // show toast with message: won,lost,push
            // set gameState to showedToast
            
        case .showedToast:
            print("showed toast")
            let hand = player.nextHandToScore
            if hand == nil {
                discardAllHands()
            } else {
                gameState = .moveToNextHandToScore
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.resume()
                }
            }
            // moveToHandToScore
            // if no more hands to move to, discardAllHands()
            
            
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
        // move cards so right most hand is centered. Compare hand with dealer.
        // Show toast - Won, Lost, Push
        // Move to next right-most player hand
        // Show toast
        // After last player hand, discard all at same time
        
        
        
        
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
            
            self.delegate.showToast(message: "Bust")
            
            
         
            
            if hand.isFirstHand {
                self.resume()
            } else {
                //self.resume()
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
