////
////  Deviation.swift
////  BlackJackPracticeStrategyGame
////
////  Created by JON on 7/19/21.
////
//
//import Foundation
//
//class Surrender {
//    var isSurrender: Bool
//    var deviation: Deviation?
//}
//
//
//class Deviation {
//    var count: Int
//    var direction: String
//    var action: StrategyAction
//    
//    init(count: Int, direction: String, action: StrategyAction) {
//        self.count = count
//        self.direction = direction
//        self.action = action
//    }
//    
//    func doesApply() -> Bool {
//        // get true/running count and compare to self.count
//        return false
//    }
//    func getSign() -> String {
//        return direction
//    }
//    func getCount() -> Int {
//        return count
//    }
//    
//    func getAction(numberOfPlayerCards num: Int) -> StrategyAction {
//        if self.action == .doubleStand {
//            if num > 2 {
//                return .stand
//            } else {
//                return .double
//            }
//        }
//        return self.action
//    }
//}
