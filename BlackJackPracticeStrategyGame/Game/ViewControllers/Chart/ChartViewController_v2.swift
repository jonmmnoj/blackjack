//
//  ChartViewController.swift
//  BlackJackPracticeStrategyGame
//
//  Created by Jon on 12/25/21.
//

import UIKit

class ChartViewController_v2: UIViewController, UINavigationBarDelegate {
    var chartType: ChartType!
    var deviationType: DeviationType!
    var chart: Chart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chart = getChart()
       //edgesForExtendedLayout = .none
        //addNavigationBar()
        //tabBarController!.view.addSubview(view)
        if navigationController != nil {
            setupNavBar()
        }
        let buttonsView = UIScrollView()
        //buttonsView.backgroundColor = .red
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        NSLayoutConstraint.activate([
            buttonsView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            buttonsView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),//, constant: 1000),
            buttonsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),//, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)//, constant: -20)
        ])
        
        var buttons = [[UIButton]]()
        
        let chartData = chart.data[deviationType]!
        let numberOfDataRows = chartData.count
        let numberOfDataColumns = chartData[0].count
        let numberOfKeyRows = chart.key.count
        let numberOfKeyColumns = chart.key[0].count
        let numberOfColumns = chartData[0].count
        //print(tabBarController!.tabBar.frame.size.height)
        let sumOfBarHeights = UIApplication.shared.statusBarFrame.height + navigationController!.navigationBar.frame.size.height + tabBarController!.tabBar.frame.size.height
        let numberOfTotalRows = (CGFloat(numberOfDataRows) + CGFloat(numberOfKeyRows) + 1)
      //  print(numberOfTotalRows)
        var rowHeight = ((view.safeAreaLayoutGuide.layoutFrame.height - sumOfBarHeights + 20) / 16).rounded()//numberOfTotalRows).rounded()
        print(rowHeight)
        rowHeight = max(rowHeight, 30)
        
        
        let width = (view.safeAreaLayoutGuide.layoutFrame.width / CGFloat(numberOfColumns)).rounded()
        //let dealerHand = ["", "2", "3", "4", "5", "6", "7", "8", "9", "10", "A"]
        //let playerHand = ["", "17", "16", "15", "14", "13", "12", "11", "10", "9", "8"]
        
        // Chart
        for i in 0..<Int(numberOfDataRows) {
            buttons.append([])
            for j in 0..<Int(numberOfDataColumns) {
                let button = UIButton()
                //button.backgroundColor = .blue
                button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
                button.setTitle("\(chartData[i][j])", for: .normal)
                button.setTitleColor(.label, for: .normal)
                let frame = CGRect(x: Double(j) * width, y: Double(i) * rowHeight, width: width, height: rowHeight)
                button.frame = frame
                buttonsView.addSubview(button)
                buttons[i].append(button)
                if i == 0 { // dealer hand
                    button.addBorders(edges: [.right, .left, .top, .bottom], color: .black, thickness: 1)
                    button.setTitle("\(chartData[i][j])", for: .normal)
                }
                if j == 0 { // player hand
                    button.addBorders(edges: [.right, .left, .top, .bottom], color: .black, thickness: 1)
                    button.setTitle("\(chartData[i][j])", for: .normal)
                }
                if i != 0 && j != 0 { // action
                    button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
                    button.addBorders(edges: [.right, .left, .top, .bottom], color: .black, thickness: 1)
                }
                button.backgroundColor = getButtonBackgroundColor(title: button.currentTitle!)
                if j == 0 || i == 0 {
                    button.backgroundColor = .systemGray3
                }
                if chartData[i][j].contains("+") || chartData[i][j].contains("-") {
                    button.setTitleColor(.red, for: .normal)
                }
                
                let updatedStr = chartData[i][j].replacingOccurrences(of: "\\{(.*?)\\}", with: "", options: .regularExpression)
                button.setTitle(updatedStr, for: .normal)
                
                
            }
        }
        
        let startHeightKey = rowHeight * (CGFloat(numberOfDataRows) + 1)
        // Key
        for i in 0..<Int(numberOfKeyRows) {
            //buttons.append([])
            for j in 0..<Int(numberOfKeyColumns) {
                let button = UIButton()
                //button.backgroundColor = .blue
                button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
                button.setTitle("\(chart.key[i][j])", for: .normal)
                button.setTitleColor(.label, for: .normal)
                var frame = CGRect(x: Double(j) * width, y: Double(i) * rowHeight + startHeightKey, width: width, height: rowHeight)
                if j == 2 {
                    frame = CGRect(x: Double(j) * width, y: Double(i) * rowHeight + startHeightKey, width: width * 9, height: rowHeight)
                    button.contentHorizontalAlignment = .leading
                    button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
                }
                button.frame = frame
                buttonsView.addSubview(button)
                //buttons[i].append(button)
                button.setTitle("\(chart.key[i][j])", for: .normal)
                if j != 0 {
                    button.addBorders(edges: [.top, .bottom, .right], color: .black, thickness: 1)
                }
                
                if j == 0 {
                    if chartType == .soft && chart.key[i][j] == "Key"{
                        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -rowHeight, right: 0)
                        button.layer.zPosition = 1
                    }
                    button.addBorders(edges: [.right, .left], color: .black, thickness: 1)
                    if i == 0 {
                        button.addBorders(edges: [.top], color: .black, thickness: 1)
                    }
                    if i == Int(numberOfKeyRows) - 1 {
                        button.addBorders(edges: [.bottom], color: .black, thickness: 1)
                    }
                    //button.setTitle("", for: .normal)
                }
                button.backgroundColor = getButtonBackgroundColor(title: button.currentTitle!)
                if j > 1 {
                    button.backgroundColor = .secondarySystemBackground
                }
               
                if j == 0 {
                    button.backgroundColor = .systemGray3
                }
            }
        }
        
        // text area
        //let label = UILabel()
        
        let sumNumberOfRows = (numberOfDataRows + 1 + numberOfKeyRows)
        let size = CGSize(width: view.frame.width, height: (CGFloat(sumNumberOfRows) * rowHeight))
        buttonsView.contentSize = size
        
    }
    
    private func getButtonBackgroundColor(title: String) -> UIColor {
        switch title {
        case let str where str.contains("Y/N") || str.contains("Ds"): return UIColor(hex: TableColor.Green.buttonCode)!.withAlphaComponent(0.5)
        case let str where str.contains("H") || str.contains("N"): return .secondarySystemBackground
        
        
        case let str where str.contains("Y") || str.contains("D") || str.contains("SUR"): return UIColor(hex: TableColor.Green2.buttonCode)!.withAlphaComponent(0.9)
        case let str where str.contains("S"): return UIColor(hex: TableColor.Yellow.buttonCode)!.withAlphaComponent(0.9)
        

        default: return .secondarySystemBackground
        }
    }
    
    private func setupNavBar() {
        navigationItem.title = chart.title
        let backItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(backButtonTapped(_:)))
            backItem.title = "Back"
            navigationItem.leftBarButtonItem = backItem
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Start Quiz", style: .plain, target: self, action: #selector(startQuizTapped(_:)))

    }
    
    @objc func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        if Settings.shared.deviceType == .phone {
            AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        }
    }
    
    @objc func startQuizTapped(_ sender: UIButton) {
     //  print("start quiz tapped")
        // clear data
        // activate button actions
        // chnage right nav button to submit button
            // on submit check for matching button title
        // if deviation chart press and hold, show view to enter true count
        //
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
     //   print("tapped")
    }
    
    func getChart() -> Chart {
        switch chartType {
        case .pairs:
            return PairTotals()
        case .soft:
            return SoftTotals()
        case .hard:
            return HardTotals()
        case .surrender:
            return SurrenderChart_v2()
        default: return HardTotals()
        }
        //return HardTotals()
        
    }
}

