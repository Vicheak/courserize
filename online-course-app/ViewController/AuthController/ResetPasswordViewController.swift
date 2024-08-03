//
//  ResetPasswordViewController.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 28/7/24.
//

import UIKit
import Localize_Swift

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    @IBOutlet weak var eyeToggleButton: UIButton!
    @IBOutlet weak var eyeToggleConfirmationButton: UIButton!
    @IBOutlet weak var resetPasswordButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var gesture: UITapGestureRecognizer!
    @IBOutlet weak var verifyEmailLabel: UILabel!
    @IBOutlet weak var passwordInnerView: UIView!
    @IBOutlet weak var passwordConfirmInnerView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    var keyboardUtil: KeyboardUtil!
    
    let eyeShowIcon = UIImage(named: "eye-show-icon")!
    let eyeHideIcon = UIImage(named: "eye-hide-icon")!
    
    var email: String!
    var passwordToken: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        
        self.setText()
        
        emailTextField.text = email

        keyboardUtil = KeyboardUtil(view: view, bottomConstraint: bottomConstraint)
        
        passwordTextField.delegate = self
        passwordConfirmationTextField.delegate = self
        
        gesture.addTarget(self, action: #selector(tapGestureRecognizerTapped))
        eyeToggleButton.addTarget(self, action: #selector(togglePasswordShow), for: .touchUpInside)
        eyeToggleConfirmationButton.addTarget(self, action: #selector(togglePasswordConfirmShow), for: .touchUpInside)
        resetPasswordButton.addTarget(self, action: #selector(resetPasswordButtonTapped), for: .touchUpInside)
        
        self.setColor()
        NotificationCenter.default.addObserver(self, selector: #selector(setColor), name: .changeTheme, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc func setText(){
        titleLabel.text = "Reset Account Password".localized(using: "ScreenTitles")
        verifyEmailLabel.text = "Please verify your email".localized(using: "InputFields")
        emailTextField.placeholder = "Email".localized(using: "InputFields")
        passwordTextField.placeholder = "Enter password".localized(using: "InputFields")
        passwordConfirmationTextField.placeholder = "Enter password confirmation".localized(using: "InputFields")
        resetPasswordButton.setTitle("Confirm".localized(using: "ButtonTitles"), for: .normal)
    }
    
    func setUpViews(){
        titleLabel.font = UIFont(name: "KhmerOSBattambang-Bold", size: 24)
        verifyEmailLabel.font = UIFont(name: "KhmerOSBattambang-Regular", size: 16)
        emailTextField.font = UIFont(name: "KhmerOSBattambang-Regular", size: 14)
        passwordTextField.font = UIFont(name: "KhmerOSBattambang-Regular", size: 14)
        passwordConfirmationTextField.font = UIFont(name: "KhmerOSBattambang-Regular", size: 14)
        resetPasswordButton.titleLabel?.font = UIFont(name: "KhmerOSBattambang-Regular", size: 14)
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        emailTextField.isEnabled = false
        passwordTextField.layer.cornerRadius = 5
        passwordConfirmationTextField.layer.cornerRadius = 5
        resetPasswordButton.layer.cornerRadius = 5
    }
    
    @objc func setColor() {
        let theme = ThemeManager.shared.theme
        view.backgroundColor = theme.view.backgroundColor
        containerView.backgroundColor = theme.view.backgroundColor
        passwordInnerView.backgroundColor = theme.view.backgroundColor
        passwordConfirmInnerView.backgroundColor = theme.view.backgroundColor
        titleLabel.textColor = theme.label.primaryColor
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: theme.textField.placeholderColor
        ]
        emailTextField.backgroundColor = theme.textField.backgroundColor
        emailTextField.textColor = theme.label.primaryColor
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Enter your email".localized(using: "InputFields"), attributes: attributes)
        passwordTextField.backgroundColor = theme.textField.backgroundColor
        passwordTextField.textColor = theme.label.primaryColor
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Enter password".localized(using: "InputFields"), attributes: attributes)
        passwordConfirmationTextField.backgroundColor = theme.textField.backgroundColor
        passwordConfirmationTextField.textColor = theme.label.primaryColor
        passwordConfirmationTextField.attributedPlaceholder = NSAttributedString(string: "Enter password confirmation".localized(using: "InputFields"), attributes: attributes)
        eyeToggleButton.tintColor = theme.label.primaryColor
        eyeToggleConfirmationButton.tintColor = theme.label.primaryColor
        verifyEmailLabel.textColor = theme.label.primaryColor
        resetPasswordButton.setTitleColor(theme.label.primaryColor, for: .normal)
    }
    
    @objc func tapGestureRecognizerTapped(sender: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func togglePasswordShow(){
        eyeToggleButton.setImage(passwordTextField.isSecureTextEntry ? eyeHideIcon : eyeShowIcon, for: .normal)
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
    
    @objc func togglePasswordConfirmShow(){
        eyeToggleConfirmationButton.setImage(passwordConfirmationTextField.isSecureTextEntry ? eyeHideIcon : eyeShowIcon, for: .normal)
        passwordConfirmationTextField.isSecureTextEntry = !passwordConfirmationTextField.isSecureTextEntry
    }
    
    @objc func resetPasswordButtonTapped(){
        let password = passwordTextField.text ?? ""
        let passwordConfirmation = passwordConfirmationTextField.text ?? ""
        
        if DataValidation.validateRequired(field: password, fieldName: "Password") &&
            DataValidation.validateRequired(field: passwordConfirmation, fieldName: "Password Confirmation"){
            if password.count < 8 {
                PopUpUtil.popUp(withTitle: "Warning".localized(using: "Generals"), withMessage: "The password must be at least 8 characters!", withAlert: .warning) {}
                return
            }
            if password != passwordConfirmation {
                PopUpUtil.popUp(withTitle: "Warning".localized(using: "Generals"), withMessage: "The password confirmation does not match", withAlert: .warning) {}
                return
            }
            
            let alertController = LoadingViewController()
            present(alertController, animated: true) {
                AuthAPIService.shared.resetPassword(email: self.email, token: self.passwordToken, password: password) { response in
                    alertController.dismiss(animated: true) {
                        switch response {
                        case .success(let result):
                            print("Response success :", result)
                            PopUpUtil.popUp(withTitle: "Success".localized(using: "Generals"), withMessage: result.message, withAlert: .success) { [weak self] in
                                guard let self = self else { return }
                                dismiss(animated: true) {
                                    NotificationCenter.default.post(name: NSNotification.Name.dismissVerifyCodeScreen, object: nil)
                                }
                            }
                        case .failure(let error):
                            print("Response failure :", error)
                            if let errorResponseData = error as? ErrorResponseData {
                                if errorResponseData.code == 400 {
                                    PopUpUtil.popUp(withTitle: "Warning".localized(using: "Generals"), withMessage: errorResponseData.errors[0].message, withAlert: .warning) {}
                                } else {
                                    PopUpUtil.popUp(withTitle: "No Connection".localized(using: "Generals"), withMessage: errorResponseData.message, withAlert: .warning) {}
                                }
                            } else if let errorResponseMessage = error as? ErrorResponseMessage {
                                if errorResponseMessage.code == 401 {
                                    PopUpUtil.popUp(withTitle: "Warning".localized(using: "Generals"), withMessage: errorResponseMessage.errors, withAlert: .warning) {}
                                }
                            }
                        }
                    }
                }
            }
        }
    }

}

extension ResetPasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordTextField {
            passwordConfirmationTextField.becomeFirstResponder()
        } else if textField == passwordConfirmationTextField {
            view.endEditing(true)
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.transition(with: textField, duration: 0.1) {
            textField.layer.borderColor = UIColor.mainColor.cgColor
            textField.layer.borderWidth = 0.4
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.transition(with: textField, duration: 0.1) {
            textField.layer.borderColor = UIColor.clear.cgColor
            textField.layer.borderWidth = 0.0
        }
    }
    
}
