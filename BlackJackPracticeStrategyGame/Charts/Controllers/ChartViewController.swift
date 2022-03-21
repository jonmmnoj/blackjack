
import UIKit
import SwiftGridView
import PopupDialog
import SimpleAnimation

class ChartViewController: UIViewController, PrettyDataSourceProtocol {
    var chart: ChartProtocol!
    var orginalChart: ChartProtocol?
    @IBOutlet var navBar: UINavigationBar!

    var gridDataSource = PrettyDataSource()
    //var gridDataSource: PrettyDataSource!
    var gridDelegate = PrettyDelegate()
    //var gridDelegate: PrettyDelegate!
    
    @IBOutlet weak var prettyGridView: SwiftGridView!
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //print("chart vc will disappear")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeRight, andRotateTo: UIInterfaceOrientation.landscapeRight)
        
        addNavButtons()
        //prettyGridView.superview?.slideIn(from: .bottom, duration: 0.6, completion: {_ in
            //self.prettyGridView.superview?.slideOut(to: .top, duration: 5)
            //print("\(self.prettyGridView.superview)")
        //})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.topItem?.title = "Basic Strategy"
        
        self.prettyGridView.register(UINib(nibName: "PrettyHeaderView", bundle:nil), forSupplementaryViewOfKind: SwiftGridElementKindHeader, withReuseIdentifier: PrettyHeaderView.reuseIdentifier())
        self.prettyGridView.register(UINib(nibName: "PrettyHeaderView", bundle:nil), forSupplementaryViewOfKind: SwiftGridElementKindGroupedHeader, withReuseIdentifier: PrettyHeaderView.reuseIdentifier())
        self.prettyGridView.register(UINib(nibName: "PrettyRowCell", bundle:nil), forCellWithReuseIdentifier: PrettyRowCell.reuseIdentifier())
        
        self.prettyGridView.delegate = self.gridDelegate
        self.prettyGridView.dataSource = self.gridDataSource
        self.gridDataSource.delegate = self
    }

    @objc private func quizButtonTouchUpInside() {
        //let fillInChart = FillInChart(chartModel: self.chart.copy())
        //self.orginalChart = self.chart.copy()//chart
        //self.chart = fillInChart
        //self.gridDataSource.delegate = self
        //self.prettyGridView.
        chart.isQuiz = true
        self.prettyGridView.reloadData()
        tabBarItems(enable: false)
        navBar.topItem?.rightBarButtonItems = [UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(submitButtonTouchUpInside))]
    }
    
    @objc private func submitButtonTouchUpInside() {
        let title = chart.compare() ? "Pass" : "Fail"
        
        tabBarItems(enable: true)
        chart.isQuiz = false
        let message = "This is the message section of the popup dialog default view"

        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: nil)
        popup.transitionStyle = .bounceUp
        let buttonThree = DefaultButton(title: "Dismiss", height: 60, action: { [self] () in
            addNavButtons()
            //chart = orginalChart!
            self.prettyGridView.reloadData()
           //print("finish quiz")
        })
        popup.addButton(buttonThree)
        self.present(popup, animated: true, completion: nil)
    }
    
    func addNavButtons() {
        navBar.topItem?.rightBarButtonItems = [UIBarButtonItem(title: "Start Quiz", style: .plain, target: self, action: #selector(quizButtonTouchUpInside))]
    }
    
    private func tabBarItems(enable setting: Bool) {
        for item in self.tabBarController?.tabBar.items! as [UITabBarItem] {
            item.isEnabled = setting
        }
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        if Settings.shared.deviceType == .phone {
            AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        }
    }
    
    @IBAction func startQuizAction(_ sender: Any) {
        
        quizButtonTouchUpInside()
    }
}