protocol Chart {
    var title: String { get }
    var data: [DeviationType: [[String]]] { get }
    var key: [[String]] { get }
}

class HardTotals: Chart {
    let title = "Hard Totals"
    let data = [DeviationType.none: [["","2","3","4","5","6","7","8","9","10","A"],
                ["17","S","S","S","S","S","S","S","S","S","S"],
                ["16","S","S","S","S","S","H","H","H","H","H"],
                ["15","S","S","S","S","S","H","H","H","H","H"],
                ["14","S","S","S","S","S","H","H","H","H","H"],
                ["13","S","S","S","S","S","H","H","H","H","H"],
                ["12","H","H","S","S","S","H","H","H","H","H"],
                ["11","D","D","D","D","D","D","D","D","D","D"],
                ["10","D","D","D","D","D","D","D","D","H","H"],
                ["9","H","D","D","D","D","H","H","H","H","H"],
                ["8","H","H","H","H","H","H","H","H","H","H"]],
                DeviationType.soft17: [["","2","3","4","5","6","7","8","9","10","A"],
                            ["17","S","S","S","S","S","S","S","S","S","S"],
                            ["16","S","S","S","S","S","H","H","4+{H}","0+{H}","H"],
                            ["15","S","S","S","S","S","H","H","H","4+{H}","H"],
                            ["14","S","S","S","S","S","H","H","H","H","H"],
                            ["13","-1-{S}","S","S","S","S","H","H","H","H","H"],
                            ["12","3+{H}","2+{H}","0-{S}","S","S","H","H","H","H","H"],
                            ["11","D","D","D","D","D","D","D","D","D","1+{H}"],
                            ["10","D","D","D","D","D","D","D","D","4+{H}","4+{H}"],
                            ["9","1+","D","D","D","D","3+{H}","H","H","H","H"],
                            ["8","H","H","H","H","2+{H}","H","H","H","H","H"]],
                DeviationType.hard17: [["","2","3","4","5","6","7","8","9","10","A"],
                            ["17","S","S","S","S","S","S","S","S","S","S"],
                            ["16","S","S","S","S","S","H","H","4+{H}","0+{H}","3+{H}"],
                            ["15","S","S","S","S","S","H","H","H","4+{H}","5+{H}"],
                            ["14","S","S","S","S","S","H","H","H","H","H"],
                            ["13","-1-{S}","S","S","S","S","H","H","H","H","H"],
                            ["12","3+{H}","2+{H}","0-{S}","S","S","H","H","H","H","H"],
                            ["11","D","D","D","D","D","D","D","D","D","D"],
                            ["10","D","D","D","D","D","D","D","D","4+{H}","3+{H}"],
                            ["9","1+{H}","D","D","D","D","3+{H}","H","H","H","H"],
                            ["8","H","H","H","H","2+{H}","H","H","H","H","H"]]]
    let key = [["","H","Hit"],
               ["Key","S","Stand"],
               ["","D","Double if allowed, otherwise hit"]]
    var quizArray = [["","2","3","4","5","6","7","8","9","10","A"],
                     ["17","","","","","","","","","",""],
                     ["16","","","","","","","","","",""],
                     ["15","","","","","","","","","",""],
                     ["14","","","","","","","","","",""],
                     ["13","","","","","","","","","",""],
                     ["12","","","","","","","","","",""],
                     ["11","","","","","","","","","",""],
                     ["10","","","","","","","","","",""],
                     ["9","","","","","","","","","",""],
                     ["8","","","","","","","","","",""]]
}
class SoftTotals: Chart {
    let title = "Soft Totals"
    let data =  [DeviationType.none: [["","2","3","4","5","6","7","8","9","10","A"],
                 ["A,9","S","S","S","S","S","S","S","S","S","S"],
                 ["A,8","S","S","S","S","Ds","S","S","S","S","S"],
                 ["A,7","Ds","Ds","Ds","Ds","Ds","S","S","H","H","H"],
                 ["A,6","H","D","D","D","D","H","H","H","H","H"],
                 ["A,5","H","H","D","D","D","H","H","H","H","H"],
                 ["A,4","H","H","D","D","D","H","H","H","H","H"],
                 ["A,3","H","H","H","D","D","H","H","H","H","H"],
                 ["A,2","H","H","H","D","D","H","H","H","H","H"]],
                 DeviationType.soft17: [["","2","3","4","5","6","7","8","9","10","A"],
                              ["A,9","S","S","S","S","S","S","S","S","S","S"],
                              ["A,8","S","S","3+{S}","1+{S}","1+{S}","S","S","S","S","S"],
                              ["A,7","Ds","Ds","Ds","Ds","Ds","S","S","H","H","H"],
                              ["A,6","1+{H}","D","D","D","D","H","H","H","H","H"],
                              ["A,5","H","H","D","D","D","H","H","H","H","H"],
                              ["A,4","H","H","D","D","D","H","H","H","H","H"],
                              ["A,3","H","H","H","D","D","H","H","H","H","H"],
                              ["A,2","H","H","H","D","D","H","H","H","H","H"]],
                 DeviationType.hard17: [["","2","3","4","5","6","7","8","9","10","A"],
                              ["A,9","S","S","S","S","S","S","S","S","S","S"],
                              ["A,8","S","S","3+{S}","1+{S}","0-{Ds}","S","S","S","S","S"],
                              ["A,7","Ds","Ds","Ds","Ds","Ds","S","S","H","H","H"],
                              ["A,6","1+{H}","D","D","D","D","H","H","H","H","H"],
                              ["A,5","H","H","D","D","D","H","H","H","H","H"],
                              ["A,4","H","H","D","D","D","H","H","H","H","H"],
                              ["A,3","H","H","H","D","D","H","H","H","H","H"],
                              ["A,2","H","H","H","D","D","H","H","H","H","H"]]]
    let key = [["","H","Hit"],
               ["Key","S","Stand"],
               ["","D","Double if allowed, otherwise hit"],
               ["","Ds","Double if allowed, otherwise stand"]]
}

