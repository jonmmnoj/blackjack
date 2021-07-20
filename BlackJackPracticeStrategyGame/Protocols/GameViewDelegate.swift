//
//  GameViewDelegate.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/16/21.
//

import Foundation

protocol GameViewDelegate {
    func playerInput(enabled: Bool)
    func presentCountInputView(countMaster: CountMaster, callback: (Int) -> Void)
    func dismissCountInputView(completion: () -> Void)
}
