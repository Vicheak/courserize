//
//  ForgetPasswordViewController.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 28/7/24.
//

import UIKit
import Localize_Swift

class ForgetPasswordViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var gesture: UITapGestureRecognizer!
    @IBOutlet weak var containerView: UIView!
    
    var keyboardUtil: KeyboardUtil!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        
        self.setText()

        keyboardUtil = KeyboardUtil(view: view, bottomConstraint: bottomConstraint)
        
        emailTextField.delegate = self
        
        gesture.addTarget(self, action: #selector(tapGestureRecognizerTapped))
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        
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
        titleLabel.text = "Forget Password".localized(using: "ScreenTitles")
        emailTextField.placeholder = "Enter your own email".localized(using: "InputFields")
        continueButton.setTitle("Continue".localized(using: "ButtonTitles"), for: .normal)
    }
    
    func setUpViews(){
        titleLabel.font = UIFont(name: "KhmerOSBattambang-Bold", size: 24)
        emailTextField.font = UIFont(name: "KhmerOSBattambang-Regular", size: 14)
        continueButton.titleLabel?.font = UIFont(name: "KhmerOSBattambang-Regular", size: 14)
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        emailTextField.layer.cornerRadius = 5
        continueButton.layer.cornerRadius = 5
    }
    
    @objc func setColor() {
        let theme = ThemeManager.shared.theme
        view.backgroundColor = theme.view.backgroundColor
        containerView.backgroundColor = theme.view.backgroundColor
        titleLabel.textColor = theme.label.primaryColor
        emailTextField.backgroundColor = theme.textField.backgroundColor
        emailTextField.textColor = theme.label.primaryColor
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: theme.textField.placeholderColor
        ]
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email".localized(using: "InputFields"), attributes: attributes)
        continueButton.setTitleColor(theme.label.primaryColor, for: .normal)
    }
    
    @objc func tapGestureRecognizerTapped(sender: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func continueButtonTapped(){
        let email = emailTextField.text ?? ""
        
        if DataValidation.validateRequired(field: email, fieldName: "Email") {
            let alertController = LoadingViewController()
            present(alertController, animated: true) {
                AuthAPIService.shared.forgetPassword(email: email) { response in
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
                                verifyCodeViewController.forgetPassword = true
                                verifyCodeViewController.passwordToken = result.token
                                present(verifyCodeViewController, animated: true) {
                                    self.navigationController?.popToRootViewController(animated: true)
                                }
                            }
                        case .failure(let error):
                            print("Response failure :", error)
                            if let errorResponseData = error as? ErrorResponseData {
                                if errorResponseData.code == 400 {
                                    PopUpUtil.popUp(withTitle: "Warning".localized(using: "Generals"), withMessage: errorResponseData.errors[0].message, withAlert: .warning) {}
                                } else if errorResponseData.code == 401 {
                                    PopUpUtil.popUp(withTitle: "Invalid".localized(using: "Generals"), withMessage: errorResponseData.message, withAlert: .cross) {}
                                } else {
                                    PopUpUtil.popUp(withTitle: "No Connection".localized(using: "Generals"), withMessage: errorResponseData.message, withAlert: .warning) {}
                                }
                            } else if let errorResponseMessage = error as? ErrorResponseMessage {
                                if errorResponseMessage.code == 404 {
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

extension ForgetPasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
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

