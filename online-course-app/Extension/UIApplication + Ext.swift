//
//  UIApplication + Ext.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 30/7/24.
//

import UIKit

extension UIApplication {
    
    func showLoginViewController() {
        let storyboard = UIStoryboard(name: "AuthScreen", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        setRootViewController(loginViewController)
    }
    
    func setRootViewController(_ viewController: UIViewController, animated: Bool = true) {
        guard let window = self.windows.first else { return }
        
        if animated {
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = .reveal
            transition.subtype = .fromBottom
            window.layer.add(transition, forKey: kCATransition)
        }
        
        window.rootViewController = viewController
    }
    
    func showPresent(viewController: UIViewController, animation: Bool) {
        guard let window = AppDelegate.shared.window else { return }
        window.setRootViewControllerWithPresentation(viewController, animated: animation)
    }
    
}
