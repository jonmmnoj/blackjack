//
//  QuickFeedback.swift
//  BlackJackPracticeStrategyGame
//
//  Created by Jon on 11/7/21.
//

class QuickFeedback {
    static func result(_ result: Bool, delegate: GameViewDelegate, moreMessage: String? = nil) {
        var message = result ? "✅" : "❌"
        if moreMessage != nil && result == false {
            message += " Correct answer: " + moreMessage!
        }
        delegate.showToast(message: message, for: nil)
    }
}
