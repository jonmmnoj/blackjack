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
                                                          "Y": UIColor.green.withAlphaComponent(0.7),
                                                          "N": UIColor.white,
                                                          "Y/N": UIColor.blue.withAlphaComponent(0.6)]
    
    func copy() -> ChartProtocol {
        let copy = PairSplittingChart()
        return copy
    }
}

class H17PairSplittingChart: ChartProtocol {
    var data = [["A,A","Y","Y","Y","Y","Y","Y","Y","Y","Y","Y"],
                ["10,10","N","N","N6+","N5+","N4+","N","N","N","N","N"],
                ["9,9","Y","Y","Y","Y","Y","N","Y","Y","N","N"],
                ["8,8","Y","Y","Y","Y","Y","Y","Y","Y","Y","Y"],
                ["7,7","Y","Y","Y","Y","Y","Y","N","N","N","N"],
                ["6,6","Y/N","Y","Y","Y","Y","N","N","N","N","N"],
                ["5,5","N","N","N","N","N","N","N","N","N","N"],
                ["4,4","N","N","N","Y/N","Y/N","N","N","N","N","N"],
                ["3,3","Y/N","Y/N","Y","Y","Y","Y","N","N","N","N"],
                ["2,2","Y/N","Y/N","Y","Y","Y","Y","N","N","N","N"]]
    
    var cellConfig: OrderedDictionary<String, UIColor> = ["": UIColor.white,
                                                          "Y": UIColor.green.withAlphaComponent(0.7),
                                                          "N": UIColor.white,
                                                          "Y/N": UIColor.blue.withAlphaComponent(0.6)]
    
    func copy() -> ChartProtocol {
        let copy = H17PairSplittingChart()
        return copy
    }
}

class S17PairSplittingChart: ChartProtocol {
    var data = [["A,A","Y","Y","Y","Y","Y","Y","Y","Y","Y","Y"],
                ["10,10","N","N","N6+","N5+","N4+","N","N","N","N","N"],
                ["9,9","Y","Y","Y","Y","Y","N","Y","Y","N","N"],
                ["8,8","Y","Y","Y","Y","Y","Y","Y","Y","Y","Y"],
                ["7,7","Y","Y","Y","Y","Y","Y","N","N","N","N"],
                ["6,6","Y/N","Y","Y","Y","Y","N","N","N","N","N"],
                ["5,5","N","N","N","N","N","N","N","N","N","N"],
                ["4,4","N","N","N","Y/N","Y/N","N","N","N","N","N"],
                ["3,3","Y/N","Y/N","Y","Y","Y","Y","N","N","N","N"],
                ["2,2","Y/N","Y/N","Y","Y","Y","Y","N","N","N","N"]]
    
    var cellConfig: OrderedDictionary<String, UIColor> = ["": UIColor.white,
                                                          "Y": UIColor.green.withAlphaComponent(0.7),
                                                          "N": UIColor.white,
                                                          "Y/N": UIColor.blue.withAlphaComponent(0.6)]
    
    func copy() -> ChartProtocol {
        let copy = S17PairSplittingChart()
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
                                                          "S": UIColor.yellow.withAlphaComponent(0.7),
                                                          "D": UIColor.green.withAlphaComponent(0.7),
                                                          "Ds": UIColor.blue.withAlphaComponent(0.6)]
    
    func copy() -> ChartProtocol {
        let copy = SoftTotalsChart()
        return copy
    }
}

class H17SoftTotalsChart: ChartProtocol {
    var data = [["A,9","S","S","S","S","S","S","S","S","S","S"],
                ["A,8","S","S","S3+","S1+","Ds0-","S","S","S","S","S"],
                ["A,7","Ds","Ds","Ds","Ds","Ds","S","S","H","H","H"],
                ["A,6","H1+","D","D","D","D","H","H","H","H","H"],
                ["A,5","H","H","D","D","D","H","H","H","H","H"],
                ["A,4","H","H","D","D","D","H","H","H","H","H"],
                ["A,3","H","H","H","D","D","H","H","H","H","H"],
                ["A,2","H","H","H","D","D","H","H","H","H","H"]]
    
    var cellConfig: OrderedDictionary<String, UIColor> = ["": UIColor.white,
                                                          "H": UIColor.white,
                                                          "S": UIColor.yellow.withAlphaComponent(0.7),
                                                          "D": UIColor.green.withAlphaComponent(0.7),
                                                          "Ds": UIColor.blue.withAlphaComponent(0.6)]
    
    func copy() -> ChartProtocol {
        let copy = H17SoftTotalsChart()
        return copy
    }
}

class S17SoftTotalsChart: ChartProtocol {
    var data = [["A,9","S","S","S","S","S","S","S","S","S","S"],
                ["A,8","S","S","S3+","S1+","S1+","S","S","S","S","S"],
                ["A,7","Ds","Ds","Ds","Ds","Ds","S","S","H","H","H"],
                ["A,6","H1+","D","D","D","D","H","H","H","H","H"],
                ["A,5","H","H","D","D","D","H","H","H","H","H"],
                ["A,4","H","H","D","D","D","H","H","H","H","H"],
                ["A,3","H","H","H","D","D","H","H","H","H","H"],
                ["A,2","H","H","H","D","D","H","H","H","H","H"]]
    
