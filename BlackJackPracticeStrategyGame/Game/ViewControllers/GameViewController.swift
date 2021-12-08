import UIKit
import SnapKit
import SideMenu

class GameViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func adjustmentsForScaleChange() {
//        stackView.snp.updateConstraints { (make) in
//            var height = Settings.shared.cardSize * 1.2
//            if Settings.shared.surrender {
//                height = Settings.shared.cardSize * 1.5
//            }
//            make.height.equalTo(height)
//            let width = Settings.shared.cardWidth
//            make.width.equalTo(width)
//            make.centerY.equalTo(self.view)
//            make.right.equalTo(self.view)
//        }
        
        //self.stackView.setNeedsLayout()
        //self.stackView.setNeedsDisplay()
        
        //self.view.setNeedsLayout()
        //self.view.setNeedsDisplay()
        //self.view.layoutIfNeeded()
        
        let height = 20 * Settings.shared.cardSizeFactor / 5
        let width = height
        let offset = -30 //* Settings.shared.cardSizeFactor / 4
        gearButton.snp.updateConstraints { (make) in
            make.height.equalTo(height)
            make.width.equalTo(width)
            make.bottom.equalTo(self.view).offset(offset)
            make.right.equalTo(self.view).offset(offset)
        }
        homeButton.snp.updateConstraints { (make) in
            make.height.equalTo(height)
            make.width.equalTo(width)
            make.bottom.equalTo(self.view).offset(offset)
            make.left.equalTo(self.view).offset(offset * -1)
        }
        
        
        
        
    }
    
    func updateForTableSettings() {
        guard stackView.superview != nil else { return }
        
        stackView.snp.removeConstraints()
        stackView.snp.makeConstraints { (make) in
            var height = Settings.shared.cardSize * 1.2
            if Settings.shared.surrender {
                height = Settings.shared.cardSize * 1.5
            }
            make.height.equalTo(height)
            let width = Settings.shared.useButtons ? Settings.shared.cardWidth : 0
            make.width.equalTo(width)
            make.centerY.equalTo(self.view)
            
            if Settings.shared.buttonsOnLeft {
                make.left.equalTo(self.view)
            } else {
                make.right.equalTo(self.view)
            }
        }
    }
    
    var gameMaster: GameMaster!
    var gameType: GameType!
    var showInputButtons: Bool {
        let gameTypes: [GameType] = [.runningCount, .runningCount_v2, .deviations, .trueCount, .deckRounding]
        return !gameTypes.contains(gameType)
    }
    
    lazy var homeButton: UIButton = {
        let button = makeButton(title: "")
        button.addTarget(self, action: #selector(homeButtonAction(_:)), for: .touchUpInside)
        button.isEnabled = true
        button.backgroundColor = .clear
        button.tintColor = .white
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 1000, weight: .bold, scale: .large)
        let image = UIImage(systemName: "arrow.backward", withConfiguration: imageConfig) //chevron.backward.circle.fill, arrow.backward.circle.fill, arrowshape.turn.up.backward.circle.fill
        button.setImage(image , for: .normal)
        
        return button
    }()
    
    lazy var gearButton: UIButton = {
        let button = makeButton(title: "")
        button.addTarget(self, action: #selector(gearButtonAction(_:)), for: .touchUpInside)
        button.isEnabled = false
        button.backgroundColor = .clear
        button.tintColor = .white
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 1000, weight: .bold, scale: .large)
        let image = UIImage(systemName: "gearshape.fill", withConfiguration: imageConfig) //gear
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
            stack.addArrangedSubview($0)
        }
        if Settings.shared.surrender {
            surrenderButton.backgroundColor = UIColor(hex: TableColor(rawValue: Settings.shared.buttonColor)!.buttonCode)
            surrenderButton.setTitleColor(.white.withAlphaComponent(0.5), for: .disabled)
            stack.addArrangedSubview(surrenderButton)
        }
        setButtonColor()
        return stack
    }()
    
    func setButtonColor() {
        [hitButton, standButton, doubleButton, splitButton, surrenderButton].forEach {
            $0.backgroundColor = UIColor(hex: TableColor(rawValue: Settings.shared.buttonColor)!.buttonCode)
            $0.setTitleColor(.white.withAlphaComponent(0.5), for: .disabled)
        }
    }
    
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
                var height = Settings.shared.cardSize * 1.2
                if Settings.shared.surrender {
                    height = Settings.shared.cardSize * 1.5
                }
                make.height.equalTo(height)
                let width = Settings.shared.cardWidth
                make.width.equalTo(width)
                make.centerY.equalTo(self.view)
                make.right.equalTo(self.view)
            }
        }
        
        super.view.addSubview(homeButton)
        let height = 20 * Settings.shared.cardSizeFactor / 5
        let width = height
        let offset = -30 //* Settings.shared.cardSizeFactor / 4
        homeButton.snp.makeConstraints { (make) in
            make.height.equalTo(height)
            make.width.equalTo(width)
            make.bottom.equalTo(self.view).offset(offset)
            make.left.equalTo(self.view).offset(offset * -1)
        }
        super.view.addSubview(gearButton)
        gearButton.snp.makeConstraints { (make) in
            make.height.equalTo(height)
            make.width.equalTo(width)
            make.bottom.equalTo(self.view).offset(offset)
            make.right.equalTo(self.view).offset(offset)
        }
            
        gameMaster = GameMaster(gameType: gameType, table: self.view)
        gameMaster.delegate = self
        gameMaster.startGame()
        
        // hit
        let hitGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleHitGesture(_:)))
        self.view.addGestureRecognizer(hitGesture)
        //gameMaster.tableView.addGestureRecognizer(hitGesture)
        
        // stand
        let standGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.handleRightOrLeftSwipe(_:)))
        standGesture.direction = .right
        self.view.addGestureRecognizer(standGesture)
        let standGesture2 = UISwipeGestureRecognizer(target: self, action: #selector(self.handleRightOrLeftSwipe(_:)))
        standGesture2.direction = .left
        self.view.addGestureRecognizer(standGesture2)
        
        // surrender
        let surrenderGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.handleUpSwipe(_:)))
        surrenderGesture.direction = .up
        self.view.addGestureRecognizer(surrenderGesture)
        
        // double
        let doubleGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleGesture(_:)))
        doubleGesture.numberOfTouchesRequired = 2
        self.view.addGestureRecognizer(doubleGesture)
        
        // split
        let splitGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.handlePinchGesture(_:)))
        self.view.addGestureRecognizer(splitGesture)
        
        updateForTableSettings()
    }
                                                        
    @objc func handlePinchGesture(_ sender: UIPinchGestureRecognizer) {
        guard Settings.shared.useGestures && splitButton.isEnabled else { return }
        
        if sender.state == .ended {
            if sender.scale > 1.5 {
                splitButton.sendActions(for: .touchUpInside)
            }
        }
    }
    
    @objc func handleHitGesture(_ sender: UITapGestureRecognizer) {
        guard Settings.shared.useGestures && hitButton.isEnabled else { return }
        hitButton.sendActions(for: .touchUpInside)
    }
    
    @objc func handleRightOrLeftSwipe(_ sender : UISwipeGestureRecognizer) {
        guard Settings.shared.useGestures && standButton.isEnabled else { return }
        if sender.state == .ended {
            standButton.sendActions(for: .touchUpInside)
        }
    }
    
    @objc func handleUpSwipe(_ sender : UISwipeGestureRecognizer) {
        guard Settings.shared.useGestures && surrenderButton.isEnabled else { return }
        if sender.state == .ended {
            surrenderButton.sendActions(for: .touchUpInside)
        }
    }
    
    @objc func handleDoubleGesture(_ sender : UISwipeGestureRecognizer) {
        guard Settings.shared.useGestures && doubleButton.isEnabled else { return }
        doubleButton.sendActions(for: .touchUpInside)
    }
    
    @objc func hitButtonAction(_ sender: UIButton!) {
        gameMaster.inputReceived(type: .hit)
    }
    
    @objc func standButtonAction(_ sender: UIButton!) {
        gameMaster.inputReceived(type: .stand)
    }
    
    @objc func splitButtonAction(_ sender: UIButton!) {
        gameMaster.inputReceived(type: .split)
    }
    
    @objc func doubleButtonAction(_ sender: UIButton!) {
        gameMaster.inputReceived(type: .double)
    }
    
    @objc func surrenderButtonAction(_ sender: UIButton!) {
        gameMaster.inputReceived(type: .surrender)
    }
    
    @objc func homeButtonAction(_ sender: UIButton!) {
        // block the CardCounter from counting any cards that are on animation delay?
        gameMaster.gameState = .tappedBackButton
        Stats.shared.printSessionStats()
        gameMaster.returnBetsToPlayer()
        
        let vc = Stats.shared.showStatsView()
       
        
        dismiss(animated: true, completion: nil)
        
        //dismissViewController(completion: {
            //self.present(vc)
        //})
        
        
    }
    
    @objc func gearButtonAction(_ sender: UIButton!) {
        
        let sVC = TableSettingsViewController()
        sVC.gameVC = self
//        let vc = SideMenuNavigationController(rootViewController: sVC)
//        let presentationStyle = SideMenuPresentationStyle.menuSlideIn
//        presentationStyle.presentingEndAlpha = 0.3
//        vc.settings.presentationStyle = presentationStyle
//        vc.settings.menuWidth = min(view.frame.width, view.frame.height) * 0.8
//        vc.settings.statusBarEndAlpha = 0 // 0 shows status bar, 1 blacks out status bar
//        vc.enableSwipeToDismissGesture = false
       self.navigationController?.pushViewController(sVC, animated: true)
        
       
        
        
        
//        adjustStackView()
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
        if gameType == .runningCount || gameType == .runningCount_v2 { return }
        
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
        if gameType == .runningCount || gameType == .runningCount_v2 { return }
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
        let placeBetView = PlaceBetView(player: gameMaster.player)
        placeBetView.vc = vc
        //placeBetView.player = gameMaster.player
        placeBetView.setupNumberOfHands()
        if gameMaster.dealer.table.discardTray.isOpen {
            placeBetView.discardTrayIsOpen = true
        }
        placeBetView.discardTray.delegate = self
        vc.view.addSubview(placeBetView)
        vc.view.addSubview(placeBetView.discardTray)
        vc.view.bringSubviewToFront(placeBetView.discardTray)
        
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
            self.homeButton.sendActions(for: .touchUpInside)
            self.dismiss(animated: false) {
                self.dismiss(animated: true)
            }
        }
       
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        if presentedViewController != nil {
            if !(presentedViewController is BasicStrategyViewController) {
                dismiss(animated: true)
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func showToast(message: String) {
        if gameType == .runningCount  || gameType == .runningCount_v2 { return }
        Toast.show(message: message, controller: self)
        Toast.show(message: message, controller: self)
    }
    
    func playerInput(enabled value: Bool) {
        gearButton.isEnabled = value
        
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
    
//    func alertMistake(message: String, completion: @escaping (Bool) -> Void) {
//        let alert = UIAlertController(title: "Strategy Mistake", message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Continue", style: .destructive, handler: { _ in completion(false) }))
//        alert.addAction(UIAlertAction(title: "Fix", style: .cancel, handler: { _ in completion(true) }))
//        self.present(alert, animated: true)
//    }
    
    func present(_ vc: UIViewController) {
        //vc.modalPresentationStyle = .overCurrentContext
        //vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
    }
    
    func enableTableSettingsButton(_ setting: Bool) {
        gearButton.isEnabled = setting
    }
}
