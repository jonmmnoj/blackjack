//
//  PopUpViewController.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 8/2/21.
//

import UIKit

class PopUpViewController: UIViewController {

    var setupContentView: ((UIView) -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        self.setupContentView(self.view)
        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
