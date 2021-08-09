import Foundation
import SwiftGridView

struct PrettyDataPoint {
    var title:String
    var alignment:NSTextAlignment = .left
    var order:PrettyHeaderSortOrder = .none
}

protocol PrettyDataSourceProtocol : AnyObject {
    var chart: ChartProtocol! { get set }
}

class PrettyDataSource : SwiftGridViewDataSource {
    
    var delegate: PrettyDataSourceProtocol!

    func numberOfSectionsInDataGridView(_ dataGridView: SwiftGridView) -> Int {
        
        return 1
    }
    
    func numberOfColumnsInDataGridView(_ dataGridView: SwiftGridView) -> Int {
        
        return delegate.chart.headers.count
    }
    
    func numberOfFrozenColumnsInDataGridView(_ dataGridView: SwiftGridView) -> Int {
        
        return 1
    }
    
    func dataGridView(_ dataGridView: SwiftGridView, numberOfRowsInSection section: Int) -> Int {
        
        return self.delegate.chart.data.count
    }
    
    func dataGridView(_ dataGridView: SwiftGridView, cellAtIndexPath indexPath: IndexPath) -> SwiftGridCell {
        let cell = dataGridView.dequeueReusableCellWithReuseIdentifier(PrettyRowCell.reuseIdentifier(), forIndexPath: indexPath) as! PrettyRowCell
        let row = self.self.delegate.chart.data[indexPath.sgRow]
        let column = row[indexPath.sgColumn]
        
        cell.indexPath = indexPath
        cell.addObserver(delegate.chart)
        cell.setup(text: column, cellConfig: delegate.chart.cellConfig)
        
        if (delegate.chart.isQuiz) {
            cell.button.isUserInteractionEnabled = true
        } else {
            cell.button.isUserInteractionEnabled = false
        }
        
        return cell
    }
    
    func dataGridView(_ dataGridView: SwiftGridView, gridHeaderViewForColumn column: NSInteger) -> SwiftGridReusableView {
        let headerView = dataGridView.dequeueReusableSupplementaryViewOfKind(SwiftGridElementKindHeader, withReuseIdentifier: PrettyHeaderView.reuseIdentifier(), atColumn: column) as! PrettyHeaderView
        
        headerView.mainLabel.text = delegate.chart.headers[column]
        
        return headerView
    }
    
    func columnGroupingsForDataGridView(_ dataGridView: SwiftGridView) -> [[Int]] {
        
        return [[0, self.self.delegate.chart.data[0].count]]
    }
    
    func dataGridView(_ dataGridView: SwiftGridView, groupedHeaderViewFor columnGrouping: [Int], at index: Int) -> SwiftGridReusableView {
        let view = dataGridView.dequeueReusableSupplementaryViewOfKind(SwiftGridElementKindGroupedHeader, withReuseIdentifier: PrettyHeaderView.reuseIdentifier(), atColumn: index) as! PrettyHeaderView
        
        view.mainLabel.text = "DEALER UPCARD"
        
        return view;
    }
    
}
