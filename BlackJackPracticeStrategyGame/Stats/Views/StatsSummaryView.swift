//
//  StatsSummaryView.swift
//  BlackJackPracticeStrategyGame
//
//  Created by Jon on 12/4/21.
//

import UIKit

class StatsSummaryView: UIView {

    var player: Player
    var vc: UIViewController!
    var dealHandler: ((Int) -> Void)!
    var exitGameHandler: (() -> Void)!
    var discardTrayIsOpen: Bool = false
    lazy var discardTray: DiscardTrayView = {
        let view = DiscardTrayView(frame: .zero)
        if discardTrayIsOpen {
            view.beginOpen = true
        }
        return view
    }()
    private var bankRollAmount: Double {
        get {
            return Bankroll.shared.amount
        }
        set {
            Bankroll.shared.amount = newValue
            let currencyFormatter = NumberFormatter()
            currencyFormatter.usesGroupingSeparator = true
            currencyFormatter.numberStyle = .currency
            let priceString = currencyFormatter.string(from: NSNumber(value: newValue))!
            bankRollAmountLabel.text = priceString
        }
    }
    private var betAmount: Int = 0 {
        willSet {
            if newValue == 0 {
                bankRollAmount += Double(betAmount)
                if player.dealt2Hands {
                    bankRollAmount += Double(betAmount)
                }
            } else {
                let dif = newValue - betAmount
                bankRollAmount -= Double(dif)
                if player.dealt2Hands {
                    bankRollAmount -= Double(dif)
                }
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
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var stackView: UIView!
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
    @IBOutlet weak var oneHandButton: UIButton!
    @IBOutlet weak var twoHandsButton: UIButton!
    
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
        if Settings.shared.betSpread {
            let actualTrueCount = CardCounter.shared.getTrueCount()
            var adjustedTrueCount = actualTrueCount
            if actualTrueCount < -2 { adjustedTrueCount = -2 }
            if actualTrueCount > 6 { adjustedTrueCount = 6 }
            let settingAmount = BetSpread.getBetAmount(for: adjustedTrueCount)
            if betAmount != settingAmount {
                let message = "You should bet $\(settingAmount) @ TC \(actualTrueCount)"
                PlayError.notifyMistake(presenter: self.vc, message: message, completion: { [weak self] fix in
                    if !fix {
                        self?.dealHandler(self?.betAmount ?? 0)
                    }
                })
            } else {
                dealHandler(betAmount)
            }
        } else {
            dealHandler(betAmount)
        }
    }
    @IBAction func endGameAction(_ sender: UIButton!) {
        exitGameHandler()
        bankRollAmount += Double(betAmount)
    }
    
    required init(player: Player) {
        self.player = player
        super.init(frame: .zero)
        commonInit()
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("PlaceBetView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        bankRollAmount = Settings.shared.bankRollAmount
        betAmount = Settings.shared.previousBetAmount
        
        dealButton.backgroundColor = UIColor(hex: TableColor(rawValue: Settings.shared.buttonColor)!.buttonCode)
        dealButton.setTitleColor(.white, for: .normal)
        titleView.backgroundColor = UIColor(hex: TableColor(rawValue: Settings.shared.buttonColor)!.buttonCode)
        titleLabel.textColor = .white
        chipsView.backgroundColor = UIColor(hex: TableColor(rawValue: Settings.shared.tableColor)!.tableCode)
        clearBetButton.setTitleColor(.gray, for: .normal)
        endGameButton.setTitleColor(.white, for: .normal)
        bankRollLabel.textColor = .darkGray
        bankRollAmountLabel.textColor = .darkGray
    }
    
    func setupNumberOfHands() {
        oneHandButton.backgroundColor = .systemBackground
        oneHandButton.layer.borderColor = UIColor.systemFill.cgColor
        oneHandButton.layer.borderWidth = 1
        oneHandButton.layer.cornerRadius = 10
        twoHandsButton.backgroundColor = .systemBackground
        twoHandsButton.layer.borderColor = UIColor.systemFill.cgColor
        twoHandsButton.layer.borderWidth = 1
        twoHandsButton.layer.cornerRadius = 10
        if player.dealt2Hands {
            twoHandsButton.backgroundColor = .systemFill
        } else {
            oneHandButton.backgroundColor = .systemFill
        }
    }
    
    @IBAction func numberOfHandsHandler(sender: UIButton) {
        if (player.dealt2Hands && sender == twoHandsButton) || (!player.dealt2Hands && sender == oneHandButton) {
            return
        }
        
        if sender.title(for: .normal) == "1 Hand" {
            //oneHandButton.setTitleColor(UIColor.green, for: .normal)
            oneHandButton.backgroundColor = .systemFill
            twoHandsButton.backgroundColor = .systemBackground
            player.dealt2Hands = false
            bankRollAmount += Double(betAmount)
        } else {
            player.dealt2Hands = true
            oneHandButton.backgroundColor = .systemBackground
            twoHandsButton.backgroundColor = .systemFill
            bankRollAmount -= Double(betAmount)
        }
    }
}
