//
//  Dealable.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/6/21.
//

import Foundation

protocol Dealable {
    var activatedHand: Hand? { get set }
    var hands: [Hand] { get set }
    func searchForIncompleteHand()
    var isDealer: Bool { get set }
    func index(of hand: Hand) -> Int?
}

extension Dealable {
    func searchForIncompleteHand() {
        
    }
    
    func index(of hand: Hand) -> Int? {
        return nil
    }
}
