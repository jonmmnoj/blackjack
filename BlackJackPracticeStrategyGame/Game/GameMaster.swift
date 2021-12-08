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
    var playerBets: Bool {
        return gameType == .freePlay && Settings.shared.placeBets
    }
    var showDiscardTray: Bool {
        return Settings.shared.showDiscardTray && gameType == .freePlay
    }
    var dealer: Dealer!
    var players: [Player] = []
    var player: Player!
    var delegate: GameViewDelegate!
    var dealerBusy = false
    var tableView: UIView
    var gameState: GameState!
    var navBarHeight: CGFloat = 0
    var dealerHandDealPoint: CGPoint {
        var x = tableView.center.x - Settings.shared.cardWidth * 0.6
        if showDiscardTray {
            if UIScreen.main.bounds.width / 2 < Settings.shared.cardWidth * 2 {
                x = Settings.shared.cardWidth + 3
            }
        }
        return CGPoint(x: x , y: 50)
    }
    var dealerHandAdjustmentX: CGFloat {
        return Card.width * 0.15//Card.width + 2
    }
    var dealerHandAdjustmentY: CGFloat {
        return 0
    }
    var dealerHand: Hand {
        return Hand(dealToPoint: dealerHandDealPoint, adjustmentX: dealerHandAdjustmentX , adjustmentY: dealerHandAdjustmentY, owner: self.dealer)
    }
    func getPlayerHandDealPoint(numberOfHandsToAdjustBy: Int) -> CGPoint {
        var numberOfHandsAdjustment: CGFloat = 0
        numberOfHandsAdjustment += CGFloat(numberOfHandsToAdjustBy) * (Settings.shared.cardWidth * 1.85)
        return  CGPoint(x: tableView.center.x - Settings.shared.cardWidth * 0.7 + numberOfHandsAdjustment, y: tableView.frame.height - Settings.shared.cardSize - Settings.shared.cardSize * 0.30)
    }
    
    var playerHandDealPoint: CGPoint {
        var numberOfHandsAdjustment: CGFloat = 0
        numberOfHandsAdjustment += CGFloat(player.hands.count) * (Settings.shared.cardWidth * 1.85)
        return  CGPoint(x: tableView.center.x - Settings.shared.cardWidth * 0.7 + numberOfHandsAdjustment, y: tableView.frame.height - Settings.shared.cardSize - Settings.shared.cardSize * 0.30)
    }
    var playerAdjustmentXorY: CGFloat {
        return Settings.shared.cardSize * 0.2
    }
    var playerHand: Hand {
        return Hand(dealToPoint: playerHandDealPoint, adjustmentX: playerAdjustmentXorY, adjustmentY: playerAdjustmentXorY, owner: player)
    }
    
    init(gameType: GameType, table: UIView) {
        self.gameType = gameType
        self.tableView = table
    }
    
    func startGame() {
        //CardCounter.shared.reset()
        setupDealer()
        setupPlayer()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if self.playerBets {
                self.getBet()
            } else {
                self.dealCards()
            }
        }
    }
    
    func getBet() {
        self.delegate.showPlaceBetView()
    }
    
    func playerBet(amount: Int) {
        SoundPlayer.shared.playSound(type: .chips)
        if player.dealt2Hands {
            player.add(hand: playerHand)
            if Settings.shared.ghostHand {
                dealer.table.moveAllCards(for: player, to: .right, startIndex: player.hands.count - 1)
            } else {
                
            }
            dealer.moveCards(for: player, to: .right)
        }
        
        for hand in player.hands {
            if hand.isGhostHand { continue }
            hand.betAmount = amount
        }
        dealCards()
    }
    
    func dealCards() {
        gameStrategyPattern.dealCards()
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
        
        if Settings.shared.ghostHand {
            let gHand = playerHand
            gHand.isGhostHand = true
            player.add(hand: gHand)
        }
        
        let hand = playerHand
        player.add(hand: hand)
       
        if Settings.shared.ghostHand {
            dealer.moveCards(for: player, to: .right)
        }
    }
    
    func tasksForEndOfRound() {
        gameStrategyPattern.tasksForEndOfRound()
    }
    
    func prepareForNewRound() {
        if Settings.shared.ghostHand {
            let gHand = playerHand
            gHand.isGhostHand = true
            player.add(hand: gHand)
        }
        
        var hand = playerHand
        player.add(hand: hand)
        hand = dealerHand
        self.dealer.add(hand: hand)
        
       
        
        if Settings.shared.ghostHand {
            dealer.moveCards(for: player, to: .right)
        }
        
        
        let result = checkShoeForTimeToRefill()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (result ? 2.5 : 0)) {
            if self.playerBets {
                self.getBet()
            } else {
                self.dealCards()
            }
        }
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
        //Settings.shared.bankRollAmount -= Double(hand.betAmount)
        Bankroll.shared.add(-Double(hand.betAmount))
        hand.betAmount += hand.betAmount
    
        if hand.isSplitHand && !Settings.shared.doubleAfterSplit {
            print("alert: no DAS")
            waitForPlayerInput()
            return
        }
        
        self.dealer.deal(to: hand, isDouble: true)
        self.gameState = .dealtDouble
    }
    
    var canDouble: Bool {
        return !(player.activatedHand!.cards.count > 2) && !player.activatedHand!.isSplitAce
        //return true
    }
    var canSurrender: Bool {
        return Settings.shared.surrender && !(player.activatedHand!.cards.count > 2) && !player.activatedHand!.isSplitHand
    }
    var canSplit: Bool {
        let hand = player.activatedHand!
        return !(hand.cards.count > 2) && hand.cards[0].value.rawValue == hand.cards[1].value.rawValue
        //return true
    }
    
    func playerSplits() {
        let hand = player.activatedHand!
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
        handleSurrender(for: hand)
    }
    
    func checkShoeForTimeToRefill() -> Bool {
        var result = false
        if gameType != .freePlay {
            return result
        }
        if dealer.shoe.isTimeToRefillShoe() {
            result = true
            delegate.showToast(message: "Shuffle")
            dealer.shoe.refill()
        }
        return result
    }
}

