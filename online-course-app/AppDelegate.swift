//
//  AppDelegate.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 28/7/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let storyboard = UIStoryboard(name: "AuthScreen", bundle: nil)
        let loginViewController = storyboard.instantiateInitialViewController()
        window?.rootViewController = loginViewController
        window?.makeKeyAndVisible()
        
        return true
    }

}

