//
//  Enums.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/6/21.
//

import Foundation

enum CardSuit: String, CaseIterable {
    case hearts = "hearts",
         diamonds = "diamonds",
         clubs = "clubs",
         spades = "spades"
    
    var letter: String {
        switch self {
        case .hearts: return "H"
        case .diamonds: return "D"
        case .clubs: return "C"
        case .spades: return "S"
        
        }
    }
}

enum CardValue: Int, CaseIterable {
    case ace,
         two,
         three,
         four,
         five,
         six,
         seven,
         eight,
         nine,
         ten,
         jack,
         queen,
         king
    
    var rawValue: Int {
        switch self {
        case .ace: return 1
        case .two: return 2
        case .three: return 3
        case .four: return 4
        case .five: return 5
        case .six: return 6
        case .seven: return 7
        case .eight: return 8
        case .nine: return 9
        case .ten: return 10
        case .jack: return 10
        case .queen: return 10
        case .king: return 10
        }
    }
}

enum GameState {
    case deal,
         dealtCards,
         waitForInput,
         dealtHit,
         stand,
         dealtDouble,
         dealtSplit,
         busted,
         revealedFaceDownCard,
         movedRevealCard,
         dealtH17,
         dealS17,
         countHands,
         discardedHand,
         discardedAllHands,
         createSplit,
         movedAllCards,
         test
}

enum HandState {
    case bust,
         blackjack,
         stand,
         double,
         won,
         lost,
         push,
         incomplete,
         surrender
}

enum MoveCardsDirection {
    case right, left
}

enum PlayerAction: String {
    case stand, hit, double, split, surrender
}

enum StrategyAction: String {
    case split, doNotSplit, splitIfDAS, stand, hit, double, doubleHit, doubleStand, surrender
}

enum RuleType {
    case pair, soft, hard
}