extension GameMaster {
    func resume() {
        switch gameState {
        case .askInsurance:
            askInsurance()
        case .dealtCards:
            // assume one hand game -- need to change for 2-hand games
           
             if dealerHasBlackjack {
                revealFaceDownCard()
             } else if playerHasBlackjack {
                player.activatedHand!.set(state: .blackjack)
                self.handleWon(for: self.player.activatedHand!)
                self.discard(hand: self.player.activatedHand!)
               
                //DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                 //   self.playerHasMoreHandsOrDealersTurn()
                //}
                //revealFaceDownCard()
        
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
            moveCards(to: .right)
        case .movedAllCards:
            if playerHasBlackjack && player.activatedHand!.state == .incomplete {
                player.activatedHand!.set(state: .blackjack)

                handleWon(for: player.activatedHand!)
                //DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                DispatchQueue.main.asyncAfter(deadline: .now() + adjustWaitTime(1)) {
                    self.discard(hand: self.player.activatedHand!)
                }

            } else {
                playerHasMoreHandsOrDealersTurn()
            }
        case .discardedHand, .busted, .surrendered:
            if player.activatedHand!.isSplitHand && !player.activatedHand!.isFirstHand || (player.dealt2Hands && !player.activatedHand!.isFirstHand) || (!player.activatedHand!.isFirstHand) {
                moveCards(to: .left)
            } else {
                playerHasMoreHandsOrDealersTurn()
            }
        case .revealedFaceDownCard:
            if Rules.isSoftOrHardSeventeenOrGreater(hand: dealer.activatedHand!) || dealerHasBlackjack || player.allHandsBustSurrenderOrBlackjack() {
                
//                if dealerHasBlackjack && player.dealt2Hands {
//
//                }

                if player.nextHandToScore != nil {
                    gameState = .moveToRightMostHandToScore
                    resume()
                } else {
                    discardAllHands()
                }
            } else {
                //DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                //DispatchQueue.main.asyncAfter(deadline: .now() + adjustWaitTime(0)) {
                    self.dealer.moveCardToNewPositionOnTable()
                //}
                gameState = .movedRevealCard
            }
        case .movedRevealCard:
            dealer.dealtToAtLeast17()
            gameState = .dealtToAtLeast17
        case .dealtToAtLeast17:

            if gameType == .runningCount {
                discardAllHands()
                return
            }

            // at this point, before discarding all hands, the dealer needs to compare his hand to the player's hands to determine what hands won, lost, or pushed.
            // Need to move to the had that has not been scored, then show a toast for the result
            // Then move to the next hand, until there are no more hands
            // After all that, the hands can be discarded

            gameState = .moveToRightMostHandToScore
            resume()



        case .moveToRightMostHandToScore:
            if dealerHasBlackjack || (player.dealt2Hands && player.hands.count == 2 && player.allHandsBustSurrenderOrBlackjack())  {//&& player.activatedHand != nil && player.hands[1] === player.activatedHand! {
                
            } else {
            
                for _ in 0..<player.numberOfHandsToMoveForScore {
                    dealer.table.moveAllCards(for: player, to: .right)
                }
            }
            gameState = .movedToHandToScore
            DispatchQueue.main.asyncAfter(deadline: .now() + adjustWaitTime(0.5)) {
                self.resume()
            }

        case .moveToNextHandToScore:
            for _ in 1...player.numberOfHandsToMoveForScore {
                dealer.table.moveAllCards(for: player, to: .left)
            }
            gameState = .movedToHandToScore
            DispatchQueue.main.asyncAfter(deadline: .now() + adjustWaitTime(0.5)) {
                self.resume()
            }

        case .movedToHandToScore:
            let hand = player.nextHandToScore!
            if Settings.shared.dealDoubleFaceDown && hand.cards.last!.isDouble && hand.cards.last!.isFaceDown {
                flipOver(card: hand.cards.last!)
                return
            }
            player.indexOfLastHandScored = player.hands.firstIndex(where: { $0 === hand })
            let dealerHandValue = Rules.value(of: dealer.activatedHand!)
            let playerHandValue = Rules.value(of: hand)
            var isWin: Bool?
            if Rules.hasBlackjack(hand: hand) && !dealerHasBlackjack {
               isWin = true
            } else if dealerHandValue == playerHandValue {
                hand.result = .push
                updateBankRoll(for: hand)
            } else if playerHandValue > dealerHandValue {
                isWin = true
            } else {
                isWin = false
            }

            if hand.state == .bust {
                isWin = false
            }
            else if Rules.didBust(hand: dealer.activatedHand!) {
                isWin = true
            }

            if let isWin = isWin {
                if isWin {
                    handleWon(for: hand)
                } else {
                    handleLost(for: hand)
                }
            }

            gameState = .showedToast
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            //DispatchQueue.main.asyncAfter(deadline: .now() + adjustWaitTime(wait)) {
                self.resume()
            }
           
        case .flippedOverDouble:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7 * Settings.dealSpeedFactor) {
                self.gameState = .movedToHandToScore
                self.resume()
            }

