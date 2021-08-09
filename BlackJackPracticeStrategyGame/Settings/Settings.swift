//
//  Settings.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/13/21.
//

import Foundation
import UIKit

class Settings {
    static let shared = Settings()
    private init() {}
    
    let defaults = Defaults()
    
    var cardSize: CGFloat {
        set {
            UserDefaults.standard.set(newValue, forKey: "cardSize")
        }
        get {
            return UserDefaults.standard.object(forKey: "cardSize") as? CGFloat ?? 150.0
        }
    }
    
    var cardWidth: CGFloat {
        get {
            return (cardSize * 0.708).rounded()
        }
    }
    
    var dealSpeed: Float {
        set {
            UserDefaults.standard.set(newValue, forKey: "dealSpeed")
        }
        get {
            
            return UserDefaults.standard.object(forKey: "dealSpeed") as? Float ?? defaults.dealSpeed
        }
    }
    var ENHC: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "ENHC")
        }
        get {
            return UserDefaults.standard.object(forKey: "ENHC") as? Bool ?? defaults.ENHC
        }
    }
    var ES10: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "ES10")
        }
        get {
            return UserDefaults.standard.object(forKey: "ES10") as? Bool ?? false
        }
    }
    var surrender: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "surrender")
        }
        get {
            return UserDefaults.standard.object(forKey: "surrender") as? Bool ?? defaults.surrender
        }
    }
    var twoCardHands: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "twoCardHands")
        }
        get {
            return UserDefaults.standard.object(forKey: "twoCardHands") as? Bool ?? true
        }
    }
    var threeCardHands: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "threeCardHands")
        }
        get {
            return UserDefaults.standard.object(forKey: "threeCardHands") as? Bool ?? false
        }
    }
    var fourCardHands: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "fourCardHands")
        }
        get {
            return UserDefaults.standard.object(forKey: "fourCardHands") as? Bool ?? false
        }
    }
    var splitHands: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "splitHands")
        }
        get {
            return UserDefaults.standard.object(forKey: "splitHands") as? Bool ?? true
        }
    }
    var softHands: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "softHands")
        }
        get {
            return UserDefaults.standard.object(forKey: "softHands") as? Bool ?? true
        }
    }
    var hardHands: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "hardHands")
        }
        get {
            return UserDefaults.standard.object(forKey: "hardHands") as? Bool ?? true
        }
    }
    var numberOfRoundsBeforeAskCount: String {
        set {
            UserDefaults.standard.set(newValue, forKey: "numberOfRoundsBeforeAskCount")
        }
        get {
            return UserDefaults.standard.object(forKey: "numberOfRoundsBeforeAskCount") as? String ?? defaults.numberOfRoundsBeforeAskCount.rawValue
        }
    }
    var numberOfDecks: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: "numberOfDecks")
        }
        get {
            return UserDefaults.standard.object(forKey: "numberOfDecks") as? Int ?? defaults.numberOfDecks
        }
    }
    var dealerHitsSoft17: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "dealHitsSoft17")
        }
        get {
            return UserDefaults.standard.object(forKey: "dealHitsSoft17") as? Bool ?? defaults.dealerHitsSoft17
        }
    }
    var resplitAces: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "resplitAces")
        }
        get {
            return UserDefaults.standard.object(forKey: "resplitAces") as? Bool ?? defaults.resplitAces
        }
    }
    var doubleAfterSplit: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "doubleAfterSplit")
        }
        get {
            return UserDefaults.standard.object(forKey: "doubleAfterSplit") as? Bool ?? defaults.doubleAfterSplit
        }
    }
    var notifyMistakes: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "notifyMistakes")
        }
        get {
            return UserDefaults.standard.object(forKey: "notifyMistakes") as? Bool ?? defaults.notifyMistakes
        }
    }
    var showHandTotal: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "showHandTotal")
        }
        get {
            return UserDefaults.standard.object(forKey: "showHandTotal") as? Bool ?? defaults.showHandTotal
        }
    }
    var showDiscardTray: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "showDiscardTray")
        }
        get {
            return UserDefaults.standard.object(forKey: "showDiscardTray") as? Bool ?? defaults.showHandTotal
        }
    }
    var deviations: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "deviations")
        }
        get {
            return UserDefaults.standard.object(forKey: "deviations") as? Bool ?? defaults.deviations
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
    
    static var dealSpeedFactor: Float {
        let dealSpeed = self.shared.dealSpeed
        return 1.0 / dealSpeed
    }
    
    
    
    struct Defaults {
        var dealSpeed: Float = 1.0
        var ENHC: Bool = false
        var numberOfDecks = 6
        var dealerHitsSoft17 = true
        var surrender = true
        var resplitAces = false
        var doubleAfterSplit = true
        var notifyMistakes = true
        var showHandTotal = false
        var showDiscardTray = false
        var deviations = true
        var numberOfRoundsBeforeAskCount = CountRounds.oneRound
    }
}

//enum HandType: String {
//    case twoCardHand = "2 card hand",
//         threeFourCardHand = "3 and 4 card hand",
//         twoThreeFourCardHand = "2, 3 and 4 card hand"
//    
//}
