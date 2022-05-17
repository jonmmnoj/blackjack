//
//  MainMenuViewController.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 8/12/21.
//

import UIKit

class MainMenuViewController: UITableViewController {
    var delegate: SplitViewDelegate?
    var cellContents = MainMenuContent().contents
    var color: UIColor {
        return UIColor(hex: TableColor(rawValue: Settings.shared.tableColor)!.tableCode)!
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Settings.shared.deviceType == .phone {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        }
        
        view.backgroundColor = color
        tableView.backgroundColor = color
        tableView.rowHeight = UITableView.automaticDimension;
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        tableView.reloadData() // color might have changed
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellContents.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Logo", for: indexPath)
            cell.backgroundColor = color
            cell.contentView.backgroundColor = color
            cell.superview?.backgroundColor = color
            cell.selectedBackgroundView?.backgroundColor = color
            cell.isUserInteractionEnabled = false
            for view in cell.contentView.subviews {
                view.addShadow()
            }
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MenuTableViewCell
        let content = cellContents[indexPath.row]
        cell.customImageView.image = UIImage(named: content.imageName)?.imageWithInsets(insetDimen: 50)
        cell.label.text = content.title
        cell.detail.attributedText = content.detail
        cell.detail.sizeToFit()
        
        cell.backgroundColor = color
        cell.contentView.backgroundColor = color
        cell.superview?.backgroundColor = color
        cell.selectedBackgroundView?.backgroundColor = color
        
        cell.layoutIfNeeded()
        
        for view in cell.contentView.subviews {
            view.addShadow()
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SoundPlayer.shared.playSound(.click)
        tableView.deselectRow(at: indexPath, animated: false)
        let gameType = cellContents[indexPath.row].gameType
        Settings.shared.gameType = gameType
        
        if let delegate = self.delegate {
            delegate.gameTypeSelected(gameType)
        } else {
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
            //vc.gameType = gameType
            self.navigationController!.pushViewController(vc, animated: true)
        }
    }
}


