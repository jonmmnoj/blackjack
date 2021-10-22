//
//  DiscardTrayView.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/30/21.
//

import UIKit
import SnapKit

class DiscardTrayView: UIView {

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
    var isOpen = true
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
        //self.frame = CGRect(x: 50, y: 50, width: 100, height: 600)        //self.isUserInteractionEnabled = true
        //self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        
        self.snp.makeConstraints { (make) in
            make.top.equalTo(self.superview!).offset(50)
            make.left.equalTo(self.superview!)
            make.height.equalTo(discardImageHeight + counterViewHeight + buttonHeight)
            //make.width.equalTo(self.width)
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
            make.height.equalTo(counterViewHeight)
            //make.width.equalTo(self.width)
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
            //make.top.equalTo(countView).offset(10)
            //make.height.equalTo(20)
            //make.width.equalTo(countView)
        }
        divLabel = UILabel()
        countView.addSubview(divLabel)
        divLabel.text = "Div:"
        divLabel.backgroundColor = .systemGray5
        divLabel.snp.makeConstraints { (make) in
            //make.top.equalTo(rcLabel.snp.bottom).offset(10)
            //make.height.equalTo(20)
            //make.width.equalTo(countView)
        }
        tcLabel = UILabel()
        countView.addSubview(tcLabel)
        tcLabel.text = "TC:"
        tcLabel.backgroundColor = .systemGray5
        tcLabel.snp.makeConstraints { (make) in
            //make.top.equalTo(divLabel.snp.bottom).offset(10)
            //make.height.equalTo(20)
            //make.width.equalTo(countView)
        }
        sView.addArrangedSubview(rcLabel)
        sView.addArrangedSubview(divLabel)
        sView.addArrangedSubview(tcLabel)
        
        button = UIButton()
        self.addSubview(button)
        button.backgroundColor = .systemBlue
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .large)
        image = UIImage(systemName: "line.horizontal.3", withConfiguration: imageConfig)!
        button.setImage(image, for: .normal)
        button.tintColor = .white
        //button.setTitle("OK", for: .normal)
        button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        button.isEnabled = true
        button.snp.makeConstraints { (make) in
            make.top.equalTo(countView.snp.bottom)
            make.left.right.equalTo(self)
            make.height.equalTo(buttonHeight)
            //make.width.equalTo(self.width)
        }
        self.bringSubviewToFront(button)
    }
    
    @objc func buttonAction(_ sender: UIButton!) {
        print("tap")
        let cViewHeight = isOpen ? 0 : 100
        isOpen = !isOpen
        countView.snp.updateConstraints { make in
            make.height.equalTo(cViewHeight)
        }
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.layoutIfNeeded()
          })
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView

        // Your action
        print("tap")
    }
    
}
