//
//  AppDelegate.swift
//  BlackJackPracticeStrategyGame
//
//  Created by JON on 7/6/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UIWindowSceneDelegate {

    var window: UIWindow?
    

    
    var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .all
        } else {
            return .landscape
        }
        
        //return UIDevice.current.userInterfaceIdiom == .pad ? UIInterfaceOrientationMask.all : UIInterfaceOrientationMask.portrait
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        self.window = UIWindow(frame: UIScreen.main.bounds)
//
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//
//            let initialViewController = storyboard.instantiateViewController(withIdentifier: "SplitViewController")
//
//            self.window?.rootViewController = initialViewController
//            self.window?.makeKeyAndVisible()
//
            return true
        
        
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    var restrictRotation:UIInterfaceOrientationMask = .all
    
    var orientationLock = UIInterfaceOrientationMask.all

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        //return self.orientationLock
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            return orientationLock
        } else {
            orientationLock = .landscape
            return orientationLock
        }
    }
    
    struct AppUtility {
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.orientationLock = orientation
            }
        }

        static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
            self.lockOrientation(orientation)
            UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        }
    }


}

