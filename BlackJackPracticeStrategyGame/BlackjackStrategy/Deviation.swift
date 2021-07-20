//
//  Deviation.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/19/21.
//

import Foundation


class Deviation {
    var count: String
    var action: StrategyAction
    
    init(count: String, action: StrategyAction) {
        self.count = count
        self.action = action
    }
    
    func doesApply() -> Bool {
        // get true/running count and compare to self.count
        return false
    }
}
