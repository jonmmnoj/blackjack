//
//  Bankroll.swift
//  BlackJackPracticeStrategyGame
//
//  Created by Jon on 11/6/21.
//

import Foundation

class Bankroll {
    static let shared = Bankroll()
    private init() {}
    
    var amount: Double {
        get {
            return Settings.shared.bankRollAmount
        } set {
            Settings.shared.bankRollAmount = newValue
        }
    }
    
    func add(_ amount: Double) {
        Settings.shared.bankRollAmount += amount
        //if amount > 0 || amount < 0 {
            //SoundPlayer.shared.playSound(type: .chips)
        //}
    }
}
