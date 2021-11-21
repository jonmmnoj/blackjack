//
//  Surrender.swift
//  BlackJackPracticeStrategyGame
//
//  Created by Jon on 11/14/21.
//

class Surrender {
    var isSurrender: Bool
    var deviations: [Deviation]?
    
    init(_ isSurrender: Bool, deviations: [Deviation]? = nil) {
        self.isSurrender = isSurrender
        self.deviations = deviations
    }
    
    func getDeviation() -> Deviation? {
        var deviation: Deviation?
        deviation = self.deviations?.first(where: { $0.type == Deviation.getType() })
        return deviation
    }
}
