
import UIKit
import SwiftGridView
import PopupDialog
import SimpleAnimation

class ChartViewController: UIViewController, PrettyDataSourceProtocol {
    var chart: ChartProtocol!
    var orginalChart: ChartProtocol?
    @IBOutlet var navBar: UINavigationBar!

    var gridDataSource = PrettyDataSource()
    var gridDelegate = PrettyDelegate()
    
    @IBOutlet weak var prettyGridView: SwiftGridView!
    
    // MARK: - PrettyDataSourceDelegate
    //var chart: ChartProtocol = FillInChart(chart: SoftTotalsChart())
    //var chart: ChartProtocol = SoftTotalsChart()
    //var chart: ChartProtocol = PairSplittingChart()
    //var chart: ChartProtocol = SurrenderChart()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("chart vc will disappear")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeRight, andRotateTo: UIInterfaceOrientation.landscapeRight)
        
        addNavButtons()
        prettyGridView.superview?.slideIn(from: .bottom, duration: 0.6, completion: {_ in
            //self.prettyGridView.superview?.slideOut(to: .top, duration: 5)
            //print("\(self.prettyGridView.superview)")
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.topItem?.title = "Basic Strategy"
        
        
        //let value = UIInterfaceOrientation.landscapeRight.rawValue
        //UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight, forKey: "orientation")
        //UIViewController.attemptRotationToDeviceOrientation()
        //
        
        self.prettyGridView.register(UINib(nibName: "PrettyHeaderView", bundle:nil), forSupplementaryViewOfKind: SwiftGridElementKindHeader, withReuseIdentifier: PrettyHeaderView.reuseIdentifier())
        self.prettyGridView.register(UINib(nibName: "PrettyHeaderView", bundle:nil), forSupplementaryViewOfKind: SwiftGridElementKindGroupedHeader, withReuseIdentifier: PrettyHeaderView.reuseIdentifier())
        self.prettyGridView.register(UINib(nibName: "PrettyRowCell", bundle:nil), forCellWithReuseIdentifier: PrettyRowCell.reuseIdentifier())
        
        self.prettyGridView.delegate = self.gridDelegate
        self.prettyGridView.dataSource = self.gridDataSource
        self.gridDataSource.delegate = self
        
        
    }

    private func animateGridViewQuiz() {
        prettyGridView.superview?.slideOut(to: .right, duration: 0.6, completion: {_ in
            self.prettyGridView.reloadData()
            //self.prettyGridView.collectionView.scrollToItem(at: IndexPath(forSGRow: 0, atColumn: 0, inSection: 0), at: .top, animated: false)
            self.prettyGridView.setContentOffset(CGPoint.zero, animated: false)
            
            self.prettyGridView.superview?.slideIn(from: .bottom, duration: 0.6)
        })
    }
    
    @objc private func quizButtonTouchUpInside() {
        let fillInChart = FillInChart(chartModel: self.chart.copy())
        self.orginalChart = chart
        self.chart = fillInChart
        animateGridViewQuiz()
        tabBarItems(enable: false)
        navBar.topItem?.rightBarButtonItems = [UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(submitButtonTouchUpInside))]
    }
    
    @objc private func submitButtonTouchUpInside() {
        let title = (chart as! QuizProtocol).compare() ? "Pass" : "Fail"
        tabBarItems(enable: true)
       
        let message = "This is the message section of the popup dialog default view"
//        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "tenor", withExtension: "gif")!)
            //let image = UIImage.gifImageWithData(imageData!)

        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: nil)
        popup.transitionStyle = .bounceUp
        let buttonThree = DefaultButton(title: "Dismiss", height: 60, action: { [self] () in
            addNavButtons()
            chart = orginalChart!
            //prettyGridView.reloadData()
            //prettyGridView.superview?.slideIn(from: .bottom, duration: 1)
            
            prettyGridView.superview?.slideOut(to: .bottom, duration: 0.6, completion: {_ in
                self.prettyGridView.reloadData()
                //self.prettyGridView.collectionView.scrollToItem(at: IndexPath(forSGRow: 0, atColumn: 0, inSection: 0), at: .top, animated: false)
                self.prettyGridView.setContentOffset(CGPoint.zero, animated: false)
                
                self.prettyGridView.superview?.slideIn(from: .right, duration: 0.6)
            })
            
            print("finish quiz")
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
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }
    
    @IBAction func startQuizAction(_ sender: Any) {
        
        quizButtonTouchUpInside()
    }
}

