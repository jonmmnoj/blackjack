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
    
    var gameType: GameType! {
        didSet {
            
        }
    }
    var placeBets: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "placeBets")
        }
        get {
            return UserDefaults.standard.object(forKey: "placeBets") as? Bool ?? defaults.placeBets
        }
    }
    var bankRollAmount: Double {
        set {
            UserDefaults.standard.set(newValue, forKey: "bankRollAmount")
        }
        get {
            return UserDefaults.standard.object(forKey: "bankRollAmount") as? Double ?? defaults.bankRollAmount
        }
    }
    var previousBetAmount: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: "previousBetAmount")
        }
        get {
            return UserDefaults.standard.object(forKey: "previousBetAmount") as? Int ?? defaults.previousBetAmount
        }
    }
    var gameSettings: [GameType: Defaults]!
    let defaults = Defaults()
    
    var cardSizeFactor: CGFloat {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for: "cardSizeFactor"))
        }
        get {
            
            return UserDefaults.standard.object(forKey: getKey(for:"cardSizeFactor")) as? CGFloat ?? defaults.cardSizeFactor
        }
    }
    
    var cardSize: CGFloat {
//        set {
//            UserDefaults.standard.set(newValue, forKey: getKey(for: "cardSize"))
//        }
        get {
            let size = UserDefaults.standard.object(forKey: getKey(for: "cardSize")) as? CGFloat ?? defaults.cardSizeFactor
            let adjustmentForScreenSize = round(size * (UIScreen.main.bounds.height / 5.5))
            //print (adjustmentForScreenSize)
            return adjustmentForScreenSize
        }
    }
    
    var cardWidth: CGFloat {
        get {
            return (cardSize * 0.708).rounded()
        }
    }
    
    var dealSpeed: Float {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for: "dealSpeed"))
        }
        get {
            
            return UserDefaults.standard.object(forKey: getKey(for:"dealSpeed")) as? Float ?? defaults.dealSpeed
        }
    }
    var ENHC: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"ENHC"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"ENHC")) as? Bool ?? defaults.ENHC
        }
    }
    var ES10: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"ES10"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"ES10")) as? Bool ?? false
        }
    }
    var surrender: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"surrender"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"surrender")) as? Bool ?? defaults.surrender
        }
    }
    var twoCardHands: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"twoCardHands"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"twoCardHands")) as? Bool ?? defaults.twoCardHands
        }
    }
    var threeCardHands: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"threeCardHands"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"threeCardHands")) as? Bool ?? defaults.threeCardHands
        }
    }
    var fourCardHands: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"fourCardHands"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"fourCardHands")) as? Bool ?? defaults.fourCardHands
        }
    }
    var splitHands: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"splitHands"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"splitHands")) as? Bool ?? true
        }
    }
    var softHands: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"softHands"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"softHands")) as? Bool ?? true
        }
    }
    var hardHands: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"hardHands"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"hardHands")) as? Bool ?? true
        }
    }
    var numberOfRoundsBeforeAskRunningCount: String {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"numberOfRoundsBeforeAskRunningCount"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"numberOfRoundsBeforeAskRunningCount")) as? String ?? defaults.numberOfRoundsBeforeAskRunningCount
        }
    }
    var numberOfRoundsBeforeAskTrueCount: String {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"numberOfRoundsBeforeAskTrueCount"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"numberOfRoundsBeforeAskTrueCount")) as? String ?? defaults.numberOfRoundsBeforeAskTrueCount
        }
    }
    var numberOfDecks: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"numberOfDecks"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"numberOfDecks")) as? Int ?? defaults.numberOfDecks
        }
    }
    var dealerHitsSoft17: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"dealHitsSoft17"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"dealHitsSoft17")) as? Bool ?? defaults.dealerHitsSoft17
        }
    }
    var resplitAces: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"resplitAces"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"resplitAces")) as? Bool ?? defaults.resplitAces
        }
    }
    var doubleAfterSplit: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"doubleAfterSplit"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"doubleAfterSplit")) as? Bool ?? defaults.doubleAfterSplit
        }
    }
    var notifyMistakes: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"notifyMistakes"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"notifyMistakes")) as? Bool ?? defaults.notifyMistakes
        }
    }
    var showHandTotal: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"showHandTotal"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"showHandTotal")) as? Bool ?? defaults.showHandTotal
        }
    }
    var showDiscardTray: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"showDiscardTray"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"showDiscardTray")) as? Bool ?? defaults.showDiscardTray
        }
    }
    var deviations: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"deviations"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"deviations")) as? Bool ?? defaults.deviations
        }
    }
    var deckFraction: String {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"deckFraction"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"deckFraction")) as? String ?? defaults.deckFraction
        }
    }
    var deckRoundedTo: String {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"deckRoundedTo"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"deckRoundedTo")) as? String ?? defaults.deckRoundedTo
        }
    }
    var showDiscardedRemainingDecks: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"showDiscardedRemainingDecks"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"showDiscardedRemainingDecks")) as? Bool ?? defaults.showDiscardedRemainingDecks
        }
    }
    var roundLastThreeDecksToHalf: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"roundLastThreeDecksToHalf"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"roundLastThreeDecksToHalf")) as? Bool ?? defaults.roundLastThreeDecksToHalf
        }
    }
    
    
    struct Defaults {
        var dealSpeed: Float = 1.0
        var ENHC: Bool = false
        var numberOfDecks = 6
        var dealerHitsSoft17 = true
        var surrender = false
        var resplitAces = false
        var doubleAfterSplit = true
        var notifyMistakes = true
        var showHandTotal = false
        var showDiscardTray = true
        var deviations = false
        var numberOfRoundsBeforeAskRunningCount = CountRounds.oneRound.rawValue
        var numberOfRoundsBeforeAskTrueCount = CountRounds.onceAtEnd.rawValue
        var tableColor = #colorLiteral(red: 0.1647058824, green: 0.3176470588, blue: 0.2431372549, alpha: 1) //https://encycolorpedia.com/35654d
        var buttonColor = #colorLiteral(red: 0, green: 0.5655595064, blue: 0.457355082, alpha: 1)
        var cardSizeFactor: CGFloat = 1//150.0
        
        var deckFraction: String = DeckFraction.quarters.rawValue
        var deckRoundedTo: String = DeckRoundedTo.whole.rawValue
        var showDiscardedRemainingDecks = false
        var roundLastThreeDecksToHalf = false
        var bankRollAmount = 10000.00
        var previousBetAmount = 0
        var placeBets = false
        
        var twoCardHands = true
        var threeCardHands = true
        var fourCardHands = false
    }
    
    private func getKey(for setting: String) -> String {
        return String("\(gameType.rawValue)_\(setting)")
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
}

//enum HandType: String {
//    case twoCardHand = "2 card hand",
//         threeFourCardHand = "3 and 4 card hand",
//         twoThreeFourCardHand = "2, 3 and 4 card hand"
//    
//}

enum DeckFraction: String {
    case wholes,
         halves,
         thirds,
         quarters
    
}

enum DeckRoundedTo: String {
    case whole, half
}
