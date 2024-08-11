//
//  ChangePasswordViewController.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 11/8/24.
//

import UIKit
import Localize_Swift
import KeychainSwift

@available(iOS 13.0, *)
class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordConfirmTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var gesture: UITapGestureRecognizer!
    
    var oldPasswordManager: PasswordTextFieldManager!
    var passwordManager: PasswordTextFieldManager!
    var passwordConfirmationManager: PasswordTextFieldManager!
    var keyboardUtil: KeyboardUtil!
    
    var userUuid: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        
        self.setText()

        oldPasswordManager = PasswordTextFieldManager(passwordTextField: oldPasswordTextField)
        passwordManager = PasswordTextFieldManager(passwordTextField: newPasswordTextField)
        passwordConfirmationManager = PasswordTextFieldManager(passwordTextField: newPasswordConfirmTextField)
        keyboardUtil = KeyboardUtil(view: view, bottomConstraint: bottomConstraint)
        
        oldPasswordTextField.delegate = self
        newPasswordTextField.delegate = self
        newPasswordConfirmTextField.delegate = self
        
        gesture.addTarget(self, action: #selector(tapGestureRecognizerTapped))
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        
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
        titleLabel.text = "Change Current Password".localized(using: "Generals")
        oldPasswordTextField.placeholder = "Enter your previous password".localized(using: "InputFields")
        newPasswordTextField.placeholder = "Enter your new password".localized(using: "InputFields")
        newPasswordConfirmTextField.placeholder = "Enter your new password confirmation".localized(using: "InputFields")
        confirmButton.setTitle("Confirm".localized(using: "ButtonTitles"), for: .normal)
    }
    
    func setUpViews(){
        titleLabel.font = UIFont(name: "KhmerOSBattambang-Bold", size: 24)
        oldPasswordTextField.font = UIFont(name: "KhmerOSBattambang-Regular", size: 14)
        newPasswordTextField.font = UIFont(name: "KhmerOSBattambang-Regular", size: 14)
        newPasswordConfirmTextField.font = UIFont(name: "KhmerOSBattambang-Regular", size: 14)
        confirmButton.titleLabel?.font = UIFont(name: "KhmerOSBattambang-Regular", size: 14)
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        oldPasswordTextField.layer.cornerRadius = 5
        newPasswordTextField.layer.cornerRadius = 5
        newPasswordConfirmTextField.layer.cornerRadius = 5
        confirmButton.layer.cornerRadius = 5
    }
    
    @objc func setColor() {
        let theme = ThemeManager.shared.theme
        view.backgroundColor = theme.view.backgroundColor
        mainView.backgroundColor = theme.view.backgroundColor
        titleLabel.textColor = theme.label.primaryColor
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: theme.textField.placeholderColor
        ]
        oldPasswordTextField.backgroundColor = theme.textField.backgroundColor
        oldPasswordTextField.textColor = theme.label.primaryColor
        oldPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Enter your previous password".localized(using: "InputFields"), attributes: attributes)
        newPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Enter your new password".localized(using: "InputFields"), attributes: attributes)
        newPasswordConfirmTextField.attributedPlaceholder = NSAttributedString(string:  "Enter your new password confirmation".localized(using: "InputFields"), attributes: attributes)
    }
    
    @objc func tapGestureRecognizerTapped(sender: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func confirmButtonTapped(){
        let oldPassword = oldPasswordTextField.text ?? ""
        let password = newPasswordTextField.text ?? ""
        let passwordConfirmation = newPasswordConfirmTextField.text ?? ""
        if DataValidation.validateRequired(field: oldPassword, fieldName: "Current Password") &&
            DataValidation.validateRequired(field: password, fieldName: "Password") &&
            DataValidation.validateRequired(field: passwordConfirmation, fieldName: "Password Confirmation"){
            if oldPassword.count < 8 {
                PopUpUtil.popUp(withTitle: "Warning".localized(using: "Generals"), withMessage: "The current password must be at least 8 characters!", withAlert: .warning) {}
                return
            }
            
            if password.count < 8 {
                PopUpUtil.popUp(withTitle: "Warning".localized(using: "Generals"), withMessage: "The password must be at least 8 characters!", withAlert: .warning) {}
                return
            }
            if password != passwordConfirmation {
                PopUpUtil.popUp(withTitle: "Warning".localized(using: "Generals"), withMessage: "The password confirmation does not match", withAlert: .warning) {}
                return
            }
            
            let alertController = LoadingViewController()
            present(alertController, animated: true) { [weak self] in
                guard let self = self else { return }
                let keychain = KeychainSwift()
                let accessToken = keychain.get("accessToken")!
                UserAPIService.shared.changePassword(token: accessToken, uuid: userUuid, oldPassword: oldPassword, password: password) { response in
                    alertController.dismiss(animated: true) {
                        switch response {
                        case .success(let result):
                            print("Response success :", result)
                            PopUpUtil.popUp(withTitle: "Success".localized(using: "Generals"), withMessage: result.message, withAlert: .success) {
                                self.navigationController?.popViewController(animated: true)
                            }
                        case .failure(let error):
                            print("Response failure :", error)
                            if error.code == 401 {
                                PopUpUtil.popUp(withTitle: "Warning".localized(using: "Generals"), withMessage: error.message, withAlert: .warning) {}
                            } else {
                                PopUpUtil.popUp(withTitle: "Error".localized(using: "Generals"), withMessage: error.message, withAlert: .cross) {}
                            }
                        }
                    }
                }
            }
        }
    }

}

@available(iOS 13.0, *)
extension ChangePasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == oldPasswordTextField {
            newPasswordTextField.becomeFirstResponder()
        } else if textField == newPasswordTextField {
            newPasswordConfirmTextField.becomeFirstResponder()
        } else if textField == newPasswordConfirmTextField {
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
