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
    var c = 0
    private func addReservedHands() {
        var insertAt: Int = -1
        for i in 0...Settings.shared.spotAssignments.count - 1 {
            let assignment: SpotAssignment = Settings.shared.spotAssignments[i]
            if assignment != .empty { insertAt += 1 }
            if assignment == .playerReserved {
                let hand = Hand.getHand(for: i, player: player)
                player.add(hand: hand, at: insertAt)
            }
        }
    }
    
    private func spotAssignmentsForRunningCount() {
        let numberOfSpots = Settings.shared.rcNumberOfSpots
        var array: [Int] = []
        switch numberOfSpots {
        case 1: array = [3]
        case 2: array = [2,3]
        case 3: array = [2,3,4]
        case 4: array = [1,2,3,4]
        case 5: array = [1,2,3,4,5]
        case 6: array = [0,1,2,3,4,5]
        case 7: array = [0,1,2,3,4,5,6]
        default: break
        }
        // if iphone and landscape
        if Settings.shared.verticalSizeClass == .compact {
            array = array.map{ $0 - 1 }
        }
        
        for spotIndex in array {
            let hand = Hand.getHand(for: spotIndex, player: player)
            hand.isGhostHand = true
            player.add(hand: hand)
        }
        dealer.add(hand: Hand.getHand(for: dealer))
    }
    
    
    private func spotAssignments() {
        guard gameType != .runningCount else { spotAssignmentsForRunningCount(); return }
        
        for i in 0...Settings.shared.spotAssignments.count - 1 {
            let assignment: SpotAssignment = Settings.shared.spotAssignments[i]
            var hand: Hand? = Hand.getHand(for: i, player: player)
            switch (assignment) {
                case .playerActive: break
                case .playerReserved:
                    //if !player.dealt2Hands {
                        hand = nil
                    //}
                case .computer: hand!.isGhostHand = true
                case .empty: hand = nil
            }
            if let hand = hand {
                player.add(hand: hand)
            }
        }
        dealer.add(hand: Hand.getHand(for: dealer))
    }
    
    var gameType: GameType
    lazy var gameStrategyPattern: GameTypeStrategyPatternProtocol = {
        return gameType.getStrategyPattern(gameMaster: self)
    }()
    var playerBets: Bool {
        let spots = Settings.shared.spotAssignments
        let hasPlayerSpots = spots.contains(.playerActive) || spots.contains(.playerReserved)
        return gameType == .freePlay && Settings.shared.placeBets && hasPlayerSpots
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
    var killGame = false
    
    init(gameType: GameType, table: UIView) {
        self.gameType = gameType
        self.tableView = table
        setupTable()
    }
    
    func startGame() {
        //self.delegate.showGestureView()
        //Stats.shared.startSession()
        setupDealer()
        setupPlayer()
        //DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + adjustWaitTime(1.0)) {//1.0) {
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
        if player.dealt2Hands {
            SoundPlayer.shared.playSounds([.chips, .chips])
        } else {
            SoundPlayer.shared.playSound(.chips)
        }
        
        if player.dealt2Hands {
            if Settings.shared.landscape {
                addReservedHands()
            } else {
                player.clearHands() // did it this way to get the right deal points
                var hand = Hand.getHand(for: player)
                player.add(hand: hand)// playerHand)
                hand = Hand.getHand(for: player)
                player.add(hand: hand)// playerHand)
                if Settings.shared.ghostHand {
                    hand = Hand.getHand(for: player)
                    hand.isGhostHand = true
                    player.add(hand: hand)
                }
            }
        }
        
        for hand in player.hands {
            if hand.isGhostHand { continue }
            hand.betAmount = amount
        }
        dealCards()
    }
    
    func dealCards() {
        delegate.showNoticeScalingView()
        gameStrategyPattern.dealCards()
    }
    func setupTable() {
        table = Table(view: tableView, gameMaster: self)
    }
    var table: Table!
    func setupDealer() {
        //let table = Table(view: tableView, gameMaster: self) // table tells GM when animations are complete so GM can sync game flow with player input and player UI visuals
        self.dealer = Dealer(table: table)//, numberOfDecks: Settings.shared.numberOfDecks)
        let hand = Hand.getHand(for: dealer) // dealerHand//Hand(dealToPoint: CGPoint(x: 20 + navBarHeight, y: 50), adjustmentX: Card.width + 3, adjustmentY: 0, owner: self.dealer)
        self.dealer.add(hand: hand)
    }
    
    func setupPlayer() {
        let player = Player()
        self.players.append(player)
        self.player = players.first!
        self.players.forEach {
            self.dealer.access(to: $0)
        }
        if Settings.shared.landscape {
            //createHandsForLandscapeTable()
            spotAssignments()
        } else {
            let hand = Hand.getHand(for: player)//playerHand
            player.add(hand: hand)
            
            if Settings.shared.ghostHand {
                let gHand = Hand.getHand(for: player)//playerHand
                gHand.isGhostHand = true
                player.add(hand: gHand)
            }
            
            if Settings.shared.ghostHand {
                //dealer.moveCards(for: player, to: .right)
            }
        }
    }
    
    func tasksForEndOfRound() {
        gameStrategyPattern.tasksForEndOfRound()
    }
    
    func prepareForNewRound() {
        if Settings.shared.landscape {
            //createHandsForLandscapeTable()
            spotAssignments()
        } else {
            var hand = Hand.getHand(for: player)//playerHand
            player.add(hand: hand)
            
            if Settings.shared.ghostHand {
                let gHand = Hand.getHand(for: player)//playerHand
                gHand.isGhostHand = true
                player.add(hand: gHand)
            }
           
            hand = Hand.getHand(for: dealer)//dealerHand
            self.dealer.add(hand: hand)
            if Settings.shared.ghostHand {
                //dealer.moveCards(for: player, to: .left)
            }
        }
        
        let result = checkShoeForTimeToRefill()
        let time = result ? 2.5 : 0
        DispatchQueue.main.asyncAfter(deadline: .now() + adjustWaitTime(time)) {//time) {
            if self.playerBets {
                self.getBet()
            } else {
                self.dealCards()
            }
        }
    }
}

