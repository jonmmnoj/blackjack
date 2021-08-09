//
//  MainViewController.swift
//  PrettyExample
//
//  Created by JON on 6/25/21.
//  Copyright © 2021 nlampi. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    override func viewWillDisappear(_ animated: Bool) {
        print("chart menu vc will disappear")
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("chart menu vc will appear")
        super.viewWillAppear(animated)
        //AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @IBAction func basicStrategyTouchUpInside(_ sender: UIButton) {
        pushViewController(title: "Blue", color: UIColor.blue)
    }
    
    private func pushViewController(title: String, color: UIColor) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeRight, andRotateTo: UIInterfaceOrientation.landscapeRight)
        
        let vc = storyboard?.instantiateViewController(identifier: "TabBarController") as! TabBarController
        //navigationController?.pushViewController(vc, animated: true)
        //vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
}
