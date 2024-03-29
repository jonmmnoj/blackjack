//
//  UITextField+Extension.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 8/19/21.
//

import UIKit

extension UITextField {

func addNumericAccessory(addPlusMinus: Bool) {
    let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 100)) // need to set frame to fix layout constraint conflict 
    
    numberToolbar.barStyle = UIBarStyle.default

    var accessories : [UIBarButtonItem] = []

    if addPlusMinus {
        accessories.append(UIBarButtonItem(title: "+/-", style: UIBarButtonItem.Style.plain, target: self, action: #selector(plusMinusPressed)))
        accessories.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))   //add padding after
    }

    accessories.append(UIBarButtonItem(title: "Clear", style: UIBarButtonItem.Style.plain, target: self, action: #selector(numberPadClear)))
    accessories.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))   //add padding space
    accessories.append(UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(numberPadDone)))

    numberToolbar.items = accessories
    numberToolbar.sizeToFit()

    inputAccessoryView = numberToolbar
}

@objc func numberPadDone() {
    self.resignFirstResponder()
}

@objc func numberPadClear() {
    self.text = ""
}

@objc func plusMinusPressed() {
    guard let currentText = self.text else {
        return
    }
    if currentText.hasPrefix("-") {
        let offsetIndex = currentText.index(currentText.startIndex, offsetBy: 1)
        let substring = currentText[offsetIndex...]  //remove first character
        self.text = String(substring)
    }
    else {
        self.text = "-" + currentText
    }
}

}