extension GameMaster {
    func inputReceived(type: PlayerAction) {
        //if !player.activatedHand!.isGhostHand {
            self.dealer.stopIndicator()
       // }
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
        //let player = self.players.first!
        let hand = player.activatedHand!
        if hand.betAmount != 0 {
            SoundPlayer.shared.playSound(.chips)
        }
        //Settings.shared.bankRollAmount -= Double(hand.betAmount)
        Bankroll.shared.add(-Double(hand.betAmount))
        hand.betAmount += hand.betAmount
    
        if hand.isSplitHand && !Settings.shared.doubleAfterSplit {
            //print("alert: no DAS")
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
            if player.howManyTimesHasOriginalHandBeenSplit(hand) == 4 {
                return false
            }
       
        return !(hand.cards.count > 2) && hand.cards[0].value.rawValue == hand.cards[1].value.rawValue
        //return true
    }
    
    func playerSplits() {
        let hand = player.activatedHand!
        if hand.betAmount != 0 {
            SoundPlayer.shared.playSound(.chips)
        }
        self.dealer.splitHand(for: hand)
        self.gameState = .dealtSplit
    }
    
    func playerStands() {
        let hand = player.activatedHand!
        hand.set(state: .stand)
        //if Settings.shared.landscape {
        //    playerHasMoreHandsOrDealersTurn()
        //} else {
        if !hand.isLastHand && Settings.shared.tableOrientation != TableOrientation.landscape.rawValue {//!hand.isFirstHand && player.hands.count > 1 {
            moveCards(to: .left)
        } else {
            playerHasMoreHandsOrDealersTurn()
        }
        //}
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
            dealer.shoe.refill()
            delegate.showToast(message: "Shuffle", for: nil)
           //SoundPlayer.shared.playSound(.shuffle)
            SoundPlayer.shared.playSounds([.shuffle])
           
        }
        return result
    }
    
   
}

