//
//  PasswordTextFied.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 5/8/24.
//

import UIKit

@available(iOS 13.0, *)
@available(iOS 13.0, *)
class PasswordTextFieldManager  {
    
    var passwordTextField: UITextField
    
    let eyeShowIcon = UIImage(systemName: "eye")
    let eyeHideIcon = UIImage(systemName: "eye.slash")
    
    lazy var eyeToggleButton = {
        let button = UIButton(type: .custom)
        button.setImage(eyeShowIcon, for: .normal)
        button.contentMode = .scaleAspectFit
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.imageEdgeInsets = UIEdgeInsets(top: 3, left: 0, bottom: 3, right: 5)
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        return button
    }()
    
    init(passwordTextField: UITextField) {
        self.passwordTextField = passwordTextField
        self.setUp()
    }
    
    func setUp(){
        passwordTextField.layer.cornerRadius = 5
        passwordTextField.rightView = eyeToggleButton
        passwordTextField.rightViewMode = .always
        eyeToggleButton.addTarget(self, action: #selector(togglePasswordShow), for: .touchUpInside)
        
        self.setColor()
        NotificationCenter.default.addObserver(self, selector: #selector(setColor), name: .changeTheme, object: nil)
    }
    
    @objc func togglePasswordShow(){
        eyeToggleButton.setImage(passwordTextField.isSecureTextEntry ? eyeHideIcon : eyeShowIcon, for: .normal)
        passwordTextField.isSecureTextEntry.toggle()
    }
    
    
    @objc func setColor() {
        let theme = ThemeManager.shared.theme
        passwordTextField.backgroundColor = theme.textField.backgroundColor
        passwordTextField.textColor = theme.label.primaryColor
        eyeToggleButton.tintColor = theme.label.primaryColor
    }
    
}
