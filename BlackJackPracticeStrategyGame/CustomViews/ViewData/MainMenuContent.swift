//
//  MainMenuContent.swift
//  BlackJackPracticeStrategyGame
//
//  Created by Jon on 11/8/21.
//

import Foundation
import UIKit

class MainMenuContent {
    var contents : [MainMenuCellContent] = []
    
    init() {
        createCellContents()
    }
    
    private func createCellContents() {
        contents = [
            MainMenuCellContent(
                gameType: .freePlay,
                title: "logo",
                detail: getAttrString(["this should not be visible"]),
                imageName: "Image"),
            
            MainMenuCellContent(
                gameType: .freePlay,
                title: "Free Play",
                detail: getAttrString(["Simulate a casino game.", "Feedback on play errors. Perfect counting skills.", "Customization for table rules, and skill level."]),
                imageName: "Image"),
            
            MainMenuCellContent(
                gameType: .basicStrategy,
                title: "Basic Strategy",
                detail: getAttrString(["Drill basic strategy knowledge.", "Improve basic strategy accuracy and speed.", "Customize table rules, hand type, and number of cards dealt."]),
                imageName: "basicStrategy"),
            
            MainMenuCellContent(
                gameType: .runningCount_v2,
                title: "Running Count #1",
                detail: getAttrString(["Keep the running count", "Improve counting accuracy and speed", "Customize level of difficulty"]),
                imageName: "countdown"),
            
            MainMenuCellContent(
                gameType: .runningCount,
                title: "Running Count #2",
                detail: getAttrString(["Keep the running count during an automated game simulator.", "Improve running count accuracy and speed.", "Customize deal speed."]),
                imageName: "runCount"),
            
            MainMenuCellContent(
                gameType: .deckRounding,
                title: "Deck Estimation",
                detail: getAttrString(["Drill decks remaining in the discard tray.", "Improve estimation accuracy and speed.", "Customize to skill level."]),
                imageName: "downBox"),
            
            MainMenuCellContent(
                gameType: .trueCount,
                title: "True Count Conversion",
                detail: getAttrString(["Drill deck estimation and true count conversion.", "Improve true count conversion accuracy and speed.", "Customize to skill level."]),
                imageName: "divide"),
            
            MainMenuCellContent(
                gameType: .deviations,
                title: "Deviations",
                detail: getAttrString(["Drill deviations on basic strategy.", "Improve deviation accuracy and speed.", "Customize table rules, hand type, and number of cards dealt."]),
                imageName: "deviation"),
            
            MainMenuCellContent(
                gameType: .charts,
                title: "Charts",
                detail: getAttrString(["Review charts on basic strategy, hard 17, soft 17, and devations.", "Fill-in chart quizes with automated feedback on errors."]),
                imageName: "chart"),
            
    //        CellContent(
    //            gameType: .stats,
    //            title: "Stats",
    //            detail: "Review your progress and level of accuracy.",
    //            imageName: "stats"),
        ]
    }
    
    private func getAttrString(_ strings: [String]) -> NSMutableAttributedString {
        let fullAttributedString = NSMutableAttributedString(string: "")
        for string: String in strings {
            let bulletPoint: String = "\u{2022}"
            let formattedString: String = "\(bulletPoint) \(string)\n"
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: formattedString)
            let paragraphStyle = createParagraphAttribute()
            attributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, attributedString.length))
            fullAttributedString.append(attributedString)
        }
        return fullAttributedString
    }
    
    private func createParagraphAttribute() ->NSParagraphStyle {
        var paragraphStyle: NSMutableParagraphStyle
        paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: 15, options: NSDictionary() as! [NSTextTab.OptionKey : AnyObject])]
        paragraphStyle.defaultTabInterval = 15
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.headIndent = 15
        return paragraphStyle
    }
}

struct MainMenuCellContent {
    var gameType: GameType
    var title: String
    var detail: NSMutableAttributedString
    var imageName: String
}


