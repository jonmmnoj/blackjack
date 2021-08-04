//
//  GameViewDelegate.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/16/21.
//
import UIKit

protocol GameViewDelegate {
    func playerInput(enabled: Bool)
    func presentCountInputView(countMaster: CountMaster, callback: (Int) -> Void)
    func dismissViewController(completion: (() -> Void)?)
    func presentBasicStrategyFeedbackView(playerAction: PlayerAction, correctAction: PlayerAction)
    func alertMistake(message: String, completion: @escaping ((Bool) -> Void))
    func presentViewController(_: UIViewController)
}
