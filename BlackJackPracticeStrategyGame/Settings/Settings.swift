//
//  Settings.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/13/21.
//

import Foundation
import UIKit

class Settings {
    
    func resetSpotAssignments() {
        Settings.shared.spotOneAssignment = Settings.shared.defaults.spotOneAssignment
        Settings.shared.spotTwoAssignment = Settings.shared.defaults.spotTwoAssignment
        Settings.shared.spotThreeAssignment = Settings.shared.defaults.spotThreeAssignment
        Settings.shared.spotFourAssignment = Settings.shared.defaults.spotFourAssignment
        Settings.shared.spotFiveAssignment = Settings.shared.defaults.spotFiveAssignment
        Settings.shared.spotSixAssignment = Settings.shared.defaults.spotSixAssignment
        Settings.shared.spotSevenAssignment = Settings.shared.defaults.spotSevenAssignment
    }
    
    var numberOfSpotsAssigned: Int {
        var count = 0
        for spot in spotAssignments {
            if spot != .empty {
                count += 1
            }
        }
        return count
    }
    var spotAssignments: [SpotAssignment] {
        if Settings.shared.deviceType == .phone {
            return [SpotAssignment(rawValue: Settings.shared.spotOneAssignment)!, SpotAssignment(rawValue: Settings.shared.spotTwoAssignment)!, SpotAssignment(rawValue: Settings.shared.spotThreeAssignment)!, SpotAssignment(rawValue: Settings.shared.spotFourAssignment)!, SpotAssignment(rawValue: Settings.shared.spotFiveAssignment)!]
        }
        
        return [SpotAssignment(rawValue: Settings.shared.spotOneAssignment)!, SpotAssignment(rawValue: Settings.shared.spotTwoAssignment)!, SpotAssignment(rawValue: Settings.shared.spotThreeAssignment)!, SpotAssignment(rawValue: Settings.shared.spotFourAssignment)!, SpotAssignment(rawValue: Settings.shared.spotFiveAssignment)!, SpotAssignment(rawValue: Settings.shared.spotSixAssignment)!, SpotAssignment(rawValue: Settings.shared.spotSevenAssignment)!]
        
    }
    
    static let shared = Settings()
    private init() {}
    
    var deviceType: UIUserInterfaceIdiom {
        return UIScreen.main.traitCollection.userInterfaceIdiom
    }
    
