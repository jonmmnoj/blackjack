import Foundation
import SwiftGridView
import OrderedCollections

class PrettyRowCell : SwiftGridCell {
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var chart: ChartProtocol!
    var indexPath: IndexPath!
    private(set) var text: String!
    private var cellConfig: OrderedDictionary<String, UIColor>!
    var deviationActivated = false
    private var observations = [ObjectIdentifier : Observation]()
    //var isQuiz: Bool = false
    
    override open class func reuseIdentifier() -> String {
        
        return "PrettyRowCellReuseID"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
//    @IBAction func touchUpInside(_ sender: Any) {
//        //print("tap row: \(indexPath.sgRow) column: \(indexPath.sgColumn)")
//        //if !isQuiz { return }
//        let currentIndex = cellConfig.index(forKey: text)!
//        let nextIndex = currentIndex + 1 != cellConfig.count ? currentIndex + 1 : 0
//        text = cellConfig.elements[nextIndex].key
//        updateDisplay()
//        stateDidChange()
//    }
    
    func setup(text: String, chart: ChartProtocol) {//cellConfig: OrderedDictionary<String, UIColor>) {
        self.text = text
        self.chart = chart
        self.cellConfig = chart.cellConfig
        updateDisplay()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))  //Tap function will call when user tap on button
        //let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(long))  //Long function will call when user long press on button.
           tapGesture.numberOfTapsRequired = 1
        //longGesture.
           button.addGestureRecognizer(tapGesture)
           
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(gesture:)))
        //longPress.minimumPressDuration = 1
        if chart.deviationConfig != nil {
            self.button.addGestureRecognizer(longPress)
        }
    }
    
    
    @objc func longPress(gesture: UILongPressGestureRecognizer) {
            if gesture.state == UIGestureRecognizer.State.began {
           // print("Long Press")
                deviationActivated = !deviationActivated
                if deviationActivated {
                    cellConfig = chart.deviationConfig
                } else {
                    cellConfig = chart.cellConfig
                }
                changeText()
        }
    }

   

       @objc func tap() {

           //print("Tap happend")
                   //print("tap row: \(indexPath.sgRow) column: \(indexPath.sgColumn)")
                   //if !isQuiz { return }
                   changeText()
                   updateDisplay()
                   stateDidChange()
       }
    
    func changeText() {
        let currentIndex = cellConfig.index(forKey: text) ?? -1
        let nextIndex = currentIndex + 1 != cellConfig.count ? currentIndex + 1 : 0
        text = cellConfig.elements[nextIndex].key
    }

    
    
    
    func updateDisplay() {
        var string = text ?? ""
        var forBackgroundColor = text ?? ""
        if text.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil && !text.contains("A,") {
            string = text.components(separatedBy: CharacterSet.letters).joined()
            forBackgroundColor = text.components(separatedBy: CharacterSet.letters.inverted)
                .joined()
        }
        button.setTitle(string, for: .normal)
        button.backgroundColor = cellConfig[forBackgroundColor] ?? .white
        if text.contains("+") || text.contains("-") {
            button.setTitleColor(.red, for: .normal)
        }
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
