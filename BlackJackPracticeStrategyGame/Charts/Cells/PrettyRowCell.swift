import Foundation
import SwiftGridView
import OrderedCollections

class PrettyRowCell : SwiftGridCell {
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var indexPath: IndexPath!
    private(set) var text: String!
    private var cellConfig: OrderedDictionary<String, UIColor>!
    private var observations = [ObjectIdentifier : Observation]()
    //var isQuiz: Bool = false
    
    override open class func reuseIdentifier() -> String {
        
        return "PrettyRowCellReuseID"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    @IBAction func touchUpInside(_ sender: Any) {
        //print("tap row: \(indexPath.sgRow) column: \(indexPath.sgColumn)")
        //if !isQuiz { return }
        let currentIndex = cellConfig.index(forKey: text)!
        let nextIndex = currentIndex + 1 != cellConfig.count ? currentIndex + 1 : 0
        text = cellConfig.elements[nextIndex].key
        updateDisplay()
        stateDidChange()
    }
    
    func setup(text: String, cellConfig: OrderedDictionary<String, UIColor>) {
        self.text = text
        self.cellConfig = cellConfig
        updateDisplay()
    }
    
    func updateDisplay() {
        button.setTitle(text, for: .normal)
        button.backgroundColor = cellConfig[text] ?? .white
    }
}

private extension PrettyRowCell {
    struct Observation {
        weak var observer: RowCellObserver?
    }
}

private extension PrettyRowCell {
    func stateDidChange() {
        for (id, observation) in observations {
            guard let observer = observation.observer else {
                observations.removeValue(forKey: id)
                continue
            }
            observer.rowCell(self, didChange: text)
        }
    }
}

extension PrettyRowCell {
    func addObserver(_ observer: RowCellObserver) {
        let id = ObjectIdentifier(observer)
        observations[id] = Observation(observer: observer)
    }

    func removeObserver(_ observer: RowCellObserver) {
        let id = ObjectIdentifier(observer)
        observations.removeValue(forKey: id)
    }
}
