import UIKit

class ViewController: UIViewController, GameMasterDelegate {
    func playerInput(enabled value: Bool) {
        hitButton.isEnabled = value
        standButton.isEnabled = value
        splitButton.isEnabled = value
        doubleButton.isEnabled = value
    }

    var gameMaster: GameMaster!
    var hitButton: UIButton!
    var standButton: UIButton!
    var splitButton: UIButton!
    var doubleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButtons()

        gameMaster = GameMaster(table: self.view)
        gameMaster.delegate = self
        gameMaster.startGame()
    }
    
    func addButtons() {
        hitButton = UIButton(frame: CGRect(x: 10, y: view.frame.height - 60, width: 60, height: 30))
        hitButton.backgroundColor = .systemBlue
        hitButton.setTitle("Hit", for: .normal)
        hitButton.setTitleColor(.white, for: .normal)
        hitButton.addTarget(self, action: #selector(hitButtonAction(_:)), for: .touchUpInside)
        hitButton.isEnabled = false

        super.view.addSubview(hitButton)
        
        standButton = UIButton(frame: CGRect(x: 80, y: view.frame.height - 60, width: 60, height: 30))
        standButton.backgroundColor = .systemBlue
        standButton.setTitle("Stand", for: .normal)
        standButton.setTitleColor(.white, for: .normal)
        standButton.addTarget(self, action: #selector(standButtonAction(_:)), for: .touchUpInside)
        standButton.isEnabled = false

        super.view.addSubview(standButton)
        
        splitButton = UIButton(frame: CGRect(x: 80 + 70, y: view.frame.height - 60, width: 60, height: 30))
        splitButton.backgroundColor = .systemBlue
        splitButton.setTitle("Split", for: .normal)
        splitButton.setTitleColor(.white, for: .normal)
        splitButton.addTarget(self, action: #selector(splitButtonAction(_:)), for: .touchUpInside)
        splitButton.isEnabled = false

        super.view.addSubview(splitButton)
        
        doubleButton = UIButton(frame: CGRect(x: 80 + 140, y: view.frame.height - 60, width: 60, height: 30))
        doubleButton.backgroundColor = .systemBlue
        doubleButton.setTitle("Double", for: .normal)
        doubleButton.setTitleColor(.white, for: .normal)
        doubleButton.addTarget(self, action: #selector(doubleButtonAction(_:)), for: .touchUpInside)
        doubleButton.isEnabled = false

        super.view.addSubview(doubleButton)
    }
    
    @objc func hitButtonAction(_ sender:UIButton!) {
        gameMaster.playerHits()
    }
    
    @objc func standButtonAction(_ sender:UIButton!) {
        gameMaster.playerStands()
    }
    
    @objc func splitButtonAction(_ sender:UIButton!) {
        gameMaster.playerSplits()
    }
    
    @objc func doubleButtonAction(_ sender:UIButton!) {
        gameMaster.playerDoubles()
    }
}
