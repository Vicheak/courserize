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
        
        self.setUpThemeMode()
        NotificationCenter.default.addObserver(self, selector: #selector(changeSystemInterfaceStyle), name: .changeTheme, object: nil)
            
        self.setUpLanguage()
        self.registerFont()
        
        let storyboard = UIStoryboard(name: "AuthScreen", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        let navBarController = BaseNavigationController(rootViewController: viewController)
        window?.rootViewController = navBarController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    private func setUpThemeMode(){
        if let mode = UserDefaults.standard.string(forKey: "mode") {
            if mode == Theme.day.rawValue {
                ThemeManager.shared.applyTheme(type: .day)
                window?.overrideUserInterfaceStyle = .light
            } else if mode == Theme.night.rawValue {
                ThemeManager.shared.applyTheme(type: .night)
                window?.overrideUserInterfaceStyle = .dark
            } else if mode == Theme.system.rawValue {
                ThemeManager.shared.applyTheme(type: .system)
                window?.overrideUserInterfaceStyle = .light
            }
        } else {
            ThemeManager.shared.applyTheme(type: .system)
            window?.overrideUserInterfaceStyle = .light
        }
    }
    
    @objc func changeSystemInterfaceStyle(){
        let themeType = ThemeManager.shared.themeType
        if themeType == Theme.day || themeType == Theme.system {
            window?.overrideUserInterfaceStyle = .light
        } else if themeType == Theme.night {
            window?.overrideUserInterfaceStyle = .dark
        } 
    }
    
    private func setUpLanguage(){
        if let language = UserDefaults.standard.string(forKey: "language") {
            Localize.setCurrentLanguage(language)
        } else {
            Localize.setCurrentLanguage("km")
            UserDefaults.standard.setValue("km", forKey: "language")
        }
    }
    
    private func registerFont(){
        UIFont.registerFont(withFilenameString: "KhmerOSBattambang-Regular.ttf", bundle: Bundle.main)
        UIFont.registerFont(withFilenameString: "KhmerOSBattambang-Bold.ttf", bundle: Bundle.main)
    }

}