    var landscape: Bool {
        //let orientation = //UIDevice.current.orientation
        let games: [GameType] = [.freePlay, .runningCount]
        let value = UIApplication.shared.statusBarOrientation.isLandscape && games.contains(gameType)
        return value
    }
    var verticalSizeClass: UIUserInterfaceSizeClass {
        return UIScreen.main.traitCollection.verticalSizeClass
    }
    var horizontalSizeClass: UIUserInterfaceSizeClass {
        return UIScreen.main.traitCollection.horizontalSizeClass
    }
    //var gameType: GameType!
    var gameType: GameType {
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "gameType")
        }
        get {
            let rawValue = UserDefaults.standard.object(forKey: "gameType") as? String
            if let rawValue = rawValue {
                return GameType(rawValue: rawValue)!
            } else {
                return defaults.gameType
            }
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
    
    var cardSizeFactor: Float {
        set {
            UserDefaults.standard.set(newValue, forKey: "cardSizeFactor")
        }
        get {
            
            return UserDefaults.standard.object(forKey: "cardSizeFactor") as? Float ?? defaults.cardSizeFactor
        }
    }
    var cardHeight: CGFloat {
        get {
            //let size = UserDefaults.standard.object(forKey: getKey(for: "cardSize")) as? Float ?? defaults.cardSizeFactor * 2
            //print(cardSizeFactor)
            
            let size = cardSizeFactor / 5
            var adjustmentForScreenSize = round(CGFloat(size) * (UIScreen.main.bounds.height / 5))//6//5.5))
            if Settings.shared.landscape {
                adjustmentForScreenSize = round(CGFloat(size) * (UIScreen.main.bounds.width / 7))
            }
            return adjustmentForScreenSize
        }
    }
    
    var cardWidth: CGFloat {
        get {
            return (cardHeight * 0.708).rounded()
        }
    }
    
    var dealSpeed: Float {
        set {
            UserDefaults.standard.set(newValue, forKey: "dealSpeed")//getKey(for: "dealSpeed"))
        }
        get {
            
            return UserDefaults.standard.object(forKey: "dealSpeed") as? Float ?? defaults.dealSpeed
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
            UserDefaults.standard.set(newValue, forKey: "showHandTotal")
        }
        get {
            return UserDefaults.standard.object(forKey: "showHandTotal") as? Bool ?? defaults.showHandTotal
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
    var useGestures: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "useGestures")
        }
        get {
            return UserDefaults.standard.object(forKey: "useGestures") as? Bool ?? defaults.useGestures
        }
    }
    var useButtons: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "useButtons")
        }
        get {
            return UserDefaults.standard.object(forKey: "useButtons") as? Bool ?? defaults.useButtons
        }
    }
    var buttonsOnLeft: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "buttonsOnLeft")
        }
        get {
            return UserDefaults.standard.object(forKey: "buttonsOnLeft") as? Bool ?? defaults.buttonsOnLeft
        }
    }
    var rcNumberOfPiles: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"rcNumberOfPiles"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"rcNumberOfPiles")) as? Int ?? defaults.rcNumberOfPiles
        }
    }
    var rcNumberOfCards: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"rcNumberOfCards"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"rcNumberOfCards")) as? Int ?? defaults.rcNumberOfCards
        }
    }
    
    var feedbackWhenWrong: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"feedbackWhenWrong"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"feedbackWhenWrong")) as? Bool ?? defaults.feedbackWhenWrong
        }
    }
    var highRunningCountBias: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "highRunningCountBias")
        }
        get {
            return UserDefaults.standard.object(forKey: "highRunningCountBias") as? Bool ?? defaults.highRunningCountBias
        }
    }
    var cardsAskew: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "cardsAskew")
        }
        get {
            return UserDefaults.standard.object(forKey: "cardsAskew") as? Bool ?? defaults.cardsAskew
        }
    }
    var rcDealInPairs: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "rcDealInPairs")
        }
        get {
            return UserDefaults.standard.object(forKey: "rcDealInPairs") as? Bool ?? defaults.rcDealInPairs
        }
    }
    var rcNumberOfStacks: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: "rcNumberOfStacks")
        }
        get {
            return UserDefaults.standard.object(forKey: "rcNumberOfStacks") as? Int ?? defaults.rcNumberOfStacks
        }
    }
    var ghostHand: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "ghostHand")
        }
        get {
            return UserDefaults.standard.object(forKey: "ghostHand") as? Bool ?? defaults.ghostHand
        }
    }
    var dealDoubleFaceDown: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "dealDoubleFaceDown")
        }
        get {
            return UserDefaults.standard.object(forKey: "dealDoubleFaceDown") as? Bool ?? defaults.dealDoubleFaceDown
        }
    }
    var countBias: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "countBias")
        }
        get {
            return UserDefaults.standard.object(forKey: "countBias") as? Bool ?? defaults.countBias
        }
    }
    var soundOn: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "soundOn")
        }
        get {
            return UserDefaults.standard.object(forKey: "soundOn") as? Bool ?? defaults.soundOn
        }
    }
    var spotOneAssignment: String {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"spotOneAssignment"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"spotOneAssignment")) as? String ?? defaults.spotOneAssignment
        }
    }
    var spotTwoAssignment: String {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"spotTwoAssignment"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"spotTwoAssignment")) as? String ?? defaults.spotTwoAssignment
        }
    }
    var spotThreeAssignment: String {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"spotThreeAssignment"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"spotThreeAssignment")) as? String ?? defaults.spotThreeAssignment
        }
    }
    var spotFourAssignment: String {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"spotFourAssignment"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"spotFourAssignment")) as? String ?? defaults.spotFourAssignment
        }
    }
    var spotFiveAssignment: String {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"spotFiveAssignment"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"spotFiveAssignment")) as? String ?? defaults.spotFiveAssignment
        }
    }
    var spotSixAssignment: String {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"spotSixAssignment"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"spotSixAssignment")) as? String ?? defaults.spotSixAssignment
        }
    }
    var spotSevenAssignment: String {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"spotSevenAssignment"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"spotSevenAssignment")) as? String ?? defaults.spotSevenAssignment
        }
    }
    var rcNumberOfSpots: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: "rcNumberOfSpots")
        }
        get {
            return UserDefaults.standard.object(forKey: "rcNumberOfSpots") as? Int ?? defaults.rcNumberOfSpots
        }
    }
    var tableOrientation: String {
        set {
            UserDefaults.standard.set(newValue, forKey: getKey(for:"tableOrientation"))
        }
        get {
            return UserDefaults.standard.object(forKey: getKey(for:"tableOrientation")) as? String ?? defaults.tableOrientation
        }
    }
    var showGestureView: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "showGestureView")
        }
        get {
            return UserDefaults.standard.object(forKey: "showGestureView") as? Bool ?? defaults.showGestureView
        }
    }
    
    var showScalingAlert: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "showScalingAlert")
        }
        get {
            return UserDefaults.standard.object(forKey: "showScalingAlert") as? Bool ?? defaults.showScalingAlert
        }
    }
    
    
    struct Defaults {
        var showScalingAlert = true
        var showGestureView = true
        var dealSpeed: Float = 6.5
        var ENHC: Bool = false
        var numberOfDecks = 6
        var dealerHitsSoft17 = true
        var surrender = false
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
        var cardSizeFactor: Float = UIDevice.current.userInterfaceIdiom == .pad ? 5.5 : 5 //4.5 (-5) to 5.5 (+5)
        
        var deckFraction: String = DeckFraction.quarters.rawValue
        var deckRoundedTo: String = DeckRoundedTo.whole.rawValue
        var showDiscardedRemainingDecks = false
        var roundLastThreeDecksToHalf = false
        var bankRollAmount = 100000.00
        var previousBetAmount = 0
        var placeBets = true
        
        var twoCardHands = true
        var threeCardHands = true
        var fourCardHands = false
        
        var quickFeedback = false
        var penetration: Double = 0.75
        
        var betSpread = false
        //var betSpreadNeg3: Int = 25
        var betSpreadNeg2: Int = 25
        var betSpreadNeg1: Int = 25
        var betSpreadZero: Int = 25
        var betSpreadPos1: Int = 100
        var betSpreadPos2: Int = 200
        var betSpreadPos3: Int = 300
        var betSpreadPos4: Int = 400
        var betSpreadPos5: Int = 500
        var betSpreadPos6: Int = 600
        //var betSpreadPos7: Int = 2500
        
        var tableColor = TableColor.Green
        var buttonColor = TableColor.Green2
        var cardColor = CardColor.Red
        
        var maxRunningCount: Int = 30
        
        var useGestures = true
        var useButtons = false
        var buttonsOnLeft = false
        var rcNumberOfPiles = 1
        var rcNumberOfCards = 52
        var highRunningCountBias = false
        var rcDealInPairs = false
        var rcNumberOfStacks = 1
        
        var cardsAskew = false
        var ghostHand = false
        var dealDoubleFaceDown = false
        var gameType = GameType.freePlay
        var countBias = false
        var soundOn = true
        var feedbackWhenWrong = false
        
        var spotOneAssignment = SpotAssignment.empty.rawValue
        var spotTwoAssignment = SpotAssignment.empty.rawValue
        var spotThreeAssignment = SpotAssignment.empty.rawValue
        var spotFourAssignment = SpotAssignment.playerActive.rawValue
        var spotFiveAssignment = SpotAssignment.empty.rawValue
        var spotSixAssignment = SpotAssignment.empty.rawValue
        var spotSevenAssignment = SpotAssignment.empty.rawValue
        var rcNumberOfSpots = 1
        var tableOrientation = TableOrientation.portrait.rawValue
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
    
    static var dealSpeedFactor: Double {
        var dealSpeed = self.shared.dealSpeed
        if dealSpeed == 0 { dealSpeed = 0.1 }
        return 5.0 / Double(dealSpeed)
    }
    
    
}




