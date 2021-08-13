//
//  TrueCountViewController.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 8/10/21.
//

import UIKit

class TrueCountViewController { //: UIViewController {
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        //stack.backgroundColor = .systemBackground
        stack.axis = .vertical
        stack.spacing = 0
        stack.alignment = .fill
        stack.distribution = .fill
        [self.topStackView,
         self.bottomStackView].forEach { stack.addArrangedSubview($0) }
        return stack
    }()
    
    lazy var topStackView: UIStackView = {
        let stack = UIStackView()
        stack.backgroundColor = .systemBackground
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .fill
        stack.distribution = .fill
        [self.rcTitleLabel,
         self.rcValueLabel,
            self.imageView,
        self.decksDiscardedLabel,
        self.decksRemainingLabel,
        ].forEach { stack.addArrangedSubview($0) }
        return stack
    }()
    
    lazy var bottomStackView: UIStackView = {
        let stack = UIStackView()
        stack.backgroundColor = .systemBackground
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .fill
        stack.distribution = .fill
        [self.tcTitleLabel,
        self.tcStackView,
        self.submitButton].forEach { stack.addArrangedSubview($0) }
        return stack
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "D6_0")
        imageView.image = image
        imageView.backgroundColor = .red
        imageView.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .vertical)
        return imageView
    }()
    lazy var decksDiscardedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.text = "Decks discarded: 0"
        label.textAlignment = .center
        label.backgroundColor = .systemBackground
        label.isHidden = !showDiscardAndRemainingTotals
        return label
    }()
    lazy var decksRemainingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.text = "Decks remaining (rounded): 0"
        label.textAlignment = .center
        label.backgroundColor = .systemBackground
        label.isHidden = !showDiscardAndRemainingTotals
        return label
    }()
    lazy var rcTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.text = "Running Count"
        label.textAlignment = .center
        label.backgroundColor = .systemBackground
        return label
    }()
    lazy var rcValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.text = "5"
        label.textAlignment = .center
        label.backgroundColor = .systemBackground
        return label
    }()
    lazy var tcTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.text = "True Count"
        label.textAlignment = .center
        label.backgroundColor = .systemBackground
        return label
    }()
    lazy var tcStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 20.0
        stack.alignment = .fill
        stack.distribution = .fillEqually
        [self.decreaseButton,
            self.textField,
            self.increaseButton,
            ].forEach { stack.addArrangedSubview($0) }
        return stack
    }()
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.placeholder = "0"
        textField.text = "0"
        //textField.font = UIFont.systemFont(ofSize: 15)
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.numberPad
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        //textField.delegate = self
        return textField
    }()
    lazy var increaseButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.backgroundColor = .orange
        button.addTarget(self, action: #selector(increase), for: .touchUpInside)
        return button
    }()
    lazy var decreaseButton: UIButton = {
        let button = UIButton()
        button.setTitle("-", for: .normal)
        button.backgroundColor = .yellow
        button.addTarget(self, action: #selector(decrease), for: .touchUpInside)
        return button
    }()
    lazy var submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Submit", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(submit), for: .touchUpInside)
        button.snp.makeConstraints { (make) in
            make.height.equalTo(50)
        }
        return button
    }()
    
    var submitHandler: ((Bool, String, String) -> Void)!
    var trueCount: Int!
    
    @objc func submit(sender: UIButton!) {
        submitHandler(getInt() == trueCount, String(getInt()), String(trueCount) )
     }
    @objc func increase(_ sender: UIButton) {
        var i = getInt()
        i += 1
        updateTextField(number: i)
    }
    @objc func decrease(_ sender: UIButton) {
        var i = getInt()
        i -= 1
        updateTextField(number: i)
    }
    
    func getInt() -> Int {
        let s = textField.text ?? ""
        let i = Int(s) ?? 0
        return i
    }
    
    func updateTextField(number: Int) {
        textField.text = String(number)
        submitButton.isEnabled = true
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        //view.backgroundColor = .systemBackground
//        view.backgroundColor = Settings.shared.defaults.tableColor
//        view.addSubview(stackView)
//        stackView.snp.makeConstraints { (make) in
//            make.left.equalTo(view.safeAreaLayoutGuide.snp.leftMargin).offset(50)
//            make.right.equalTo(view.safeAreaLayoutGuide.snp.rightMargin).offset(-50)
//            //make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(100)//.snp.topMargin)//.offset(50)
//            //make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).offset(-100)//.offset(50)
//            make.centerWithinMargins.equalTo(view.snp.centerWithinMargins)
//            make.height.lessThanOrEqualTo(view.snp.height)
//        }
//
//
//        setup()
//    }
    
    var showDiscardAndRemainingTotals = false
    func setup() {
        let numberOfDecks = 6//Settings.shared.numberOfDecks
        let roundDeckToNearest: Float = 1
        let roundLast3DecksToHalf = false
        let numberOfCardsInDeck = 52
        var runningCounts: [Int] = [0]
        for i in 1...10 {
            runningCounts.append(i)
            runningCounts.append(i * -1)
        }
        
        var numberOfDecksDiscarded: [Float] = []
        for i in 0..<numberOfDecks {
            let n = Float(i)
            numberOfDecksDiscarded.append(n + 0.25)
            numberOfDecksDiscarded.append(n + 0.50)
            numberOfDecksDiscarded.append(n + 0.75)
            if i != numberOfDecks - 1 { numberOfDecksDiscarded.append(n + 1.0) }
        }
        
        let randomNumberOfDiscardedDecks = numberOfDecksDiscarded.randomElement()!
        let numberOfCardsDiscarded = Int(randomNumberOfDiscardedDecks * Float(numberOfCardsInDeck))
        let imageName = String("D\(numberOfDecks)_\(numberOfCardsDiscarded)")//decks/D\(numberOfDecks)/
        let image = UIImage(named: imageName)
        self.imageView.image = image
        
        let randomRunningCount = runningCounts.randomElement()!
        self.rcValueLabel.text = String(randomRunningCount)
        
        
        let adjustedNumberOfDiscardedDecks: Float
        if roundDeckToNearest == 1 {
            if roundLast3DecksToHalf && randomNumberOfDiscardedDecks >= 3 {
                adjustedNumberOfDiscardedDecks = randomNumberOfDiscardedDecks.floor(nearest: 0.5)
            } else {
                // if 0.9 -> 0, if 1.25 -> 1, if 1.5 -> 1, if 1.75 -> 1, if 1.99 -> 1
                adjustedNumberOfDiscardedDecks = randomNumberOfDiscardedDecks.rounded(.towardZero)
            }
        } else { // roundDeckToNearest = 0.5 {
            // if 0.4 -> 0, if 0.5 -> 0.5, if 0.9 -> 0.5, if 0.99 -> 0.5, if 1 -> 1
            adjustedNumberOfDiscardedDecks = randomNumberOfDiscardedDecks.floor(nearest: 0.5)
        }
         
        var numberOfDecksLeftInPlay = Float(numberOfDecks) - adjustedNumberOfDiscardedDecks
        if numberOfDecksLeftInPlay == 0 { numberOfDecksLeftInPlay = 1 }
        
        self.decksDiscardedLabel.text = "Decks discarded: \(randomNumberOfDiscardedDecks)"
        self.decksRemainingLabel.text = "Decks remaining (rounded): \(numberOfDecksLeftInPlay)"
        
        
        let divisionResult = (Float(randomRunningCount) / numberOfDecksLeftInPlay)
        // Converting to Int would have the same effect, no? IE, remove decimals.
        self.trueCount = Int(divisionResult)//randomRunningCount < 0 ? divisionResult.rounded(.up) : divisionResult.rounded(.down)
        /*
         tc = 1 / 1 = 1
            = 1 / 2 = 0
            = 2 / 1 = 2
         */
        //self.textField.placeholder = String(trueCount)
        //self.textField.text = String(trueCount)
        
        print("------------")
        print("RC: \(randomRunningCount)")
        print("Actual discarded decks: \(randomNumberOfDiscardedDecks)")
        print("Adjusted dicarded decks: \(adjustedNumberOfDiscardedDecks)")
        print("Decks in play: \(numberOfDecksLeftInPlay)")
        print("RC ÷ Decks in play: \(divisionResult)")
        print("TC: \(trueCount!)")
    }
}

//extension TrueCountViewController: UITextFieldDelegate {
//
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        // return NO to disallow editing.
//        print("TextField should begin editing method called")
//        return true
//    }
//
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        // became first responder
//        print("TextField did begin editing method called")
//    }
//
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
//        print("TextField should snd editing method called")
//        return true
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
//        print("TextField did end editing method called")
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
//        // if implemented, called in place of textFieldDidEndEditing:
//        print("TextField did end editing with reason method called")
//    }
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        // return NO to not change text
//        print("While entering the characters this method gets called")
//        return true
//    }
//
//    func textFieldShouldClear(_ textField: UITextField) -> Bool {
//        // called when clear button pressed. return NO to ignore (no notifications)
//        print("TextField should clear method called")
//        return true
//    }
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        // called when 'return' key pressed. return NO to ignore.
//        print("TextField should return method called")
//        // may be useful: textField.resignFirstResponder()
//        return true
//    }
//
//}


extension Float {
    func round(nearest: Float) -> Float {
        let n = 1/nearest
        let numberToRound = self * n
        return numberToRound.rounded() / n
    }

    func floor(nearest: Float) -> Float {
        let intDiv = Float(Int(self / nearest))
        return intDiv * nearest
    }
}
