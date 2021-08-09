//
//  CellContentEnumeration.swift
//  PrettyExample
//
//  Created by JON on 6/22/21.
//  Copyright © 2021 nlampi. All rights reserved.
//

import Foundation
import UIKit

enum CellContent {
    case Empty
    case Hit
    case Stand
    case Double
    case DoubleStand
    case Surrender
    case Yes
    case No
    case YesNo
    
    var backgroundColor: UIColor {
        switch self {
            case .Empty:
                return .white
            case .Hit:
                return .white
            case .Stand:
                return .yellow
            case .Double:
                return .green
            case .DoubleStand:
                return .blue
            case .Surrender:
                return .green
        case .Yes:
            return .green
        case .No:
            return .white
        case .YesNo:
            return .blue
        }
    }
    
    var text: String {
        switch self {
        case .Empty:
            return ""
        case .Hit:
            return "H"
        case .Stand:
            return "S"
        case .Double:
            return "D"
        case .DoubleStand:
            return "Ds"
        case .Surrender:
            return "SUR"
        case .Yes:
            return "Y"
        case .No:
            return "N"
        case .YesNo:
            return "Y/N"
        }
    }
}
