//
//  Settings.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/13/21.
//

import Foundation

struct Settings {
    static let shared = Settings()
    var dealingSpeed: Float
    var askForCountAfterRounds: CountRounds
    var handType: HandType
    var ENHC: Bool
    var surrender: Bool
    var ES10: Bool

    private init() {
        dealingSpeed = 5
        askForCountAfterRounds = .oneRound
        handType = .twoCardHand
        ENHC = false
        surrender = false
        ES10 = false
    }
}

enum CountRounds: String {
    case oneRound = "1 round",
         threeRounds = "3 rounds",
         fiveRounds = "5 rounds",
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

enum HandType: String {
    case twoCardHand = "2 card hand",
         threeFourCardHand = "3 and 4 card hand",
         twoThreeFourCardHand = "2, 3 and 4 card hand"
    
}
