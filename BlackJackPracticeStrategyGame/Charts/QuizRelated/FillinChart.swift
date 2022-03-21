//
//  FillinChart.swift
//  PrettyExample
//
//  Created by JON on 6/20/21.
//  Copyright © 2021 nlampi. All rights reserved.
//

//import Foundation
//import UIKit
//import OrderedCollections
//
//class FillInChart: ChartProtocol, QuizProtocol {
//    var quizArray: [[String]] = [[]]
//    private var chartModel: ChartProtocol!
//    var data: [[String]]
//    var cellConfig: OrderedDictionary<String, UIColor>
//    var deviationConfig: OrderedDictionary<String, UIColor>?
//    var isQuiz: Bool {
//        return true
//    }
//    
//    init(chartModel chart: ChartProtocol) {
//        self.chartModel = chart
//        cellConfig = chart.cellConfig
//        deviationConfig = chart.deviationConfig
//        let rows = chart.data.count
//        let columns = chart.data[0].count
//        data = Array(repeating: Array(repeating: "", count: columns), count: rows)
//        
//        // Copy first column
//        for (index, row) in chart.data.enumerated() {
//            let s = row[0]
//            data[index][0] = s
//        }
//    }
//    
//    func compare() -> Bool {
//        return chartModel.data == self.data
//    }
//    
//    func copy() -> ChartProtocol {
//        return FillInChart(chartModel: chartModel)
//    }
//}
