import UIKit
import SnapKit

class GameViewController: UIViewController {
    var gameMaster: GameMaster!
    var gameType: GameType!
    var showInputButtons: Bool {
        let gameTypes: [GameType] = [.runningCount, .deviations, .trueCount, .deckRounding]
        return !gameTypes.contains(gameType)
    }
    
    lazy var homeButton: UIButton = {
        let button = makeButton(title: "")
        button.addTarget(self, action: #selector(homeButtonAction(_:)), for: .touchUpInside)
        button.isEnabled = true
        button.backgroundColor = .clear
        button.tintColor = .white
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 1000, weight: .bold, scale: .large)
        let image = UIImage(systemName: "arrow.backward", withConfiguration: imageConfig) //chevron.backward.circle.fill,arrow.backward.circle.fill,arrowshape.turn.up.backward.circle.fill
        button.setImage(image , for: .normal)
        
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5.0
        stack.alignment = .fill
        stack.distribution = .fillEqually
        [hitButton, standButton, doubleButton, splitButton].forEach {
            $0.backgroundColor = Settings.shared.defaults.buttonColor
            $0.setTitleColor(.white.withAlphaComponent(0.5), for: .disabled)
            stack.addArrangedSubview($0)
        }
        if Settings.shared.surrender {
            surrenderButton.backgroundColor = Settings.shared.defaults.buttonColor
            surrenderButton.setTitleColor(.white.withAlphaComponent(0.5), for: .disabled)
            stack.addArrangedSubview(surrenderButton)
        }
        return stack
    }()
    
    lazy var hitButton: UIButton = {
        let button = makeButton(title: "HIT")
        button.addTarget(self, action: #selector(hitButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var standButton: UIButton = {
        let button = makeButton(title: "STD")
        button.addTarget(self, action: #selector(standButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var splitButton: UIButton = {
        let button = makeButton(title: "SPL")
        button.addTarget(self, action: #selector(splitButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var doubleButton: UIButton = {
        let button = makeButton(title: "DBL")
        button.addTarget(self, action: #selector(doubleButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var surrenderButton: UIButton = {
        let button = makeButton(title: "SUR")
        button.addTarget(self, action: #selector(surrenderButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if showInputButtons {
            self.view.addSubview(stackView)
            stackView.snp.makeConstraints { (make) in
                var height = Settings.shared.cardSize
                if Settings.shared.surrender {
                    height = Settings.shared.cardSize * 5/4
                }
                make.height.equalTo(height)
                let width = Settings.shared.cardWidth
                make.width.equalTo(width)
                make.centerY.equalTo(self.view)
                make.right.equalTo(self.view)
            }
        }
        
        super.view.addSubview(homeButton)
        homeButton.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.width.equalTo(20)
            make.bottom.equalTo(self.view).offset(-20)
            make.left.equalTo(self.view).offset(20)
        }
            
        gameMaster = GameMaster(gameType: gameType, table: self.view)
        gameMaster.delegate = self
        gameMaster.startGame()
    }
    
    @objc func hitButtonAction(_ sender:UIButton!) {
        gameMaster.inputReceived(type: .hit)
    }
    
    @objc func standButtonAction(_ sender:UIButton!) {
        gameMaster.inputReceived(type: .stand)
    }
    
    @objc func splitButtonAction(_ sender:UIButton!) {
        gameMaster.inputReceived(type: .split)
    }
    
    @objc func doubleButtonAction(_ sender:UIButton!) {
        gameMaster.inputReceived(type: .double)
    }
    
    @objc func surrenderButtonAction(_ sender:UIButton!) {
        gameMaster.inputReceived(type: .surrender)
    }
    
    @objc func homeButtonAction(_ sender:UIButton!) {
        // block the CardCounter from counting any cards that are on animation delay?
        gameMaster.returnBetsToPlayer()
        dismiss(animated: true, completion: nil)
    }
    
    func makeButton(title: String) -> UIButton {
        let button = UIButton()//frame: CGRect(x: view.frame.width - buttonWidth, y: buttonY, width: buttonWidth, height: buttonHeight))
        button.backgroundColor = .systemBlue
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        return button
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if gameType == .runningCount { return }
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
                
//                self.view.snp.makeConstraints { make in
//                    make.top
//                }
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if gameType == .runningCount { return }
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

// MARK: - GameViewDelegate

extension GameViewController: GameViewDelegate {
    func showPlaceBetView() {
        let vc = UIViewController()
        vc.view.backgroundColor = .black.withAlphaComponent(0.8)
        let placeBetView = PlaceBetView()
        placeBetView.discardTray.delegate = self
        vc.view.addSubview(placeBetView)
        vc.view.addSubview(placeBetView.discardTray)
        //placeBetView.discardTray.updateViews()
        placeBetView.snp.makeConstraints { (make) in
            make.center.equalTo(vc.view.center)
            make.width.equalTo(350)
            make.height.equalTo(350)
        }
        
        placeBetView.dealHandler = { betAmount in
            self.dismiss(animated: true) {
                self.gameMaster.playerBet(amount: betAmount)
            }
        }
        placeBetView.exitGameHandler = {
            self.dismiss(animated: false) {
                self.dismiss(animated: true)
            }
        }
       
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    func showToast(message: String) {
        if gameType == .runningCount  { return }
        Toast.show(message: message, controller: self)
    }
    
    func playerInput(enabled value: Bool) {
        hitButton.isEnabled = value
        standButton.isEnabled = value
        splitButton.isEnabled = value
        doubleButton.isEnabled = value
        surrenderButton.isEnabled = value
        
        if value == true {
            splitButton.isEnabled = gameMaster.canSplit
            doubleButton.isEnabled = gameMaster.canDouble
            surrenderButton.isEnabled = gameMaster.canSurrender
        }
    }
    
    func dismissViewController(completion: (() -> Void)? = nil) {
        self.dismiss(animated: false)
        completion?()
    }
    
    func presentBasicStrategyFeedbackView(isCorrect: Bool, playerAction: String, correctAction: String, completion: @escaping () -> Void) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "BasicStrategyViewController") as! BasicStrategyViewController
        vc.delegate = self
        vc.complete = {
            completion()
        }
        vc.isCorrect = isCorrect
        vc.playerAction = playerAction
        vc.correctAction = correctAction
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    func alertMistake(message: String, completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "Strategy Mistake", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .destructive, handler: { _ in completion(false) }))
        alert.addAction(UIAlertAction(title: "Fix", style: .cancel, handler: { _ in completion(true) }))
        self.present(alert, animated: true)
    }
    
    func present(_ vc: UIViewController) {
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
}
