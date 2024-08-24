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
            PopUpUtil.popUp(withTitle: "Warning".localized(using: "Generals"), withMessage: alertMessage, withAlert: .warning) { }
            return false
        }
        
        return true
    }
    
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
}
