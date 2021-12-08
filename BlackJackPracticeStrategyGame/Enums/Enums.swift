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
    
    var stringValue: String {
        switch self {
        case .ace: return "1"
        case .two: return "2"
        case .three: return "3"
        case .four: return "4"
        case .five: return "5"
        case .six: return "6"
        case .seven: return "7"
        case .eight: return "8"
        case .nine: return "9"
        case .ten: return "10"
        case .jack: return "J"
        case .queen: return "Q"
        case .king: return "K"
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
         surrendered,
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
         test,
         moveToRightMostHandToScore,
         moveToNextHandToScore,
         movedToHandToScore,
         showedToast,
         askInsurance,
        flippedOverDouble
         
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

enum HandResult {
    case won,
         lost,
         push,
         surrender
}

enum MoveCardsDirection {
    case right,
         left
}

enum PlayerAction: String {
    case stand,
         hit,
         
         double,
         doubleHit,
         doubleStand,
         
         split,
         doNotSplit,
         splitIfDAS,
         
         surrender
    
}

enum Action: String {
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

enum RuleType: String {
    case pair,
         soft,
         hard
}

enum GameType: String {
    case freePlay,
         basicStrategy,
         runningCount,
         trueCount,
         deviations,
         charts,
         deckRounding,
        runningCount_v2
    
    func getStrategyPattern(gameMaster: GameMaster) -> GameTypeStrategyPatternProtocol {
        switch self {
        case .freePlay:
            return FreePlayGameTypeStrategy(gameMaster: gameMaster)
        case .basicStrategy:
            return BasicStrategyGameType(gameMaster: gameMaster)
        case .runningCount:
            return RunningCount(gameMaster: gameMaster)
        case .runningCount_v2:
            return RunningCountV2GameHelper(gameMaster: gameMaster)
        case .deviations:
            return DeviationGameTypeHelper(gameMaster: gameMaster)
        case .trueCount:
            return TrueCountGameHelper(gameMaster: gameMaster)
        case .deckRounding:
            return DeckRoundingGameHelper(gameMaster: gameMaster)
        default:
            return FreePlayGameTypeStrategy(gameMaster: gameMaster)
        
        }
    }
}

enum StrategyDeckType: Int {
    case twoCards = 2,
         threeCards,
         fourCards
}

enum CountRounds: String, CaseIterable {
    case oneRound = "one round",
         threeRounds = "three rounds",
         fiveRounds = "five rounds",
         onceAtEnd = "once at the end"
         //never = "never"

    
    var numericValue: Int {
        switch self {
            case .oneRound: return 1
            case .threeRounds: return 3
            case .fiveRounds: return 5
            case .onceAtEnd: return 0
            //case .never: return -1
        }
    }
}

enum DeviationType {
    case hard17,
         soft17
}

enum Colors {
    case green
}

enum DeckFraction: String, CaseIterable {
    case wholes, halves, thirds, quarters
}

enum DeckRoundedTo: String, CaseIterable {
    case whole, half, quarter
    
    var floatValue: Float {
        switch self {
        case .whole: return 1.0
        case .half: return 0.5
        case .quarter: return 0.25
        }
    }
}

enum NumberOfDecks: Int, CaseIterable {
    case two = 2, four = 4, six = 6, eight = 8
}

enum TableColor: String, CaseIterable {
    case Green = "Green (light)", Green2 = "Green (dark)", Blue, Red, Purple, Yellow, Brown, Black, Gray
    
    var tableCode: String {
        switch self {
        case .Green: return "#005d4b"
        case .Green2: return "#003b30"//"#35654d"
        case .Blue: return "#01005d"
        case .Red: return "#5d0012"
        case .Purple: return "#4b005d"
        case .Yellow: return "#b27e00"//#b29000" 
        case .Brown: return "#5d4200"
        case .Black: return "#1a1a1a"//"#211f1a"
        case .Gray: return "#4d4d4d"
            
        }
    }
    
    // green: 35654d 005d4b
    // red:
    // yellow:
    // blue: 043c7d 368776
    
    
    var buttonCode: String {
        switch self {
        case .Green: return "#00b290"
        case .Green2: return "#009075"//"#00b290"//"#009074"
        case .Blue: return "#0200b2"
        case .Red: return "#b20022"
        case .Purple: return "#9000b2"
        case .Yellow: return "#c19833"
        case .Brown: return "#7d6833"
        case .Black: return "#313131"
        case .Gray: return "#6f6f6f"
            
        }
    }
    
}

enum CardColor: String, CaseIterable {
    case Red, Blue, Purple, Yellow, Green, Gray//, Astronaut
    
}

