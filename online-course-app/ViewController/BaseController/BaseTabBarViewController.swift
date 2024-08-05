//
//  BaseTabBarViewController.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 5/8/24.
//

import UIKit
import Localize_Swift

class BaseTabBarViewController: UITabBarController {
    
    var navHomeViewController: BaseNavigationController!
    var navCategoryViewController: BaseNavigationController!
    var navVideoViewController: BaseNavigationController!
    var navSubscriptionViewController: BaseNavigationController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "CoreScreen", bundle: nil)
        
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        navHomeViewController = BaseNavigationController(rootViewController: homeViewController)
        navHomeViewController.tabBarItem.image = UIImage(systemName: "book.fill")
        
        let categoryViewController = storyboard.instantiateViewController(withIdentifier: "CategoryViewController")
        navCategoryViewController = BaseNavigationController(rootViewController: categoryViewController)
        navCategoryViewController.tabBarItem.image = UIImage(systemName: "list.bullet.clipboard")
        
        let videoViewController  = storyboard.instantiateViewController(withIdentifier: "VideoViewController")
        navVideoViewController = BaseNavigationController(rootViewController: videoViewController)
        navVideoViewController.tabBarItem.image = UIImage(systemName: "video.fill")
        
        let subscriptionViewController = storyboard.instantiateViewController(withIdentifier: "SubscriptionViewController")
        navSubscriptionViewController = BaseNavigationController(rootViewController: subscriptionViewController)
        navSubscriptionViewController.tabBarItem.image = UIImage(systemName: "purchased.circle")
        
        setViewControllers([navHomeViewController, navCategoryViewController, navVideoViewController, navSubscriptionViewController], animated: true)
        selectedViewController = navHomeViewController
        modalPresentationStyle = .fullScreen
        modalTransitionStyle = .coverVertical
        
        self.setText()
        
        self.setColor()
        NotificationCenter.default.addObserver(self, selector: #selector(setColor), name: NSNotification.Name.changeTheme, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc private func setText(){
        navHomeViewController.tabBarItem.title = "Course".localized(using: "Generals")
        navCategoryViewController.tabBarItem.title = "Category".localized(using: "Generals")
        navVideoViewController.tabBarItem.title = "Video".localized(using: "Generals")
        navSubscriptionViewController.tabBarItem.title = "Subscription".localized(using: "Generals")
    }
    
    @objc private func setColor() {
        let theme = ThemeManager.shared.theme
        tabBar.backgroundColor = theme.tabBar.barTintColor
        tabBar.barTintColor = theme.tabBar.barTintColor
        tabBar.tintColor = theme.tabBar.tintColor
        
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = theme.tabBar.barTintColor
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }

}
