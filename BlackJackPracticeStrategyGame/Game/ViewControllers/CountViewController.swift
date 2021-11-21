//
//  CountViewController.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/16/21.
//

import Foundation
import UIKit

//class CountViewController: UIViewController, UITextFieldDelegate, FeedbackViewDelegate {
//    
//    
//    @IBOutlet weak var decrease: UIButton!
//    @IBOutlet weak var increase: UIButton!
//    @IBOutlet weak var positiveNegative: UIButton!
//    @IBOutlet weak var submit: UIButton!
//    @IBOutlet weak var textField: UITextField!
//    @IBOutlet weak var dismiss: UIButton!
//    @IBOutlet weak var feedbackView: FeedbackView!
//    @IBOutlet weak var submitView: UIView!
//    
//    var countMaster: CountMaster!
//    
//    
//    override func viewWillAppear(_ animated: Bool) {
//        feedbackView.isHidden = true
//        feedbackView.delegate = self
//        
//        textField.text = "0"
//        
//        decrease.layer.cornerRadius = 0.5 * decrease.bounds.size.width
//        decrease.clipsToBounds = true
//        increase.layer.cornerRadius = 0.5 * decrease.bounds.size.width
//        increase.clipsToBounds = true
//        
//        textField.delegate = self
//        textField.returnKeyType = .done
//        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
//        view.addGestureRecognizer(tap) // Add gesture recognizer to background view
//    
//    }
//    
//    @objc func handleTap() {
//        textField.resignFirstResponder() // dismiss keyoard
//    }
//    
//    @IBAction func input(_ sender: UITextField) {
//        //check input for value and enable/disable submit button
//        //let s = textField.text ?? ""
//    }
//    
//    @IBAction func increase(_ sender: UIButton) {
//        var i = getInt()
//        i += 1
//        updateTextField(number: i)
//    }
//    @IBAction func decrease(_ sender: UIButton) {
//        var i = getInt()
//        i -= 1
//        updateTextField(number: i)
//    }
//    
//    func getInt() -> Int {
//        let s = textField.text ?? ""
//        let i = Int(s) ?? 0
//        return i
//    }
//    
//    func updateTextField(number: Int) {
//        textField.text = String(number)
//        submit.isEnabled = true
//    }
//    
//    @IBAction func submit(_ sender: UIButton) {
//        if textField.text == nil || textField.text == "" {
//            return
//        } else {
//            countMaster.userInput(value: getInt()) { (isCorrect, input, actual) in
//        
//                submitView.isHidden = true
//                feedbackView.updateView(isCorrect: isCorrect, input: input, actualCount: actual)
//                feedbackView.isHidden = false
//                // use correct to update view to show user if count was correct or incorrect
//                // let user dismiss view with dismiss button
//            }
//        }
//        // close view and
//    }
//    
////
////    @IBAction func dismiss(_ sender: UIButton) {
////        //countMaster.dismissCountView()
////    }
//    
//    @IBAction func postiveNegative(_ sender: UIButton) {
//        if let text = textField.text {
//            textField.text = String(Int(text)! * -1)
//        }
//    }
//    
//    func dimiss() {
////        countMaster.dismissCountView()
//    }
//}


