//
//  RowCellObserver.swift
//  PrettyExample
//
//  Created by JON on 6/22/21.
//  Copyright © 2021 nlampi. All rights reserved.
//

import Foundation

protocol RowCellObserver: AnyObject {
    func rowCell(_ rowCell: PrettyRowCell, didChange text: String)
}


//https://www.swiftbysundell.com/articles/observers-in-swift-part-1/
