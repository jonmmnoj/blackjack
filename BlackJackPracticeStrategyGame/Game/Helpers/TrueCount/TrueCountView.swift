//
//  TrueCountViewController.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 8/10/21.
//

import UIKit


class TrueCountView: NSObject {
    var tableView: UIView!
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.backgroundColor = .secondarySystemBackground
        stack.axis = .vertical
        stack.spacing = 0
        stack.alignment = .fill
        stack.distribution = .fill
        [topStackView,
         bottomStackView].forEach { stack.addArrangedSubview($0) }
        
        stack.layer.cornerRadius = 10
        stack.layer.masksToBounds = true
        
        return stack
    }()
    
    lazy var topStackView: UIStackView = {
        let stack = UIStackView()
        stack.backgroundColor = .secondarySystemBackground
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .fill
        stack.distribution = .fill
        [rcTitleLabel,
         rcValueLabel,
         imageView,
         decksDiscardedLabel,
         decksRemainingLabel,
        ].forEach { stack.addArrangedSubview($0) }
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0)
        return stack
    }()
    
    lazy var bottomStackView: UIStackView = {
        let stack = UIStackView()
        stack.backgroundColor = .secondarySystemBackground
        stack.axis = .vertical
        stack.spacing = 15
        stack.alignment = .fill
        stack.distribution = .fill
        [tcTitleLabel,
         tcStackView,
         submitButton].forEach { stack.addArrangedSubview($0) }
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0)
        
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
        label.textColor = .systemRed
        label.text = "Decks discarded: 0"
        label.textAlignment = .center
        //label.backgroundColor = .systemBackground
        label.isHidden = !Settings.shared.showDiscardedRemainingDecks
        return label
    }()
    lazy var decksRemainingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .systemRed
        label.text = "Decks remaining: 0"//(rounded): 0"
        label.textAlignment = .center
        //label.backgroundColor = .systemBackground
        label.isHidden = !Settings.shared.showDiscardedRemainingDecks
        return label
    }()
    lazy var rcTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.text = "Running Count"
        label.textAlignment = .center
        //label.backgroundColor = .systemBackground
        return label
    }()
    lazy var rcValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.textColor = .systemGreen
        label.text = "5"
        label.textAlignment = .center
        //label.backgroundColor = .systemBackground
        return label
    }()
    lazy var tcTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.text = "True Count"
        label.textAlignment = .center
        //label.backgroundColor = .systemBackground
        return label
    }()
    lazy var tcStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 20.0
        stack.alignment = .fill
        stack.distribution = .fillEqually
        [decreaseButton,
         textField,
         increaseButton,
        ].forEach { stack.addArrangedSubview($0) }
        return stack
    }()
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.font = UIFont.preferredFont(forTextStyle: .title2)
        textField.placeholder = "0"
        textField.text = "0"
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.numberPad
        textField.returnKeyType = UIReturnKeyType.done
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.addNumericAccessory(addPlusMinus: true)
        textField.delegate = self
        return textField
    }()
    lazy var increaseButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(increase), for: .touchUpInside)
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 17, weight: .regular, scale: .large)
        let image = UIImage(systemName: "chevron.up.square.fill", withConfiguration: imageConfiguration)
        button.setImage(image, for: .normal)
        button.contentHorizontalAlignment = .left
        button.tintColor = UIColor(hex: TableColor(rawValue: Settings.shared.buttonColor)!.buttonCode)
        return button
    }()
    lazy var decreaseButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(decrease), for: .touchUpInside)
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 17, weight: .regular, scale: .large)
        let image = UIImage(systemName: "chevron.down.square.fill", withConfiguration: imageConfiguration)
        button.setImage(image, for: .normal)
        button.contentHorizontalAlignment = .right
        button.tintColor = UIColor(hex: TableColor(rawValue: Settings.shared.buttonColor)!.buttonCode)

        return button
    }()
    lazy var submitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hex: TableColor(rawValue: Settings.shared.buttonColor)!.buttonCode)
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.addTarget(self, action: #selector(submit), for: .touchUpInside)
        button.snp.makeConstraints { (make) in
            make.height.equalTo(75)
        }
        
        return button
    }()
    
    var submitHandler: ((Bool, String, String) -> Void)!
    var trueCount: Int!
    
    @objc func submit(sender: UIButton!) {
        let input = getInt()
        var isCorrect = input == trueCount
        var answer = String(input)
        if !isCorrect {
            if abs(trueCountPlusQuarterDeck) >= abs(input) && abs(input) >= abs(trueCountMinusQuarterDeck) {
                isCorrect = true
                answer += (" (± 1/4 deck)")
            }
        }
        submitHandler(isCorrect, answer, String(trueCount) )
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
    
    var trueCountFloat: Float!
    var randomNumberOfDiscardedDecks: Float!
    var trueCountPlusQuarterDeck: Int!
    var trueCountMinusQuarterDeck: Int!
    func setup() {
        let numberOfDecks = Settings.shared.numberOfDecks
        let roundDeckToNearest: Float = DeckRoundedTo(rawValue: Settings.shared.deckRoundedTo)!.floatValue
        let roundLast3DecksToHalf = Settings.shared.roundLastThreeDecksToHalf
        let numberOfCardsInDeck = 52
        var runningCounts: [Int] = [0]
        for i in 1...Settings.shared.maxRunningCount {
            runningCounts.append(i)
            runningCounts.append(i * -1)
        }
        
        var array: [Float]!
        let whole: [Float] = [1.0]
        let half: [Float] = [0.5, 1.0]
        let third: [Float] = [0.333, 0.666, 1.0]
        let quarter: [Float] = [0.25, 0.5, 0.75, 1.0]
        if  Settings.shared.deckFraction == "wholes" {
            array = whole
        } else if Settings.shared.deckFraction == "halves" {
            array = half
        } else if Settings.shared.deckFraction == "thirds" {
            array  = third
        }else if Settings.shared.deckFraction == "quarters" {
            array = quarter
        }
        
        var numberOfDecksDiscarded: [Float] = []
        for i in 0..<numberOfDecks {
            let n = Float(i)
            for fraction in array {
                numberOfDecksDiscarded.append(n + fraction)
            }
            if i == numberOfDecks - 1 { numberOfDecksDiscarded.removeLast() }
        }
        
        // # of Discarded Cards
        randomNumberOfDiscardedDecks = numberOfDecksDiscarded.randomElement()!
        let numberOfCardsDiscarded = Int(randomNumberOfDiscardedDecks * Float(numberOfCardsInDeck))
        let imageName = String("D\(numberOfDecks)_\(numberOfCardsDiscarded)")//decks/D\(numberOfDecks)/
        let image = UIImage(named: imageName)
        self.imageView.image = image
        resizeImageView()
        
        var randomRunningCount = runningCounts.randomElement()!
        if Settings.shared.highRunningCountBias {
            if randomRunningCount < 15 && Settings.shared.maxRunningCount > 15 {
                while randomRunningCount < 15 {
                    randomRunningCount = runningCounts.randomElement()!
                }
            } else {
                randomRunningCount = Settings.shared.maxRunningCount
            }
        }
        self.rcValueLabel.text = String(randomRunningCount)
        
        // # of Discarded Decks
        let adjustedNumberOfDiscardedDecks: Float
        if roundDeckToNearest == 1 {
            if roundLast3DecksToHalf && (Float(numberOfDecks) - randomNumberOfDiscardedDecks) <= 3 {
                adjustedNumberOfDiscardedDecks = randomNumberOfDiscardedDecks.floor(nearest: 0.5)
            } else {
                // if 0.9 -> 0, if 1.25 -> 1, if 1.5 -> 1, if 1.75 -> 1, if 1.99 -> 1
                adjustedNumberOfDiscardedDecks = randomNumberOfDiscardedDecks.rounded(.towardZero)
            }
        } else { //if roundDeckToNearest == 0.5 || 0.25 {
            // if 0.4 -> 0, if 0.5 -> 0.5, if 0.9 -> 0.5, if 0.99 -> 0.5, if 1 -> 1
            adjustedNumberOfDiscardedDecks = randomNumberOfDiscardedDecks.floor(nearest: roundDeckToNearest)
        }
         
        // # of Decks In PLay - DIVISOR
        var numberOfDecksLeftInPlay = Float(numberOfDecks) - adjustedNumberOfDiscardedDecks
        if numberOfDecksLeftInPlay == 0 { numberOfDecksLeftInPlay = 1 }
        
        self.decksDiscardedLabel.text = "Decks discarded: \(randomNumberOfDiscardedDecks)"
        self.decksRemainingLabel.text = "Decks remaining (divisor): \(numberOfDecksLeftInPlay)"//(rounded): \(numberOfDecksLeftInPlay)"
        
        // True Count
        trueCountFloat = (Float(randomRunningCount) / numberOfDecksLeftInPlay)
        self.trueCount = Int(trueCountFloat)
        
        // 1/4 Deck Margin of Error
        //var divPlusQuarterDeck = ((Float(numberOfDecks) -
        var plusQuarterDiscarded = randomNumberOfDiscardedDecks + 0.25
        //if divPlusQuarterDeck == 0 { divPlusQuarterDeck = 1 }
        var minusQuarterDiscarded =  randomNumberOfDiscardedDecks - 0.25
        
        if roundDeckToNearest == 1 {
            plusQuarterDiscarded = plusQuarterDiscarded.rounded(.towardZero)
            minusQuarterDiscarded = minusQuarterDiscarded.rounded(.towardZero)
//            if plusQuarterDiscarded == 0 {
//                plusQuarterDiscarded = 1
//            }
//            if minusQuarterDiscarded == 0 {
//                minusQuarterDiscarded = 1
//            }
        } else {
            plusQuarterDiscarded = plusQuarterDiscarded.floor(nearest: roundDeckToNearest)
            minusQuarterDiscarded = minusQuarterDiscarded.floor(nearest: roundDeckToNearest)
        }
        
        var decksRemainingPlusQuarter = Float(numberOfDecks) - plusQuarterDiscarded
        var decksRemainingMinusQuarter = Float(numberOfDecks) - minusQuarterDiscarded
        
        if decksRemainingPlusQuarter == 0 {
            decksRemainingPlusQuarter = roundDeckToNearest
        }
        if decksRemainingMinusQuarter == 0 {
            decksRemainingMinusQuarter = roundDeckToNearest
        }
    
        
        trueCountPlusQuarterDeck = Int(Float(randomRunningCount) / decksRemainingPlusQuarter)
        //trueCountMinusQuarterDeck = Int(Float(randomRunningCount) / ((Float(numberOfDecks) - randomNumberOfDiscardedDecks - 0.25)))
        trueCountMinusQuarterDeck = Int(Float(randomRunningCount) / decksRemainingMinusQuarter)
       // print("discardDecks: \(randomNumberOfDiscardedDecks)")
       // print("decks remaing +1/4: \(decksRemainingPlusQuarter)")
//        print("decks remaining -1/4: \((Float(numberOfDecks) - randomNumberOfDiscardedDecks - 0.25)))")
       // print("decks remaining -1/4: \(decksRemainingMinusQuarter)")
        //print("tc +1/4 deck: \(trueCountPlusQuarterDeck)")
        //print("tc -1/4 deck: \(trueCountMinusQuarterDeck)")

        
//        print("------------")
//        print("RC: \(randomRunningCount)")
//        print("Actual discarded decks: \(randomNumberOfDiscardedDecks)")
//        print("Adjusted dicarded decks: \(adjustedNumberOfDiscardedDecks)")
//        print("Decks in play: \(numberOfDecksLeftInPlay)")
//        print("RC ÷ Decks in play: \(divisionResult)")
//        print("TC: \(trueCount!)")
    }
    
    private func resizeImageView() {
        let image = self.imageView.image!
        let ratio = image.size.height / image.size.width
        var width = UIScreen.main.bounds.size.width
        if tableView.traitCollection.horizontalSizeClass == .compact {
            width *= 0.75
        } else { // assumes .regular
            width *= 0.5
        }
        if Settings.shared.horizontalSizeClass == .regular {
            width = 350
        }
        let height = width * ratio
        
        self.imageView.snp.makeConstraints { (make) in
            
            make.height.equalTo(height)
            make.width.equalTo(width)
        }
    }
}

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

extension TrueCountView: UITextFieldDelegate {

//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        // return NO to disallow editing.
//        print("TextField should begin editing method called")
//        return true
//    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        // became first responder
        //print("TextField did begin editing method called")
        textField.text = ""
    }

//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
//        print("TextField should snd editing method called")
//        return true
//    }

//    func textFieldDidEndEditing(_ textField: UITextField) {
//        // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
//        print("TextField did end editing method called")
//    }

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

}