extension GameMaster {
    func resume() {
        if killGame {
            return
        }
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
                if !hand.isLastHand && Settings.shared.tableOrientation != TableOrientation.landscape.rawValue {//hand.isFirstHand && player.hands.count > 1 {//if !hand.isFirstHand {
                    moveCards(to: .left)
                } else {
                    playerHasMoreHandsOrDealersTurn()
                }
            }
        case .dealtSplit:
            
            //if Settings.shared.landscape {
            //    gameState = .movedAllCards
            //    resume()
            //} else {
                //moveCards(to: .right)
            gameState = .movedAllCards
            resume()
            //}
        case .movedAllCards:
            //player.movedToHand(player.activatedHand!)
            if playerHasBlackjack && player.activatedHand!.state == .incomplete {
                player.activatedHand!.set(state: .blackjack)
                handleWon(for: player.activatedHand!)
                DispatchQueue.main.asyncAfter(deadline: .now() + adjustWaitTime(1)) {
                    self.discard(hand: self.player.activatedHand!)
                }

            } else {
                playerHasMoreHandsOrDealersTurn()
            }
        case .discardedHand, .busted, .surrendered:
            //if Settings.shared.landscape {
            //    playerHasMoreHandsOrDealersTurn()
            //} else {
                if player.activatedHand!.isSplitHand && !player.activatedHand!.isLastHand || (player.dealt2Hands && !player.activatedHand!.isLastHand) || (!player.activatedHand!.isLastHand) && Settings.shared.tableOrientation != TableOrientation.landscape.rawValue {
//                if player.activatedHand!.isSplitHand && !player.activatedHand!.isFirstHand || (player.dealt2Hands && !player.activatedHand!.isFirstHand) || (!player.activatedHand!.isFirstHand) {
                    moveCards(to: .left)
                } else {
                    playerHasMoreHandsOrDealersTurn()
                }
            //}
        case .revealedFaceDownCard:
            if Rules.isSoftOrHardSeventeenOrGreater(hand: dealer.activatedHand!) || dealerHasBlackjack || player.allHandsBustSurrenderOrBlackjack() {
                if player.nextHandToScore != nil {
                    gameState = .moveToRightMostHandToScore
                    resume()
                } else {
                    discardAllHands()
                }
            } else {
                gameState = .movedRevealCard
                self.dealer.moveCardToNewPositionOnTable()
                //gameState = .movedRevealCard
            }
        case .movedRevealCard:
            dealer.dealtToAtLeast17()
            gameState = .dealtToAtLeast17
        case .dealtToAtLeast17:
            if gameType == .runningCount {
                discardAllHands()
                return
            }
            gameState = .moveToRightMostHandToScore
            resume()

        case .moveToRightMostHandToScore:
            // move to Left Most Hand to score first, then work to right
            
            if dealerHasBlackjack || (player.dealt2Hands && player.hands.count == 2 && player.allHandsBustSurrenderOrBlackjack())  {//&& player.activatedHand != nil && player.hands[1] === player.activatedHand! {
            } else {
                
                
                for _ in 0..<player.numberOfHandsToMoveForScore {
                    dealer.table.moveAllCards(for: player, to: .right)//.right)
                }
            }
            gameState = .movedToHandToScore
            DispatchQueue.main.asyncAfter(deadline: .now() + adjustWaitTime(0.5)) {
                self.resume()
            }

        case .moveToNextHandToScore:
            if Settings.shared.landscape {
                
            } else {
                for _ in 0..<player.numberOfHandsToMoveForScore {
                    dealer.table.moveAllCards(for: player, to: .right)
                }
            }
            gameState = .movedToHandToScore
            DispatchQueue.main.asyncAfter(deadline: .now() + adjustWaitTime(0.5)) {
                self.resume()
            }

