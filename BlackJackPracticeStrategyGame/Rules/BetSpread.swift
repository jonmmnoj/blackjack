//
//  BetSpread.swift
//  BlackJackPracticeStrategyGame
//
//  Created by Jon on 11/12/21.
//

class BetSpread {
    static let trueCounts = ["-3", "-2", "-1", "0", "1",  "2", "3", "4", "5", "6", "7"]
    
    static func setBet(amount: Int, for trueCount: Int) {
        switch trueCount {
            case -3: Settings.shared.betSpreadNeg3 = amount
            case -2: Settings.shared.betSpreadNeg2 = amount
            case -1: Settings.shared.betSpreadNeg1 = amount
            case 0: Settings.shared.betSpreadZero = amount
            case 1: Settings.shared.betSpreadPos1 = amount
            case 2: Settings.shared.betSpreadPos2 = amount
            case 3: Settings.shared.betSpreadPos3 = amount
            case 4: Settings.shared.betSpreadPos4 = amount
            case 5: Settings.shared.betSpreadPos5 = amount
            case 6: Settings.shared.betSpreadPos6 = amount
            case 7: Settings.shared.betSpreadPos7 = amount
            default: break
        }
    }
    
    static func getBetAmount(for trueCount: Int) -> Int {
        switch trueCount {
            case -3: return Settings.shared.betSpreadNeg3
            case -2: return Settings.shared.betSpreadNeg2
            case -1: return Settings.shared.betSpreadNeg1
            case 0: return Settings.shared.betSpreadZero
            case 1: return Settings.shared.betSpreadPos1
            case 2: return Settings.shared.betSpreadPos2
            case 3: return Settings.shared.betSpreadPos3
            case 4: return Settings.shared.betSpreadPos4
            case 5: return Settings.shared.betSpreadPos5
            case 6: return Settings.shared.betSpreadPos6
            case 7: return Settings.shared.betSpreadPos7
            default: return 0
        }
    }
}
