//
//  AppDelegate.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 28/7/24.
//

import UIKit
import Localize_Swift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let storyboard = UIStoryboard(name: "AuthScreen", bundle: nil)
        let loginViewController = storyboard.instantiateInitialViewController()
        window?.rootViewController = loginViewController
        window?.makeKeyAndVisible()
        
        let khmerLanguageCode = "km"
        if Localize.currentLanguage() != khmerLanguageCode {
            Localize.setCurrentLanguage(khmerLanguageCode)
        }
        
        UIFont.registerFont(withFilenameString: "KhmerOSBattambang-Regular.ttf", bundle: Bundle.main)
        UIFont.registerFont(withFilenameString: "KhmerOSBattambang-Bold.ttf", bundle: Bundle.main)
        
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000, vertical: 0), for: .default)
        
        return true
    }

}
