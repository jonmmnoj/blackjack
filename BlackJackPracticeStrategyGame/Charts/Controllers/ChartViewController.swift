
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
        //tabBarController?.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(submitButtonTouchUpInside))]
        
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(submitButtonTouchUpInside))]
    }
    
    @objc private func submitButtonTouchUpInside() {
        var title = (chart as! QuizProtocol).compare() ? "Pass" : "Fail"
        tabBarItems(enable: true)
       
        let message = "This is the message section of the popup dialog default view"
        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "tenor", withExtension: "gif")!)
            let image = UIImage.gifImageWithData(imageData!)

        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: image)
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
        tabBarController?.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Start Quiz", style: .plain, target: self, action: #selector(quizButtonTouchUpInside))]
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







import UIKit
import ImageIO
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}



extension UIImage {
    
    public class func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("image doesn't exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    public class func gifImageWithURL(_ gifUrl:String) -> UIImage? {
        guard let bundleURL:URL? = URL(string: gifUrl)
            else {
                print("image named \"\(gifUrl)\" doesn't exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL!) else {
            print("image named \"\(gifUrl)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    public class func gifImageWithName(_ name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
            to: CFDictionary.self)
        
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as! Double
        
        if delay < 0.1 {
            delay = 0.1
        }
        
        return delay
    }
    
    class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        if a < b {
            let c = a
            a = b
            b = c
        }
        
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b!
            } else {
                a = b
                b = rest
            }
        }
    }
    
    class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        let animation = UIImage.animatedImage(with: frames,
            duration: Double(duration) / 1000.0)
        
        return animation
    }
}

