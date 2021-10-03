//
//  Charts.swift
//  PrettyExample
//
//  Created by JON on 6/20/21.

import Foundation
import UIKit
import OrderedCollections

class PairSplittingChart: ChartProtocol {
    var data = [["A,A","Y","Y","Y","Y","Y","Y","Y","Y","Y","Y"],
                ["10,10","N","N","N","N","N","N","N","N","N","N"],
                ["9,9","Y","Y","Y","Y","Y","N","Y","Y","N","N"],
                ["8,8","Y","Y","Y","Y","Y","Y","Y","Y","Y","Y"],
                ["7,7","Y","Y","Y","Y","Y","Y","N","N","N","N"],
                ["6,6","Y/N","Y","Y","Y","Y","N","N","N","N","N"],
                ["5,5","N","N","N","N","N","N","N","N","N","N"],
                ["4,4","N","N","N","Y/N","Y/N","N","N","N","N","N"],
                ["3,3","Y/N","Y/N","Y","Y","Y","Y","N","N","N","N"],
                ["2,2","Y/N","Y/N","Y","Y","Y","Y","N","N","N","N"]]
    
    var cellConfig: OrderedDictionary<String, UIColor> = ["": UIColor.white,
                                                          "Y": UIColor.green,
                                                          "N": UIColor.white,
                                                          "Y/N": UIColor.blue]
    
    func copy() -> ChartProtocol {
        let copy = PairSplittingChart()
        return copy
    }
    
   
}

class SoftTotalsChart: ChartProtocol {
    var data = [["A,9","S","S","S","S","S","S","S","S","S","S"],
                ["A,8","S","S","S","S","Ds","S","S","S","S","S"],
                ["A,7","Ds","Ds","Ds","Ds","Ds","S","S","H","H","H"],
                ["A,6","H","D","D","D","D","H","H","H","H","H"],
                ["A,5","H","H","D","D","D","H","H","H","H","H"],
                ["A,4","H","H","D","D","D","H","H","H","H","H"],
                ["A,3","H","H","H","D","D","H","H","H","H","H"],
                ["A,2","H","H","H","D","D","H","H","H","H","H"]]
    
    var cellConfig: OrderedDictionary<String, UIColor> = ["": UIColor.white,
                                                          "H": UIColor.white,
                                                          "S": UIColor.yellow,
                                                          "D": UIColor.green,
                                                          "Ds": UIColor.blue]
    
    func copy() -> ChartProtocol {
        let copy = SoftTotalsChart()
        return copy
    }
}

class HardTotalsChart: ChartProtocol {
    var data = [["17","S","S","S","S","S","S","S","S","S","S"],
                ["16","S","S","S","S","S","H","H","H","H","H"],
                ["15","S","S","S","S","S","H","H","H","H","H"],
                ["14","S","S","S","S","S","H","H","H","H","H"],
                ["13","S","S","S","S","S","H","H","H","H","H"],
                ["12","H","H","S","S","S","H","H","H","H","H"],
                ["11","D","D","D","D","D","D","D","D","D","D"],
                ["10","D","D","D","D","D","D","D","D","H","H"],
                ["9","H","D","D","D","D","H","H","H","H","H"],
                ["8","H","H","H","H","H","H","H","H","H","H"]]
    
    var cellConfig: OrderedDictionary<String, UIColor> = ["": UIColor.white,
                                                          "H": UIColor.white,
                                                          "S": UIColor.yellow,
                                                          "D": UIColor.green]
    
    func copy() -> ChartProtocol {
        let copy = HardTotalsChart()
        return copy
    }
}

class SurrenderChart: ChartProtocol {
    
    var data = [["16","","","","","","","","SUR","SUR","SUR"],
                ["15","","","","","","","","","SUR",""],
                ["14","","","","","" ,"","","","",""]]
    
    var cellConfig: OrderedDictionary<String, UIColor> = ["": UIColor.white,
                                                          "SUR": UIColor.green]

    func copy() -> ChartProtocol {
        let copy = SurrenderChart()
        return copy
    }

}

