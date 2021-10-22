//
//  MainMenuViewController.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 8/12/21.
//

import UIKit

class MainMenuViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Blackjack Trainer"
        view.backgroundColor = Settings.shared.defaults.tableColor
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellContent.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MenuTableViewCell
        let content = cellContent[indexPath.row]
        cell.textLabel?.text = content.title
        cell.label.text = content.title
        
        cell.detailTextLabel?.text = content.detail
        cell.imageView?.image = UIImage(named: content.imageName)
        cell.customImageView.image = UIImage(named: content.imageName)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let gameType = cellContent[indexPath.row].gameType
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        vc.gameType = gameType
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    let cellContent : [CellContent] = [
        CellContent(gameType: .freePlay, title: "Free Play", detail: "", imageName: "Image"),
        CellContent(gameType: .runningCount, title: "Running Count", detail: "", imageName: "runningCount"),
        CellContent(gameType: .basicStrategy, title: "Basic Strategy", detail: "", imageName: "basicStrategy"),
        
        CellContent(gameType: .deckRounding, title: "Deck Rounding", detail: "", imageName: "downBox"),
        CellContent(gameType: .trueCount, title: "True Count", detail: "", imageName: "divide"),
        CellContent(gameType: .deviations, title: "Deviations", detail: "", imageName: "deviation"),
        CellContent(gameType: .charts, title: "Charts", detail: "", imageName: "chart"),
        
    ]
    
    struct CellContent {
        var gameType: GameType
        var title: String
        var detail: String
        var imageName: String
    }
}
