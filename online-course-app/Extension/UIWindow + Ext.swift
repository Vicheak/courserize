//
//  UIWindow + Ext.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 30/7/24.
//

import UIKit

extension UIWindow {
    
    func setRootViewController(_ viewController: UIViewController, completion: (() -> Void)? = nil) {
        let transition = CATransition()
        transition.type = .moveIn
        transition.subtype = .fromTop
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: .linear)
        
        self.layer.add(transition, forKey: kCATransition)
        self.rootViewController = viewController
    }
    
    func setRootViewControllerWithPresentation(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        let transition = CATransition()
        transition.type = .moveIn
        transition.subtype = .fromTop
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: .linear)
        
        self.layer.add(transition, forKey: kCATransition)
        self.rootViewController = viewController
    }
    
}

