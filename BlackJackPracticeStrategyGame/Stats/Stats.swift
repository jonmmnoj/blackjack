//
//  Stats.swift
//  BlackJackPracticeStrategyGame
//
//  Created by Jon on 12/2/21.
//

import UIKit

class Session {
    var gameType: GameType
    var decisions: [Decision] = []
    var decisionCount = 0
    var decisionCorrect = 0
    var bankRollAtStart: Double
    var numberOfMistakes: Int {
        return countingsMistake + basicStrategyMistake + deviationMistake + betSpreadMistake + insuranceMistake
    }
    var countingsMistake = 0
    var basicStrategyMistake = 0
    var deviationMistake = 0
    var insuranceMistake = 0
    var betSpreadMistake = 0
    
    init(gameType: GameType) {
        self.gameType = gameType
        self.bankRollAtStart = Settings.shared.bankRollAmount
    }
    
    func add(decision: Decision) {
        decisionCount += 1
        decisions.append(decision)
        if decision.isCorrect {
            decisionCorrect += 1
        } else {
            updateMistakeCount(type: decision.type)
        }
    }
    
    private func updateMistakeCount(type: DecisionType) {
        switch type {
        case .runningCount, .trueCount:
            countingsMistake += 1
        case .basicStrategy:
            basicStrategyMistake += 1
        case .deviation:
            deviationMistake += 1
        case .betSpread:
            betSpreadMistake += 1
        case .insurance:
            insuranceMistake += 1
        }
    }
    
    func getLabelString() -> String {
        var s = ""
        s += "Summary"
        let bankRollChange = Settings.shared.bankRollAmount - bankRollAtStart
        s += "\nbankroll change: \(bankRollChange)"
        s += "\ndecisions: \(decisionCount), decision correct: \(decisionCorrect), % correct: \(Double(decisionCorrect)/Double(decisionCount))%"
        s += "\nMistakes: \(numberOfMistakes)"
        s += "\nCounting mistakes: \(countingsMistake)"
        s += "\nBasic strategy mistakes: \(basicStrategyMistake)"
        s += "\nDeviation mistakes: \(deviationMistake)"
        s += "\nBetting mistakes: \(betSpreadMistake)"
        s += "\nInsurance mistakes: \(insuranceMistake)"
        s += "\nDecisions"
        for d in decisions {
            d.info()
            s += d.getLabelString()
        }
        return s
    }
    
    func printSessionStats() {
        
        print("Summary")
        let bankRollChange = Settings.shared.bankRollAmount - bankRollAtStart
        print("\nbankroll change: \(bankRollChange)")
        print("\ndecisions: \(decisionCount), decision correct: \(decisionCorrect), % correct: \(Double(decisionCorrect)/Double(decisionCount))%")
        print("\nMistakes: \(numberOfMistakes)")
        print("\nCounting mistakes: \(countingsMistake)")
        print("\nBasic strategy mistakes: \(basicStrategyMistake)")
        print("\nDeviation mistakes: \(deviationMistake)")
        print("\nBetting mistakes: \(betSpreadMistake)")
        print("\nInsurance mistakes: \(insuranceMistake)")
        print("\nDecisions")
        for d in decisions {
            d.info()
        }
    }
}

class Decision {
    var type: DecisionType
    var isCorrect: Bool
    var yourAnswer: String
    var correctAnswer: String
    var decisionBasedOn: String?
    
    init(type: DecisionType, isCorrect: Bool, yourAnswer: String, correctAnswer: String, decisionBasedOn: String?) { self.type = type
        self.isCorrect = isCorrect
        self.yourAnswer = yourAnswer
        self.correctAnswer = correctAnswer
        self.decisionBasedOn = decisionBasedOn
    }
    
    func info() {
        print("\ntype: \(type), \(isCorrect) \(decisionBasedOn ?? ""), your answer: \(yourAnswer) correct answer: \(correctAnswer)")
    }
    
    func getLabelString() -> String {
        return "\ntype: \(type), \(isCorrect) \(decisionBasedOn ?? ""), your answer: \(yourAnswer) correct answer: \(correctAnswer)"
    }
}

class Stats {
    static let shared = Stats()
    private init() {}
    var session: Session?
    var statsData = StatsData.shared
    
    func update(decision: Decision) {
        if session == nil {
            session = Session(gameType: Settings.shared.gameType)
        }
        session!.add(decision: decision)
        statsData.decisions.append(decision)
    }
    
    func printSessionStats() {
        session?.printSessionStats()
        session = nil
    }
    
    func printStatsData() {
        for d in statsData.decisions {
            d.info()
        }
    }
    
    
    func showStatsView() -> UIViewController {
        let vc = UIViewController()
        let label = UILabel()
        label.frame = CGRect(x: 10, y: 10, width: 500, height: 1000)
        label.backgroundColor = .blue
        //label.lineBreakMode = .byWordWrapping
        //label.text = "Hello"//session?.getLabelString()
        label.text = session?.getLabelString()
        //p label.numberOfLines = 0
        
       // label.sizeToFit()
        vc.view.addSubview(label)
        vc.view.backgroundColor = .green
        return vc
    }
}

class StatsData {
    static let shared = StatsData()
    private init() {}
    var decisions: [Decision] = []
    
    class DataContainer {
        
    }
}

enum DecisionType {
    case basicStrategy, deviation, betSpread, runningCount, trueCount, insurance
}
