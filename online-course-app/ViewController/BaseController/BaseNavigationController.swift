//
//  BaseNavigationController.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 3/8/24.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setColor()
        NotificationCenter.default.addObserver(self, selector: #selector(setColor), name: NSNotification.Name.changeTheme, object: nil)
    }

    @objc private func setColor() {
        let theme = ThemeManager.shared.theme
        let textColor = theme.label.primaryColor
        navigationBar.barTintColor = theme.navigationBar.barTintColor
        navigationBar.tintColor = theme.navigationBar.tintColor
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: textColor]
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = theme.navigationBar.barTintColor
            appearance.titleTextAttributes = [.foregroundColor: textColor]
            appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
            appearance.backButtonAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: -1000, vertical: 0)
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
        }
    }
    
}
