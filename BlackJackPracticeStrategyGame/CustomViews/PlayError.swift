//
//  PlayError.swift
//  BlackJackPracticeStrategyGame
//
//  Created by Jon on 11/11/21.
//

import UIKit

class PlayError {
    static func notifyMistake(_ delegate: GameViewDelegate, message: String, completion: @escaping (Bool) -> Void) {
            let alert = UIAlertController(title: "Strategy Mistake", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .destructive, handler: { _ in completion(false) }))
            alert.addAction(UIAlertAction(title: "Fix", style: .cancel, handler: { _ in completion(true) }))
            delegate.present(alert)
    }
    
    static func notifyMistake(presenter: UIViewController, message: String, completion: @escaping (Bool) -> Void) {
            let alert = UIAlertController(title: "Strategy Mistake", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .destructive, handler: { _ in completion(false) }))
            alert.addAction(UIAlertAction(title: "Fix", style: .cancel, handler: { _ in completion(true) }))
            presenter.present(alert, animated: true)
    }
}
