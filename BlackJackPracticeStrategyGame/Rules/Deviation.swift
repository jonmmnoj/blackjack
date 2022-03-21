////
////  Deviation.swift
////  BlackJackPracticeStrategyGame
////
////  Created by JON on 7/19/21.
////

class Deviation {
    
    var type: DeviationType
    var count: Int?
    var direction: String?
    var action: PlayerAction
    
    init(type: DeviationType, count: Int?, direction: String?, action: PlayerAction) {
        self.type = type
        self.count = count
        self.direction = direction
        self.action = action
    }
    
    func doesApply() -> Bool {
        // get true/running count and compare to self.count
        return false
    }
    func getSign() -> String? {
        return direction
    }
    func getCount() -> Int? {
        return count
    }
    
    func getAction(numberOfPlayerCards num: Int) -> PlayerAction {
        if self.action == .doubleStand {
            if num > 2 {
                return .stand
            } else {
                return .double
            }
        }
        if self.action == .doubleHit {
            if num > 2 {
                return .hit
            } else {
                return .double
            }
        }
        return self.action
    }
    
    static func getType() -> DeviationType {
        let dealerHitsSoft17 = Settings.shared.dealerHitsSoft17
        //let enhc = Settings.shared.ENHC
        let type: DeviationType = dealerHitsSoft17 ? .hard17 : .soft17
        return type
    }
}

extension Deviation: Equatable {
    static func == (lhs: Deviation, rhs: Deviation) -> Bool {
        return
            lhs.type == rhs.type &&
            lhs.count == rhs.count &&
            lhs.direction == rhs.direction &&
            lhs.action == rhs.action
    }
}
