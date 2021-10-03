import Foundation
import SwiftGridView

enum PrettyHeaderSortOrder {
    case none
    case ascending
    case descending
}


class PrettyHeaderView : SwiftGridReusableView {
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var sortingButton: UIButton!
    
    var sortOrder:PrettyHeaderSortOrder = .none
    
    override open class func reuseIdentifier() -> String {
        
        return "prettyHeaderViewReuseID"
    }
    
    // MARK: - Public Methods
    
    // MARK: - Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        //self.sortingButton.isHidden = true
        self.mainLabel.textAlignment = .center
        //self.sortOrder = .none
    }
}

