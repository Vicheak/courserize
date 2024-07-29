//
//  UIFont + Ext.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 30/7/24.
//

import UIKit

extension UIFont {
    
    static func registerFont(withFilenameString filenameString: String, bundle: Bundle) {
        guard let pathForResourceString = bundle.path(forResource: filenameString, ofType: nil) else {
            return
        }
        
        guard let fontData = NSData(contentsOfFile: pathForResourceString) else {
            return
        }
        
        guard let dataProvider = CGDataProvider(data: fontData) else {
            return
        }
        
        guard let fontRef = CGFont(dataProvider) else {
            return
        }
        
        var errorRef: Unmanaged<CFError>? = nil
        if !CTFontManagerRegisterGraphicsFont(fontRef, &errorRef) {
            print("Error registering font: \(errorRef.debugDescription)")
        }
    }
    
}
