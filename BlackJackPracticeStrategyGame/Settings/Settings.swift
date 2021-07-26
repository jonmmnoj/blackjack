//
//  Settings.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/13/21.
//

import Foundation

class Settings {
    static let shared = Settings()
    let defaults = UserDefaults.standard
    
    private init() {}
    
    var dealSpeed: Float {
        set {
            defaults.set(newValue, forKey: "dealSpeed")
        }
        get {
            return defaults.object(forKey: "dealSpeed") as? Float ?? 5.0
        }
    }
    var ENHC: Bool {
        set {
            defaults.set(newValue, forKey: "ENHC")
        }
        get {
            return defaults.object(forKey: "ENHC") as? Bool ?? false
        }
    }
    var ES10: Bool {
        set {
            defaults.set(newValue, forKey: "ES10")
        }
        get {
            return defaults.object(forKey: "ES10") as? Bool ?? false
        }
    }
    var surrender: Bool {
        set {
            defaults.set(newValue, forKey: "surrender")
        }
        get {
            return defaults.object(forKey: "surrender") as? Bool ?? true
        }
    }
    var twoCardHands: Bool {
        set {
            defaults.set(newValue, forKey: "twoCardHands")
        }
        get {
            return defaults.object(forKey: "twoCardHands") as? Bool ?? true
        }
    }
    var threeCardHands: Bool {
        set {
            defaults.set(newValue, forKey: "threeCardHands")
        }
        get {
            return defaults.object(forKey: "threeCardHands") as? Bool ?? false
        }
    }
    var fourCardHands: Bool {
        set {
            defaults.set(newValue, forKey: "fourCardHands")
        }
        get {
            return defaults.object(forKey: "fourCardHands") as? Bool ?? false
        }
    }
    var splitHands: Bool {
        set {
            defaults.set(newValue, forKey: "splitHands")
        }
        get {
            return defaults.object(forKey: "splitHands") as? Bool ?? true
        }
    }
    var softHands: Bool {
        set {
            defaults.set(newValue, forKey: "softHands")
        }
        get {
            return defaults.object(forKey: "softHands") as? Bool ?? true
        }
    }
    var hardHands: Bool {
        set {
            defaults.set(newValue, forKey: "hardHands")
        }
        get {
            return defaults.object(forKey: "hardHands") as? Bool ?? true
        }
    }
    var numberOfRoundsBeforeAskCount: CountRounds {
        set {
            defaults.set(newValue, forKey: "numberOfRoundsBeforeAskCount")
        }
        get {
            return defaults.object(forKey: "numberOfRoundsBeforeAskCount") as? CountRounds ?? .oneRound
        }
    }
    
    static func getTypeOfHands() -> [RuleType] {
        var array: [RuleType] = []
        if self.shared.splitHands {
            array.append(.pair)
        }
        if self.shared.softHands {
            array.append(.soft)
        }
        if self.shared.hardHands {
            array.append(.hard)
        }
        return array
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