struct PairTotals: Chart {
    
    let title = "Pair Splitting"
    
    var data =
    [DeviationType.none:  [["","2","3","4","5","6","7","8","9","10","A"],
                           ["A,A","Y","Y","Y","Y","Y","Y","Y","Y","Y","Y"],
                           ["10,10","N","N","N","N","N","N","N","N","N","N"],
                           ["9,9","Y","Y","Y","Y","Y","N","Y","Y","N","N"],
                           ["8,8","Y","Y","Y","Y","Y","Y","Y","Y","Y","Y"],
                           ["7,7","Y","Y","Y","Y","Y","Y","N","N","N","N"],
                           ["6,6","Y/N","Y","Y","Y","Y","N","N","N","N","N"],
                           ["5,5","N","N","N","N","N","N","N","N","N","N"],
                           ["4,4","N","N","N","Y/N","Y/N","N","N","N","N","N"],
                           ["3,3","Y/N","Y/N","Y","Y","Y","Y","N","N","N","N"],
                           ["2,2","Y/N","Y/N","Y","Y","Y","Y","N","N","N","N"]],
    DeviationType.hard17: [["","2","3","4","5","6","7","8","9","10","A"],
             ["A,A","Y","Y","Y","Y","Y","Y","Y","Y","Y","Y"],
             ["10,10","N","N","6+{N}","5+{N}","4+{N}","N","N","N","N","N"],
             ["9,9","Y","Y","Y","Y","Y","N","Y","Y","N","N"],
             ["8,8","Y","Y","Y","Y","Y","Y","Y","Y","Y","Y"],
             ["7,7","Y","Y","Y","Y","Y","Y","N","N","N","N"],
             ["6,6","Y/N","Y","Y","Y","Y","N","N","N","N","N"],
             ["5,5","N","N","N","N","N","N","N","N","N","N"],
             ["4,4","N","N","N","Y/N","Y/N","N","N","N","N","N"],
             ["3,3","Y/N","Y/N","Y","Y","Y","Y","N","N","N","N"],
             ["2,2","Y/N","Y/N","Y","Y","Y","Y","N","N","N","N"]],
     DeviationType.soft17: [["","2","3","4","5","6","7","8","9","10","A"],
              ["A,A","Y","Y","Y","Y","Y","Y","Y","Y","Y","Y"],
              ["10,10","N","N","6+{N}","5+{N}","4+{N}","N","N","N","N","N"],
              ["9,9","Y","Y","Y","Y","Y","N","Y","Y","N","N"],
              ["8,8","Y","Y","Y","Y","Y","Y","Y","Y","Y","Y"],
              ["7,7","Y","Y","Y","Y","Y","Y","N","N","N","N"],
              ["6,6","Y/N","Y","Y","Y","Y","N","N","N","N","N"],
              ["5,5","N","N","N","N","N","N","N","N","N","N"],
              ["4,4","N","N","N","Y/N","Y/N","N","N","N","N","N"],
              ["3,3","Y/N","Y/N","Y","Y","Y","Y","N","N","N","N"],
              ["2,2","Y/N","Y/N","Y","Y","Y","Y","N","N","N","N"]]]
    
