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
        
        if #available(iOS 13.0, *) {
            self.setUpThemeMode()
            NotificationCenter.default.addObserver(self, selector: #selector(changeSystemInterfaceStyle), name: .changeTheme, object: nil)
        }

        self.setUpLanguage()
        self.registerFont()
        
        let isLogin = UserDefaults.standard.bool(forKey: "isLogin")
        if isLogin {
            let tabBarController = BaseTabBarViewController()
            window?.rootViewController = tabBarController
        } else {
            UIApplication.shared.showLoginViewController()
        }
    
        return true
    }
    
    @available(iOS 13.0, *)
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
    
    @available(iOS 13.0, *)
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
    
    func applicationWillTerminate(_ application: UIApplication) {
        //remove all files from tmp directory
        FileUtil.deleteAllTmpFile()
    }

}
