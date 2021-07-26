import UIKit

class GameViewController: UIViewController {
    var gameMaster: GameMaster!
    var gameType: GameType!
    
    lazy var hitButton: UIButton = {
        let button = makeButton(title: "HIT")
        button.addTarget(self, action: #selector(hitButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var standButton: UIButton = {
        let button = makeButton(title: "STAND")
        button.addTarget(self, action: #selector(standButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var splitButton: UIButton = {
        let button = makeButton(title: "SPLIT")
        button.addTarget(self, action: #selector(splitButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var doubleButton: UIButton = {
        let button = makeButton(title: "DOUBLE")
        button.addTarget(self, action: #selector(doubleButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButtons()
        gameMaster = GameMaster(gameType: gameType, table: self.view)
        gameMaster.delegate = self
        gameMaster.navBarHeight = navigationController?.navigationBar.frame.height
        gameMaster.startGame()
    }
    
    func addButtons() {
        super.view.addSubview(hitButton)
        super.view.addSubview(standButton)
        super.view.addSubview(doubleButton)
        super.view.addSubview(splitButton)
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
    
    let buttonHeight: CGFloat = 50
    let buttonWidth: CGFloat = 100
    var yAdjustment: CGFloat = 50 + 10
    var buttonY: CGFloat {
        let y = view.frame.height / 1.5 - yAdjustment
        yAdjustment += 50 + 10
        return y
    }
    func makeButton(title: String) -> UIButton {
        let button = UIButton(frame: CGRect(x: view.frame.width - buttonWidth, y: buttonY, width: buttonWidth, height: buttonHeight))
        button.backgroundColor = .systemBlue
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        return button
    }
}

extension GameViewController {
    
}

// MARK: - GameViewDelegate

extension GameViewController: GameViewDelegate {
    func playerInput(enabled value: Bool) {
        hitButton.isEnabled = value
        standButton.isEnabled = value
        splitButton.isEnabled = value
        doubleButton.isEnabled = value
    }
    
    func presentCountInputView(countMaster: CountMaster, callback: (Int) -> Void) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "CountViewController") as! CountViewController
        vc.countMaster = countMaster
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
        callback(99)
    }
    
    func dismissViewController(completion: (() -> Void)? = nil) {
        self.dismiss(animated: false) {
            print("dismissed vc")
        }
        completion?()
    }
    
    func presentBasicStrategyFeedbackView(playerAction: PlayerAction, correctAction: PlayerAction) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "BasicStrategyViewController") as! BasicStrategyViewController
        vc.delegate = self
        vc.complete = {
            //self.gameMaster.prepareForNewRound()
            self.gameMaster.discardAllHands()
        }
        vc.playerAction = playerAction
        vc.correctAction = correctAction
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
        
    }
}
