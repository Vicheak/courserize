//
//  UIColor + Ext.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 28/7/24.
//

import UIKit
import SwiftEntryKit

extension UIColor {
    
    static let mainColor = UIColor(red: 16/255, green: 67/255, blue: 159/255, alpha: 1.0)
    
    convenience init(rgb: UInt32) {
        let red = CGFloat((rgb >> 16) & 0xff) / 255.0
        let green = CGFloat((rgb >> 8) & 0xff) / 255.0
        let blue = CGFloat(rgb & 0xff) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    convenience init(rgb: UInt32, alpha: CGFloat) {
        let red = CGFloat((rgb >> 16) & 0xff) / 255.0
        let green = CGFloat((rgb >> 8) & 0xff) / 255.0
        let blue = CGFloat(rgb & 0xff) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
}

extension EKColor {
    
    static let mainColor = EKColor(red: 16/255, green: 67/255, blue: 159/255)
    
}
