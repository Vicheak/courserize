//
//  ApplyForAuthorViewController.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 23/8/24.
//

import UIKit
import Localize_Swift
import KeychainSwift

@available(iOS 13.0, *)
class ApplyForAuthorViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var applyForAuthorTitle: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var gesture: UITapGestureRecognizer!
    
    var passwordManager: PasswordTextFieldManager!
    var keyboardUtil: KeyboardUtil!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()

        self.setText()

        passwordManager = PasswordTextFieldManager(passwordTextField: passwordTextField)
        keyboardUtil = KeyboardUtil(view: view, bottomConstraint: bottomConstraint)
        
        emailTextField.delegate = self
        phoneNumberTextField.delegate = self
        passwordTextField.delegate = self
        
        gesture.addTarget(self, action: #selector(tapGestureRecognizerTapped))
        applyButton.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
        
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
        applyForAuthorTitle.text = "Apply for Author".localized(using: "ScreenTitles")
        emailTextField.placeholder = "Enter your email".localized(using: "InputFields")
        phoneNumberTextField.placeholder = "Enter phone number".localized(using: "InputFields")
        passwordTextField.placeholder = "Enter password".localized(using: "InputFields")
        applyButton.setTitle("Apply Now".localized(using: "ButtonTitles"), for: .normal)
    }
    
    func setUpViews(){
        applyForAuthorTitle.font = UIFont(name: "KhmerOSBattambang-Bold", size: 24)
        emailTextField.font = UIFont(name: "KhmerOSBattambang-Regular", size: 14)
        phoneNumberTextField.font = UIFont(name: "KhmerOSBattambang-Regular", size: 14)
        passwordTextField.font = UIFont(name: "KhmerOSBattambang-Regular", size: 14)
        applyButton.titleLabel?.font = UIFont(name: "KhmerOSBattambang-Regular", size: 14)
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        emailTextField.layer.cornerRadius = 5
        phoneNumberTextField.layer.cornerRadius = 5
        applyButton.layer.cornerRadius = 5
    }
    
    @objc func setColor() {
        let theme = ThemeManager.shared.theme
        view.backgroundColor = theme.view.backgroundColor
        mainView.backgroundColor = theme.view.backgroundColor
        applyForAuthorTitle.textColor = theme.label.primaryColor
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: theme.textField.placeholderColor
        ]
        emailTextField.backgroundColor = theme.textField.backgroundColor
        emailTextField.textColor = theme.label.primaryColor
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Enter your email".localized(using: "InputFields"), attributes: attributes)
        phoneNumberTextField.backgroundColor = theme.textField.backgroundColor
        phoneNumberTextField.textColor = theme.label.primaryColor
        phoneNumberTextField.attributedPlaceholder = NSAttributedString(string: "Enter phone number".localized(using: "InputFields"), attributes: attributes)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Enter password".localized(using: "InputFields"), attributes: attributes)
    }
    
    @objc func tapGestureRecognizerTapped(sender: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func applyButtonTapped(){
        let email = emailTextField.text ?? ""
        let phoneNumber = phoneNumberTextField.text ?? ""
        let password = passwordTextField.text ?? ""

        if DataValidation.validateRequired(field: email, fieldName: "Email") &&
            DataValidation.validateRequired(field: phoneNumber, fieldName: "Phone number") &&
            DataValidation.validateRequired(field: password, fieldName: "Password") {
            if !DataValidation.isValidEmail(email) {
                PopUpUtil.popUp(withTitle: "Warning".localized(using: "Generals"), withMessage: "Email must be a valid email address", withAlert: .warning) {}
                return
            }
            
            if password.count < 8 {
                PopUpUtil.popUp(withTitle: "Warning".localized(using: "Generals"), withMessage: "The password must be at least 8 characters!", withAlert: .warning) {}
                return
            }
            
            let keychain = KeychainSwift()
            let accessToken = keychain.get("accessToken")!
            let alertController = LoadingViewController()
            present(alertController, animated: true) {
                AuthAPIService.shared.applyForAuthor(token: accessToken, email: email, password: password, phoneNumber: phoneNumber) { response in
                    alertController.dismiss(animated: true) {
                        switch response {
                        case .success(let result):
                            print("Response success :", result)
                            PopUpUtil.popUp(withTitle: "Success".localized(using: "Generals"), withMessage: result.message, withAlert: .success) { [weak self] in
                                guard let self = self else { return }
                                //verify code screen
                                let storyboard = UIStoryboard(name: "AuthScreen", bundle: nil)
                                let verifyCodeViewController = storyboard.instantiateViewController(withIdentifier: "VerifyCodeViewController") as! VerifyCodeViewController
                                verifyCodeViewController.modalPresentationStyle = .fullScreen
                                verifyCodeViewController.email = email
                                verifyCodeViewController.forgetPassword = false
                                verifyCodeViewController.applyforAuthor = true
                                present(verifyCodeViewController, animated: true) {
                                    self.navigationController?.popToRootViewController(animated: true)
                                }
                            }
                        case .failure(let error):
                            print("Response failure :", error)
                            if error.code == 400 || error.code == 401 {
                                PopUpUtil.popUp(withTitle: "Warning".localized(using: "Generals"), withMessage: error.errors, withAlert: .warning) {}
                            } else {
                                PopUpUtil.popUp(withTitle: "No Connection".localized(using: "Generals"), withMessage: error.message, withAlert: .warning) {}
                            }
                        }
                    }
                }
            }
        }
    }

}

@available(iOS 13.0, *)
extension ApplyForAuthorViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            phoneNumberTextField.becomeFirstResponder()
        } else if textField == phoneNumberTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
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

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneNumberTextField {
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    
}
