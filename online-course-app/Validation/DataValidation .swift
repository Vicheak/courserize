//
//  DataValidation .swift
//  online-course-app
//
//  Created by @suonvicheakdev on 30/7/24.
//

import UIKit

class DataValidation {
    
    static func validateRequired(field: String, fieldName: String, message: String = "This field is required!") -> Bool {
        var alertMessage = message
        
        if field.isEmpty {
            if !fieldName.isEmpty {
                alertMessage = "\(fieldName) is required!"
            }
            PopUpUtil.popUp(withTitle: "Warning".localized(using: "Generals"), withMessage: alertMessage, withAlert: .warning) {
                print("testing")
            }
            return false
        }
        
        return true
    }
    
}
