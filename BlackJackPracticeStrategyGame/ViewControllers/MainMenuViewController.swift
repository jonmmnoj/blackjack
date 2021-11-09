//
//  MainMenuViewController.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 8/12/21.
//

import UIKit

class MainMenuViewController: UITableViewController {
    var cellContents: [MainMenuCellContent]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cellContents = MainMenuContent().contents
        //navigationItem.title = "Blackjack Trainer"
        view.backgroundColor = Settings.shared.defaults.tableColor
        tableView.rowHeight = UITableView.automaticDimension;
        tableView.estimatedRowHeight = 44.0;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
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
            cell.backgroundColor = Settings.shared.defaults.tableColor
            cell.isUserInteractionEnabled = false
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MenuTableViewCell
        let content = cellContents[indexPath.row]
        cell.customImageView.image = UIImage(named: content.imageName)?.imageWithInsets(insetDimen: 50)
        cell.label.text = content.title
        cell.detail.attributedText = content.detail
        cell.detail.sizeToFit()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let gameType = cellContents[indexPath.row].gameType
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        vc.gameType = gameType
        self.navigationController!.pushViewController(vc, animated: true)
    }
}


