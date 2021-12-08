//
//  DeckRoundingView.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 8/22/21.
//

import UIKit



class DeckRoundingView: NSObject {
    var tableView: UIView!
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.backgroundColor = .secondarySystemBackground
        stack.axis = .vertical
        stack.spacing = 0
        stack.alignment = .fill
        stack.distribution = .fill
        [imageView,
         bottomStackView
         ].forEach { stack.addArrangedSubview($0) }
        stack.layer.cornerRadius = 10
        stack.layer.masksToBounds = true
        return stack
    }()
    
    lazy var bottomStackView: UIStackView = {
        let stack = UIStackView()
        //stack.backgroundColor = .systemBackground
        stack.axis = .vertical
        stack.spacing = 15
        stack.alignment = .fill
        stack.distribution = .fill
        [decksDiscardedLabel,
         titleLabel,
         inputStackView,
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
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.text = "Decks Remaining"
        label.textAlignment = .center
        //label.backgroundColor = .systemBackground
        return label
    }()
    lazy var inputStackView: UIStackView = {
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
        textField.keyboardType = increment == 1 ? .numberPad : .decimalPad
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
        
        return button
    }()
    lazy var decreaseButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(decrease), for: .touchUpInside)
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 17, weight: .regular, scale: .large)
        let image = UIImage(systemName: "chevron.down.square.fill", withConfiguration: imageConfiguration)
        button.setImage(image, for: .normal)
        button.contentHorizontalAlignment = .right
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
    lazy var decksDiscardedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .systemRed
        label.text = "Decks discarded: 0"
        label.textAlignment = .center
        //label.backgroundColor = .systemBackground
        label.isHidden = !showDiscardAndRemainingTotals
        return label
    }()
    var showDiscardAndRemainingTotals = Settings.shared.showDiscardedRemainingDecks
    var submitHandler: ((Bool, String, String) -> Void)!
    var trueCount: Int!
    
    func getString(_ number: Float) -> String {
        return increment == 1.0 ? String(format: "%.0f", number) : String(number)
    }
    
    @objc func submit(sender: UIButton!) {
        let input = getString(getFloat())
        let actual = getString(numberOfDecksLeftInPlay)
        submitHandler(input == actual, input, actual)
     }
    @objc func increase(_ sender: UIButton) {
        var i = getFloat()
        i += increment
        updateTextField(number: i)
    }
    @objc func decrease(_ sender: UIButton) {
        var i = getFloat()
        i -= increment
        updateTextField(number: i)
    }
    
    func getFloat() -> Float {
        let s = textField.text ?? ""
        let i = Float(s) ?? 0
        return i
    }
    
    func updateTextField(number: Float) {
        textField.text = getString(number)
        submitButton.isEnabled = true
    }
    var increment: Float {
        if roundLast3DecksToHalf || roundDeckToNearest == 0.5 {
            return 0.5
        } else if roundDeckToNearest == 0.25 {
            return 0.25
        }
        return 1.0
    }
    let roundDeckToNearest: Float = DeckRoundedTo(rawValue: Settings.shared.deckRoundedTo)!.floatValue
    let roundLast3DecksToHalf = Settings.shared.roundLastThreeDecksToHalf
    var numberOfDecksLeftInPlay: Float!
    
    func setup(previousAnswer: Float? = -99) -> Float {
        repeat {
            let numberOfDecks = Settings.shared.numberOfDecks
            let numberOfCardsInDeck = 52
            var runningCounts: [Int] = [0]
            for i in 1...10 {
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
            } else if Settings.shared.deckFraction == "third" {
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
            let randomNumberOfDiscardedDecks = numberOfDecksDiscarded.randomElement()!
            let numberOfCardsDiscarded = Int(randomNumberOfDiscardedDecks * Float(numberOfCardsInDeck))
            let imageName = String("D\(numberOfDecks)_\(numberOfCardsDiscarded)")//decks/D\(numberOfDecks)/
            let image = UIImage(named: imageName)
            self.imageView.image = image
            resizeImageView()
            
            //let randomRunningCount = runningCounts.randomElement()!
            //self.rcValueLabel.text = String(randomRunningCount)
            
            // # of Discarded Decks
            let adjustedNumberOfDiscardedDecks: Float
            if roundDeckToNearest == 1 {
                if roundLast3DecksToHalf && (Float(numberOfDecks) - randomNumberOfDiscardedDecks) <= 3 {
                    adjustedNumberOfDiscardedDecks = randomNumberOfDiscardedDecks.floor(nearest: 0.5)
                } else {
                    // if 0.9 -> 0, if 1.25 -> 1, if 1.5 -> 1, if 1.75 -> 1, if 1.99 -> 1
                    adjustedNumberOfDiscardedDecks = randomNumberOfDiscardedDecks.rounded(.towardZero)
                }
            } else { // roundDeckToNearest = 0.5 || 0.25 {
                // if 0.4 -> 0, if 0.5 -> 0.5, if 0.9 -> 0.5, if 0.99 -> 0.5, if 1 -> 1
                adjustedNumberOfDiscardedDecks = randomNumberOfDiscardedDecks.floor(nearest: roundDeckToNearest)
            }
             
            // # of Decks In PLay - DIVISOR
            numberOfDecksLeftInPlay = Float(numberOfDecks) - adjustedNumberOfDiscardedDecks
            if numberOfDecksLeftInPlay == 0 { numberOfDecksLeftInPlay = 1 }
            self.decksDiscardedLabel.text = "Decks discarded: \(randomNumberOfDiscardedDecks)"
        } while numberOfDecksLeftInPlay == previousAnswer && !(Settings.shared.numberOfDecks == 2 && Settings.shared.deckFraction == DeckFraction.wholes.rawValue)
        
        return numberOfDecksLeftInPlay
    }
    
    private func resizeImageView() {
        let image = self.imageView.image!
        let ratio = image.size.height / image.size.width
        var width = UIScreen.main.bounds.size.width
        if tableView.traitCollection.horizontalSizeClass == .compact {
            width *= 0.8
        } else { // assumes .regular
            width *= 0.5
        }
        let height = width * ratio
        
        self.imageView.snp.makeConstraints { (make) in
            
            make.height.equalTo(height)
            make.width.equalTo(width)
        }
    }
    
}

extension DeckRoundingView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // became first responder
        //print("TextField did begin editing method called")
        textField.text = ""
    }
}