        case .showedToast:
            let hand = player.nextHandToScore
            if hand == nil {
                discardAllHands()
            } else {
                gameState = .moveToNextHandToScore
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.resume()
                }
            }

        case .discardedAllHands:
            tasksForEndOfRound()
        case .tappedBackButton:
            print("back button")

        default:
            print("GameMaster.resume() default case")
        }
    }
    
    private func flipOver(card: Card)  {
        self.dealer.table.animateReveal(card: card)
        gameState = .flippedOverDouble
    }

    private func moveCards(to direction: MoveCardsDirection) {
        DispatchQueue.main.asyncAfter(deadline: .now() + adjustWaitTime(1.5)) {
            self.dealer.moveCards(for: self.player, to: direction)
            self.gameState = .movedAllCards
            DispatchQueue.main.asyncAfter(deadline: .now() + self.adjustWaitTime(0.5)) {
                self.resume()
            }
        }
    }
    
    private func playerHasMoreHandsOrDealersTurn() {
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
                DispatchQueue.main.asyncAfter(deadline: .now() + adjustWaitTime(1.0)) {
                    self.handleWon(for: self.player.activatedHand!)
                    self.discard(hand: self.player.activatedHand!)
                }
            }
        } else if player.activatedHand!.isSplitAce /* this is a split ace hand to the left of another split ace hand */{
            let hand = player.activatedHand!
            if !hand.isAces() {
                hand.set(state: .stand)
                if !hand.isFirstHand {
                    moveCards(to: .left)
                } else {
                    self.delegate.playerInput(enabled: false)
                    revealFaceDownCard()
                }
            } else {
                waitForPlayerInput()
            }
        } else {
            waitForPlayerInput()
        }
    }
    
    func getPlayerAction() -> StrategyAction {
        var playerCardValues: [Int] = []
        for card in player.activatedHand!.cards {
            playerCardValues.append(card.value.rawValue)
        }
        let sa = BasicStrategy.getPlayerAction(dealerCardValue: dealer.activatedHand!.cards.last!.value.rawValue, playerCardValues: playerCardValues )
        return sa
    }
    
    func waitForPlayerInput() {
        gameStrategyPattern.waitForPlayerInput()
    }
    
    private func discard(hand: Hand) {
        DispatchQueue.main.asyncAfter(deadline: .now() + adjustWaitTime(1)) {
            self.dealer.discard(hand: self.player.activatedHand!)
            self.gameState = .discardedHand
        }
    }
    
    private func revealFaceDownCard() {
        self.dealer.revealCard()
        self.gameState = .revealedFaceDownCard
    }
    
    private func adjustWaitTime(_ time: Double) -> Double {
        return time * Settings.dealSpeedFactor
    }
    
    func discardAllHands() {
        let wait: Double = gameType == .runningCount ? 1.0 : 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + adjustWaitTime(wait)) {
            self.dealer.discard(hand: self.dealer.activatedHand!)
            self.player.hands.forEach {
                self.dealer.discard(hand: $0)
            }
            self.dealer.discardPenetrationCard()
            self.player.clearHands()
            self.gameState = .discardedAllHands
        }
    }
    
    private func handleWon(for hand: Hand) {
        hand.result = .won
        updateBankRoll(for: hand)
    }
    
    private func handleLost(for hand: Hand) {
        hand.result = .lost
        updateBankRoll(for: hand)
    }
    
    private func updateBankRoll(for hand: Hand) {
        let result = hand.result
        var finalAmount: Double = 0
        let betAmount = Double(hand.betAmount)
        if result == .won {
            finalAmount = betAmount * 2
        } else if result == .lost {
            finalAmount = 0
        } else if result == .push {
            finalAmount = betAmount
        } else if result == .surrender {
            finalAmount = betAmount * 0.5
        }
        
        if hand.state == .blackjack {
            finalAmount += betAmount * 0.5
        }
        Bankroll.shared.add(finalAmount)
        
        var message = ""
        if result == .won {
            message = "Won"
            if playerBets {
                let amount = finalAmount - betAmount
                if Rules.hasRemainder(amount) {
                    message += String(format: " +$%.2f", amount)
                } else {
                    message += " +$\(Int(amount))"
                }
            }
        } else if result == .lost {
            message = "Lost"
            if playerBets {
                message += " -$\(Int(betAmount))"
            }
        } else if result == .surrender {
            message = "Lost"
            if playerBets {
                if Rules.hasRemainder(finalAmount) {
                    message += String(format: " -$%.2f", finalAmount)
                } else {
                    message += " -$\(Int(finalAmount))"
                }
            }
        } else if result == .push {
            message = "Push"
        }
        delegate.showToast(message: message)
    }
    
    func returnBetsToPlayer() {
        for hand in player.hands {
            if hand.result == nil {
                Bankroll.shared.add(Double(hand.betAmount))
            }
        }
    }
    
    private func handleSurrender(for hand: Hand) {
        hand.set(state: .surrender)
        hand.result = .surrender
        self.gameState = .surrendered
        self.updateBankRoll(for: hand)
        self.discard(hand: hand)
    }
    
    private func handleBust(hand: Hand) {
        DispatchQueue.main.asyncAfter(deadline: .now() + adjustWaitTime(1)) {
            hand.set(state: .bust)
            self.gameState = .busted
            self.delegate.showToast(message: "Bust")
            DispatchQueue.main.asyncAfter(deadline: .now() + self.adjustWaitTime(1.5)) {
                self.handleLost(for: hand)
                self.discard(hand: hand)
            }
        }
    }
    
    private func askInsurance() {
        if dealer.activatedHand!.cards[1].value == .ace {
            Insurance.askInsurance(player: player, delegate: delegate, dealerHasBlackjack: dealerHasBlackjack, completion: { (playerWantsToInsure, message, amount) in
                if playerWantsToInsure {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        Insurance.showToastForInsureBet(self.delegate, message: message, amount: amount)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.resumeAfterInsurance()
                    }
                } else {
                    self.resumeAfterInsurance()
                }
            })
        } else {
            resumeAfterInsurance()
        }
    }
    
    private func resumeAfterInsurance() {
        gameState = .dealtCards
        resume()
    }
}


extension GameMaster {
    var playerHasBlackjack: Bool {
        return Rules.hasBlackjack(hand: player.activatedHand!)
    }
    
    var dealerHasBlackjack: Bool {
        return Rules.hasBlackjack(hand: dealer.activatedHand!)
    }
    
    func getStringOfPlayerAndDealerHandValue() -> String {
        let playerHand = player.activatedHand!.cards
        var cardValues = [Int]()
        for card in playerHand {
            cardValues.append(card.value.rawValue)
        }
        var dealerUpCardValue = String(dealer.activatedHand!.cards[1].value.rawValue)
        if dealerUpCardValue == "1" {
            dealerUpCardValue = "ACE"
        }
            
        let rule = BasicStrategy.getRuleType(playerCardValues: cardValues)
        let handType = rule.rawValue.uppercased()
        let playerHandValue = String(BasicStrategy.getPlayerRuleValue(rule: rule, playerCardValues: cardValues))
        
        return "\(handType) \(playerHandValue) against \(dealerUpCardValue)"
    }
}
