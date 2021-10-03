//
//  Chart.swift
//  PrettyExample
//
//  Created by JON on 6/19/21.
//  Copyright © 2021 nlampi. All rights reserved.
//

import Foundation
import UIKit
import OrderedCollections

protocol ChartProtocol: RowCellObserver {
    //var numberOfRows: Int { get }
    //var numberOfColumns: Int { get }
    var headers: [String] { get }
    var data: [[String]] { get set }
    var cellConfig: OrderedDictionary<String, UIColor> { get }
    var isQuiz: Bool { get }
    func rowCell(_ rowCell: PrettyRowCell, didChange text: String)
    func copy() -> ChartProtocol
}

extension ChartProtocol {
    var headers: [String] {
        return ["", "2", "3", "4", "5", "6", "7", "8", "9", "10", "A"]
    }
    
    var isQuiz: Bool {
        return false
    }
    
    func rowCell(_ rowCell: PrettyRowCell, didChange text: String) {
        data[rowCell.indexPath.sgRow][rowCell.indexPath.sgColumn] = text
    }
}

protocol QuizProtocol {
    func compare() -> Bool
}



