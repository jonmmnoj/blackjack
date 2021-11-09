//
//  QuickFeedback.swift
//  BlackJackPracticeStrategyGame
//
//  Created by Jon on 11/7/21.
//

class QuickFeedback {
    static func result(_ result: Bool, delegate: GameViewDelegate) {
        let message = result ? "✅" : "❌"
        delegate.showToast(message: message)
    }
}
