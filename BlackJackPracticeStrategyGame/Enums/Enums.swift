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
    case ace = 1,
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
         dealtToAtLeast17,
         dealtH17,
         dealS17,
         countHands,
         discardedHand,
         discardedAllHands,
         createSplit,
         movedAllCards,
         tappedBackButton,
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
         surrender,
         splitAces
}

enum MoveCardsDirection {
    case right,
         left
}

enum PlayerAction: String {
    case stand,
         hit,
         double,
         split,
         surrender
}

enum StrategyAction: String {
    case split,
         doNotSplit,
         splitIfDAS,
         stand,
         hit,
         double,
         doubleHit,
         doubleStand,
         surrender
}

enum RuleType {
    case pair,
         soft,
         hard
}

enum GameType: String {
    case freePlay,
         basicStrategy,
         runningCount,
         trueCount,
         deviations
    
    func getStrategyPattern(gameMaster: GameMaster) -> GameTypeStrategyPatternProtocol {
        switch self {
        case .freePlay:
            return FreePlayGameTypeStrategy(gameMaster: gameMaster)
        case .basicStrategy:
            return BasicStrategyGameType(gameMaster: gameMaster)
        case .runningCount:
            return RunningCount(gameMaster: gameMaster)
        case .deviations:
            return DeviationGameTypeHelper(gameMaster: gameMaster)
        default:
            return FreePlayGameTypeStrategy(gameMaster: gameMaster)
//        case .trueCount:
//            return FreePlayGameTypeStrategy(gameMaster: gameMaster)
        
        }
    }
}

enum StrategyDeckType: Int {
    case twoCards = 2,
         threeCards,
         fourCards
}

enum CountRounds: String {
    case oneRound = "one round",
         threeRounds = "three rounds",
         fiveRounds = "five rounds",
         onceAtEnd = "once at the end"
    
    var numericValue: Int {
        switch self {
            case .oneRound: return 1
            case .threeRounds: return 3
            case .fiveRounds: return 5
            case .onceAtEnd: return 0
        }
    }
}