        case .movedToHandToScore:
            if player.nextHandToScore == nil {
                discardAllHands()
                return
            }
            let hand = player.nextHandToScore!
            player.movedToHand(hand)
            if Settings.shared.dealDoubleFaceDown && hand.cards.last!.isDouble && hand.cards.last!.isFaceDown {
                flipOver(card: hand.cards.last!)
                return
            }
            //player.indexOfLastHandScored = player.hands.firstIndex(where: { $0 === hand })
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
        guard !Settings.shared.landscape else {
            DispatchQueue.main.asyncAfter(deadline: .now() + self.adjustWaitTime(0.5)) {
                self.gameState = .movedAllCards
                self.resume()
            }
            return
        }
        
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
            if player.activatedHand!.isLastHand {//player.activatedHand!.isFirstHand {
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
                //if Settings.shared.landscape {
                //    self.delegate.playerInput(enabled: false)
                //    revealFaceDownCard()
                //} else {
                if !hand.isLastHand {//&& Settings.shared.tableOrientation != TableOrientation.landscape.rawValue{//hand.isFirstHand && player.hands.count > 1 {//if !hand.isFirstHand {
                    moveCards(to: .left)
                } else {
                    self.delegate.playerInput(enabled: false)
                    revealFaceDownCard()
                }
                //}
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
        let sa = BasicStrategy.getPlayerAction(dealerCardValue: dealer.activatedHand!.cards.last!.value.rawValue, playerCardValues: playerCardValues)
        var s = ""
        for value in playerCardValues {
            s += " \(value),"
        }
        //print("\(c); RC: \(CardCounter.shared.getRunningCount()); TC: \(CardCounter.shared.getTrueCount()); handValue:\(s); dealerValue: \(dealer.activatedHand!.cards.last!.value.rawValue); action: \(sa.action)" )
        c += 1
        return sa
    }
    
    func waitForPlayerInput() {
        let hand = player.activatedHand!
        if hand.isSplitHand && hand.cards.count == 1 {
            gameState = .dealtHit
            dealer.deal(to: hand)
        } else {
            gameStrategyPattern.waitForPlayerInput()
        }
    }
    
    private func discard(hand: Hand) {
        //SoundPlayer.shared.playSound(.discard)
        DispatchQueue.main.asyncAfter(deadline: .now() + adjustWaitTime(1)) {
            SoundPlayer.shared.playSound(.discard)
            
            self.dealer.discard(hand: self.player.activatedHand!)
            self.gameState = .discardedHand
        }
    }
    
    private func revealFaceDownCard() {
        dealer.table.stopIndicator()
        dealer.revealCard()
        gameState = .revealedFaceDownCard
    }
    
    private func adjustWaitTime(_ time: Double) -> Double {
        return time * Settings.dealSpeedFactor
        //return 0
    }
    
    func discardAllHands() {
        //SoundPlayer.shared.playSound(.discard)
        let wait: Double = gameType == .runningCount ? 1.0 : 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + adjustWaitTime(wait)) {
            SoundPlayer.shared.playSound(.discard)
            
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
        player.indexOfLastHandScored = player.hands.firstIndex(where: { $0 === hand })
        hand.result = .won
        updateBankRoll(for: hand)
    }
    
    private func handleLost(for hand: Hand) {
        player.indexOfLastHandScored = player.hands.firstIndex(where: { $0 === hand })
        hand.result = .lost
        updateBankRoll(for: hand)
    }
    
    private func updateBankRoll(for hand: Hand) {
        if hand.isGhostHand { return }
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
                SoundPlayer.shared.playSound(.chips)
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
                SoundPlayer.shared.playSound(.chips)
                message += " -$\(Int(betAmount))"
            }
        } else if result == .surrender {
            message = "Lost"
            if playerBets {
                SoundPlayer.shared.playSound(.chips)
                if Rules.hasRemainder(finalAmount) {
                    message += String(format: " -$%.2f", finalAmount)
                } else {
                    message += " -$\(Int(finalAmount))"
                }
            }
        } else if result == .push {
            message = "Push"
        }
        delegate.showToast(message: message, for: hand)
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
            self.delegate.showToast(message: "Bust", for: hand)
            DispatchQueue.main.asyncAfter(deadline: .now() + self.adjustWaitTime(1.5)) {
                self.handleLost(for: hand)
                self.discard(hand: hand)
            }
        }
    }
    
    private func askInsurance() {
        if Settings.shared.placeBets && dealer.activatedHand!.cards[1].value == .ace {
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