    let key = [["","Y","Split"],
               ["Key","Y/N","Split if Double After Split is offered, otherwise do not split"],
               ["","N","Don't Split"]]
}
class SurrenderChart_v2: Chart {
    let title = "Late Surrender"
    let data =  [DeviationType.none: [["","2","3","4","5","6","7","8","9","10","A"],
                 ["16","","","","","","","","SUR","SUR","SUR"],
                 ["15","","","","","","","","","SUR",""],
                 ["14","","","","","" ,"","","","",""]],
                 DeviationType.soft17: [["","2","3","4","5","6","7","8","9","10","A"],
                              ["16","","","","","","","4+","-1-{SUR}","SUR","SUR"],
                              ["15","","","","","","","","2+","0-{SUR}","2+"],
                              ["14","","","","","" ,"","","","",""]],
                 DeviationType.hard17: [["","2","3","4","5","6","7","8","9","10","A"],
                            ["17","","","","","","","","","","SUR"],
                            ["16","","","","","","","4+","-1-{SUR}","SUR","SUR"],
                              ["15","","","","","","","","2+","0-{SUR}","-1+"],
                              ["14","","","","","" ,"","","","",""]]]
    let key = [["Key","SUR","Surrender"]]
}

extension UIView {
    //@discardableResult
    func addBorders(edges: UIRectEdge, color: UIColor, inset: CGFloat = 0.0, thickness: CGFloat = 1.0) {//-> [UIView] {
        var borders = [UIView]()

        //@discardableResult
        func addBorder(formats: String...) {//-> UIView {
            let border = UIView(frame: .zero)
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            addSubview(border)
            addConstraints(formats.flatMap {
                NSLayoutConstraint.constraints(withVisualFormat: $0,
                                               options: [],
                                               metrics: ["inset": inset, "thickness": thickness],
                                               views: ["border": border]) })
            borders.append(border)
            //return border
        }


        if edges.contains(.top) || edges.contains(.all) {
            addBorder(formats: "V:|-0-[border(==thickness)]", "H:|-inset-[border]-inset-|")
        }

        if edges.contains(.bottom) || edges.contains(.all) {
            addBorder(formats: "V:[border(==thickness)]-0-|", "H:|-inset-[border]-inset-|")
        }

        if edges.contains(.left) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:|-0-[border(==thickness)]")
        }

        if edges.contains(.right) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:[border(==thickness)]-0-|")
        }

        //return borders
    }
}

    
