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
    
    var gameType: GameType!
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
    
    var cardSizeFactor: Float {
        set {
            UserDefaults.standard.set(newValue, forKey: "cardSizeFactor")
        }
        get {
            
            return UserDefaults.standard.object(forKey: "cardSizeFactor") as? Float ?? defaults.cardSizeFactor
        }
    }
    var cardSize: CGFloat {
        get {
            //let size = UserDefaults.standard.object(forKey: getKey(for: "cardSize")) as? Float ?? defaults.cardSizeFactor * 2
            
            let size = cardSizeFactor / 5
            let adjustmentForScreenSize = round(CGFloat(size) * (UIScreen.main.bounds.height / 6))//5.5))
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
    var quickFeedback: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"quickFeedback"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"quickFeedback")) as? Bool ?? defaults.quickFeedback
        }
    }
    var penetration: Double {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"penetration"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"penetration")) as? Double ?? defaults.penetration
        }
    }
    var betSpread: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"betSpread"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"betSpread")) as? Bool ?? defaults.betSpread
        }
    }
    var betSpreadNeg3: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"betSpreadNeg3"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"betSpreadNeg3")) as? Int ?? defaults.betSpreadNeg3
        }
    }
    var betSpreadNeg2: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"betSpreadNeg2"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"betSpreadNeg2")) as? Int ?? defaults.betSpreadNeg2
        }
    }
    var betSpreadNeg1: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"betSpreadNeg1"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"betSpreadNeg1")) as? Int ?? defaults.betSpreadNeg1
        }
    }
    var betSpreadZero: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"betSpreadZero"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"betSpreadZero")) as? Int ?? defaults.betSpreadZero
        }
    }
    var betSpreadPos1: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"betSpreadPos1"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"betSpreadPos1")) as? Int ?? defaults.betSpreadPos1
        }
    }
    var betSpreadPos2: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"betSpreadPos2"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"betSpreadPos2")) as? Int ?? defaults.betSpreadPos2
        }
    }
    var betSpreadPos3: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"betSpreadPos3"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"betSpreadPos3")) as? Int ?? defaults.betSpreadPos3
        }
    }
    var betSpreadPos4: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"betSpreadPos4"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"betSpreadPos4")) as? Int ?? defaults.betSpreadPos4
        }
    }
    var betSpreadPos5: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"betSpreadPos5"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"betSpreadPos5")) as? Int ?? defaults.betSpreadPos5
        }
    }
    var betSpreadPos6: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"betSpreadPos6"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"betSpreadPos6")) as? Int ?? defaults.betSpreadPos6
        }
    }
    var betSpreadPos7: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"betSpreadPos7"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"betSpreadPos7")) as? Int ?? defaults.betSpreadPos7
        }
    }
    var tableColor: String {
        set {
            UserDefaults.standard.set(newValue, forKey: "tableColor")
        }
        get {
            return UserDefaults.standard.object(forKey: "tableColor") as? String ?? defaults.tableColor.rawValue
        }
    }
    var buttonColor: String {
        set {
            UserDefaults.standard.set(newValue, forKey: "buttonColor")
        }
        get {
            return UserDefaults.standard.object(forKey: "buttonColor") as? String ?? defaults.buttonColor.rawValue
        }
    }
    var cardColor: String {
        set {
            UserDefaults.standard.set(newValue, forKey: "cardColor")
        }
        get {
            return UserDefaults.standard.object(forKey: "cardColor") as? String ?? defaults.cardColor.rawValue
        }
    }
    var maxRunningCount: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"maxRunningCount"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"maxRunningCount")) as? Int ?? defaults.maxRunningCount
        }
    }
    
    struct Defaults {
        var dealSpeed: Float = 7.5
        var ENHC: Bool = false
        var numberOfDecks = 6
        var dealerHitsSoft17 = true
        var surrender = true
        var resplitAces = false
        var doubleAfterSplit = true
        var notifyMistakes = true
        var showHandTotal = false
        var showDiscardTray = true
        var deviations: Bool {
            if Settings.shared.gameType == .basicStrategy {
                return false
            }
            return true
        }
        var numberOfRoundsBeforeAskRunningCount = CountRounds.oneRound.rawValue
        var numberOfRoundsBeforeAskTrueCount = CountRounds.onceAtEnd.rawValue
        //var tableColor = TableColor.green.tableCode//#colorLiteral(red: 0.1647058824, green: 0.3176470588, blue: 0.2431372549, alpha: 1) //https://encycolorpedia.com/35654d
        //var buttonColor = TableColor.green.buttonCode//#colorLiteral(red: 0, green: 0.5655595064, blue: 0.457355082, alpha: 1)
        //var tc = #colorLiteral(red: 0.1647058824, green: 0.3176470588, blue: 0.2431372549, alpha: 1) //https://encycolorpedia.com/35654d
        //var bc = #colorLiteral(red: 0, green: 0.5655595064, blue: 0.457355082, alpha: 1)
        var cardSizeFactor: Float = 5//150.0 0 to 10
        
        var deckFraction: String = DeckFraction.quarters.rawValue
        var deckRoundedTo: String = DeckRoundedTo.whole.rawValue
        var showDiscardedRemainingDecks = false
        var roundLastThreeDecksToHalf = false
        var bankRollAmount = 10000.00
        var previousBetAmount = 0
        var placeBets = true
        
        var twoCardHands = true
        var threeCardHands = true
        var fourCardHands = false
        
        var quickFeedback = false
        var penetration: Double = 0.75
        
        var betSpread = false
        var betSpreadNeg3: Int = 25
        var betSpreadNeg2: Int = 25
        var betSpreadNeg1: Int = 25
        var betSpreadZero: Int = 25
        var betSpreadPos1: Int = 200
        var betSpreadPos2: Int = 300
        var betSpreadPos3: Int = 500
        var betSpreadPos4: Int = 1000
        var betSpreadPos5: Int = 1500
        var betSpreadPos6: Int = 2000
        var betSpreadPos7: Int = 2500
        
        var tableColor = TableColor.Green
        var buttonColor = TableColor.Green
        var cardColor = CardColor.Red
        
        var maxRunningCount: Int = 30
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
        return 5 / dealSpeed
    }
    
    
}




