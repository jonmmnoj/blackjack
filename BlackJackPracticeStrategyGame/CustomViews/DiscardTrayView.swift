//
//  DiscardTrayView.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/30/21.
//

import UIKit
import SnapKit

class DiscardTrayView: UIView {
    
    var delegate: GameViewDelegate!

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    let width = 200

    override init (frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var button: UIButton!
    var imageView: UIImageView!
    var countView: UIView!
    var hConstraint: Constraint!
    var isOpen = false
    var buttonHeight = 40
    var counterViewHeight = 100
    var discardImageHeight = 200
    
    var sView: UIStackView!
    var rcLabel: UILabel!
    var divLabel: UILabel!
    var tcLabel: UILabel!
    
    func discard() {
        CardCounter.shared.discard()
    }
    
    func updateViews() {
        imageView.image = UIImage(named: getImageName())
        rcLabel.text = String("RC: \(CardCounter.shared.runningCount)")
        divLabel.text = String("Div: \(CardCounter.shared.getNumberOfDecksInPlay())")
        tcLabel.text = String("TC: \(CardCounter.shared.getTrueCount())")
    }
    
    private func getImageName() -> String {
        let numberOfDecks = Settings.shared.numberOfDecks
        let imageName = "D\(numberOfDecks)_\(CardCounter.shared.numberOfCardsPlayed)"
        return imageName
    }
    
    override func layoutSubviews() {
        
        if button != nil { return }
        self.backgroundColor = .clear
        
        self.snp.makeConstraints { (make) in
            make.top.equalTo(self.superview!).offset(50)
            make.left.equalTo(self.superview!)
            make.height.equalTo(discardImageHeight + counterViewHeight + buttonHeight)
        }
        
        imageView = UIImageView()
        self.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        var image = UIImage(named: getImageName())!
        imageView.image = image
        imageView.image = image
        imageView.backgroundColor = .cyan
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        imageView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            let ratio = image.size.height / image.size.width
            let newHeight = Settings.shared.cardWidth * ratio
            make.width.equalTo(Settings.shared.cardWidth)
            make.height.equalTo(newHeight)
            
        }
        
        countView = UIView()
        self.addSubview(countView)
        countView.backgroundColor = .systemBackground
        countView.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom)
            make.left.right.equalTo(self)
            //make.height.equalTo(counterViewHeight)
            make.height.equalTo(0)
        }
        
        sView = UIStackView()
        countView.addSubview(sView)
        sView.axis = .vertical
        sView.spacing = 0
        sView.alignment = .fill
        sView.distribution = .fillEqually
        sView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(countView)
        }
        
        rcLabel = UILabel()
        countView.addSubview(rcLabel)
        rcLabel.text = "RC:"
        rcLabel.backgroundColor = .systemGray5
        rcLabel.snp.makeConstraints { (make) in
           
        }
        divLabel = UILabel()
        countView.addSubview(divLabel)
        divLabel.text = "Div:"
        divLabel.backgroundColor = .systemGray5
        divLabel.snp.makeConstraints { (make) in
           
        }
        tcLabel = UILabel()
        countView.addSubview(tcLabel)
        tcLabel.text = "TC:"
        tcLabel.backgroundColor = .systemGray5
        tcLabel.snp.makeConstraints { (make) in
            
        }
        sView.addArrangedSubview(rcLabel)
        sView.addArrangedSubview(divLabel)
        sView.addArrangedSubview(tcLabel)
        
        button = UIButton()
        self.addSubview(button)
        button.backgroundColor = Settings.shared.defaults.buttonColor//.systemBlue
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .large)
        image = UIImage(systemName: "line.horizontal.3", withConfiguration: imageConfig)!
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        button.isEnabled = true
        button.snp.makeConstraints { (make) in
            make.top.equalTo(countView.snp.bottom)
            make.left.right.equalTo(self)
            make.height.equalTo(buttonHeight)
            //make.width.equalTo(self.width)
        }
        self.bringSubviewToFront(button)
        self.updateViews()
    }
    
    @objc func buttonAction(_ sender: UIButton!) {
        isOpen = !isOpen
        let cViewHeight = isOpen ? 100 : 0
        countView.snp.updateConstraints { make in
            make.height.equalTo(cViewHeight)
        }
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.layoutIfNeeded()
          })
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        //let tappedImageView = tapGestureRecognizer.view as! UIImageView

        // Your action
        print("tap")
        
        let vc = UIViewController()
        vc.view.backgroundColor = .black.withAlphaComponent(0.8)
        
        let imageView = UIImageView()
        vc.view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: getImageName())!
        imageView.image = image
        imageView.backgroundColor = .cyan
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissImageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        imageView.snp.makeConstraints { (make) in
            make.center.equalTo(vc.view.center)
            make.width.equalTo(Settings.shared.cardWidth * 2.5)
            let ratio = image.size.height / image.size.width
            let newHeight = Settings.shared.cardWidth * 2.5 * ratio
            make.height.equalTo(newHeight)
        }
        
        let v = self.findViewController()!
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        v.present(vc, animated: true)
    }
    
    @objc func dismissImageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let v = self.findViewController()!
        v.dismiss(animated: true)
    }
}


extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}
