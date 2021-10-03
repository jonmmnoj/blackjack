import Foundation
import SwiftGridView

protocol PrettyDelegateProtocol : AnyObject {
    func dataGridView(_ dataGridView: SwiftGridView, didSelectHeaderAtIndexPath indexPath: IndexPath)
}

class PrettyDelegate : SwiftGridViewDelegate {
    
    weak var delegate:PrettyDelegateProtocol?
    
    func dataGridView(_ dataGridView: SwiftGridView, widthOfColumnAtIndex columnIndex: Int) -> CGFloat {
        //print(dataGridView.frame.width)
        let width: CGFloat = dataGridView.frame.width / 11.0
        //let width: CGFloat = 60
        return width
    }
    
    func dataGridView(_ dataGridView: SwiftGridView, heightOfRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        let height: CGFloat = ((dataGridView.frame.width / 11.0) * 0.35).rounded()
        //let height: CGFloat = 60
        return height
    }
    
    func heightForGridHeaderInDataGridView(_ dataGridView: SwiftGridView) -> CGFloat {
        let height: CGFloat = ((dataGridView.frame.width / 11.0) * 0.35 * 2).rounded()
        //let height: CGFloat = 60
        return height
    }
}