    var cellConfig: OrderedDictionary<String, UIColor> = ["": UIColor.white,
                                                          "H": UIColor.white,
                                                          "S": UIColor.yellow.withAlphaComponent(0.7),
                                                          "D": UIColor.green.withAlphaComponent(0.7),
                                                          "Ds": UIColor.blue.withAlphaComponent(0.6)]
    
    func copy() -> ChartProtocol {
        let copy = S17SoftTotalsChart()
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
                                                          "S": UIColor.yellow.withAlphaComponent(0.7),
                                                          "D": UIColor.green.withAlphaComponent(0.7)]
    
    func copy() -> ChartProtocol {
        let copy = HardTotalsChart()
        return copy
    }
}

class H17HardTotalsChart: ChartProtocol {
    var data = [["17","S","S","S","S","S","S","S","S","S","S"],
                ["16","S","S","S","S","S","H","H","H4+","H0+","H3+"],
                ["15","S","S","S","S","S","H","H","H","H4+","H5+"],
                ["14","S","S","S","S","S","H","H","H","H","H"],
                ["13","S-1-","S","S","S","S","H","H","H","H","H"],
                ["12","H3+","H2+","S0-","S","S","H","H","H","H","H"],
                ["11","D","D","D","D","D","D","D","D","D","D"],
                ["10","D","D","D","D","D","D","D","D","H4+","H3+"],
                ["9","H1+","D","D","D","D","H3+","H","H","H","H"],
                ["8","H","H","H","H","H2+","H","H","H","H","H"]]
    
    var cellConfig: OrderedDictionary<String, UIColor> = ["": UIColor.white,
                                                          "H": UIColor.white,
                                                          "S": UIColor.yellow.withAlphaComponent(0.7),
                                                          "D": UIColor.green.withAlphaComponent(0.7)]
    
    func copy() -> ChartProtocol {
        let copy = H17HardTotalsChart()
        return copy
    }
}

class S17HardTotalsChart: ChartProtocol {
    var data = [["17","S","S","S","S","S","S","S","S","S","S"],
                ["16","S","S","S","S","S","H","H","H4+","H0+","H"],
                ["15","S","S","S","S","S","H","H","H","H4+","H"],
                ["14","S","S","S","S","S","H","H","H","H","H"],
                ["13","S-1-","S","S","S","S","H","H","H","H","H"],
                ["12","H3+","H2+","S0-","S","S","H","H","H","H","H"],
                ["11","D","D","D","D","D","D","D","D","D","H1+"],
                ["10","D","D","D","D","D","D","D","D","H4+","H4+"],
                ["9","H1+","D","D","D","D","H3+","H","H","H","H"],
                ["8","H","H","H","H","H2+","H","H","H","H","H"]]
    
    var cellConfig: OrderedDictionary<String, UIColor> = ["": UIColor.white,
                                                          "H": UIColor.white,
                                                          "S": UIColor.yellow.withAlphaComponent(0.7),
                                                          "D": UIColor.green.withAlphaComponent(0.7)]
    
    func copy() -> ChartProtocol {
        let copy = S17HardTotalsChart()
        return copy
    }
}


class SurrenderChart: ChartProtocol {
    
    var data = [["16","","","","","","","","SUR","SUR","SUR"],
                ["15","","","","","","","","","SUR",""],
                ["14","","","","","" ,"","","","",""]]
    
    var cellConfig: OrderedDictionary<String, UIColor> = ["": UIColor.white,
                                                          "SUR": UIColor.green.withAlphaComponent(0.7)]

    func copy() -> ChartProtocol {
        let copy = SurrenderChart()
        return copy
    }
}

class H17SurrenderChart: ChartProtocol {
    
    var data = [["17","","","","","","","","","","SUR"],
                ["16","","","","","","","4+","SUR-1-","SUR","SUR"],
                ["15","","","","","","","","2+","SUR0-","-1+"],
                ["14","","","","","" ,"","","","",""]]
    
    var cellConfig: OrderedDictionary<String, UIColor> = ["": UIColor.white,
                                                          "SUR": UIColor.green.withAlphaComponent(0.7)]

    func copy() -> ChartProtocol {
        let copy = H17SurrenderChart()
        return copy
    }
}

class S17SurrenderChart: ChartProtocol {
    
    var data = [["16","","","","","","","4+","SUR-1-","SUR","SUR"],
                ["15","","","","","","","","2+","SUR0-","2+"],
                ["14","","","","","" ,"","","","",""]]
    
    var cellConfig: OrderedDictionary<String, UIColor> = ["": UIColor.white,
                                                          "SUR": UIColor.green.withAlphaComponent(0.7)]

    func copy() -> ChartProtocol {
        let copy = S17SurrenderChart()
        return copy
    }
}

