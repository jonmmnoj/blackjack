//
//  PlaceBetView.swift
//  BlackJackPracticeStrategyGame
//
//  Created by Jon on 10/23/21.
//

import UIKit
import Foundation

class PlaceBetView: UIView {
    var dealHandler: ((Int) -> Void)!
    var exitGameHandler: (() -> Void)!
    lazy var discardTray: DiscardTrayView = {
        let view = DiscardTrayView(frame: .zero)
        //view.delegate = gameMaster.delegate
        return view
    }()
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var chipsView: UIView!
    @IBOutlet weak var betView: UIView!
    @IBOutlet weak var buttonView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bankRollLabel: UILabel!
    @IBOutlet weak var bankRollAmountLabel: UILabel!
    @IBOutlet weak var betSectionTitleLabel: UILabel!
    @IBOutlet weak var currentBetAmountLabel: UILabel!
    
    @IBOutlet weak var chip500Button: UIButton!
    @IBOutlet weak var chip100Button: UIButton!
    @IBOutlet weak var chip25Button: UIButton!
    @IBOutlet weak var chip5Button: UIButton!
    @IBOutlet weak var clearBetButton: UIButton!
    @IBOutlet weak var dealButton: UIButton!
    @IBOutlet weak var endGameButton: UIButton!
    
    @IBAction func chip5Action(_ sender: UIButton!) {
        betAmount += 5
    }
    
    @IBAction func chip25Action(_ sender: UIButton!) {
        betAmount += 25
    }
    
    @IBAction func chip100Action(_ sender: UIButton!) {
        betAmount += 100
    }
    
    @IBAction func chip500Action(_ sender: UIButton!) {
        betAmount += 500
    }
    
    @IBAction func clearBetAction(_ sender: UIButton!) {
        betAmount = 0
    }
    
    @IBAction func dealAction(_ sender: UIButton!) {
        dealHandler(betAmount)
    }
    @IBAction func endGameAction(_ sender: UIButton!) {
        exitGameHandler()
        bankRollAmount += Double(betAmount)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("PlaceBetView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        bankRollAmount = Settings.shared.bankRollAmount
        betAmount = Settings.shared.previousBetAmount
        
        dealButton.backgroundColor = Settings.shared.defaults.buttonColor
        dealButton.setTitleColor(.white, for: .normal)
        titleView.backgroundColor = Settings.shared.defaults.buttonColor
        titleLabel.textColor = .white
        chipsView.backgroundColor = Settings.shared.defaults.tableColor
        clearBetButton.setTitleColor(.gray, for: .normal)
        endGameButton.setTitleColor(.white, for: .normal)
        bankRollLabel.textColor = .darkGray
        bankRollAmountLabel.textColor = .darkGray
    }
    
    var betAmount: Int = 0 {
        willSet {
            if newValue == 0 {
                bankRollAmount += Double(betAmount)
            } else {
                let dif = newValue - betAmount
                bankRollAmount -= Double(dif)
            }
        }
        didSet {
            let currencyFormatter = NumberFormatter()
            currencyFormatter.usesGroupingSeparator = true
            currencyFormatter.numberStyle = .currency
            currencyFormatter.maximumFractionDigits = 0
            let priceString = currencyFormatter.string(from: NSNumber(value: betAmount))!
            currentBetAmountLabel.text = priceString
            Settings.shared.previousBetAmount = betAmount
        }
    }
    
    var bankRollAmount: Double {
        get {
            return Settings.shared.bankRollAmount
        }
        set {
            Settings.shared.bankRollAmount = newValue
            let currencyFormatter = NumberFormatter()
            currencyFormatter.usesGroupingSeparator = true
            currencyFormatter.numberStyle = .currency
            let priceString = currencyFormatter.string(from: NSNumber(value: newValue))!
            bankRollAmountLabel.text = priceString
        }
    }
}
