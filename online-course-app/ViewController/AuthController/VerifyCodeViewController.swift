//
//  VerifyCodeViewController.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 28/7/24.
//

import UIKit
import Localize_Swift

class VerifyCodeViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var codeTextField1: UITextField!
    @IBOutlet weak var codeTextField2: UITextField!
    @IBOutlet weak var codeTextField3: UITextField!
    @IBOutlet weak var codeTextField4: UITextField!
    @IBOutlet weak var codeTextField5: UITextField!
    @IBOutlet weak var codeTextField6: UITextField!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var sendCodeButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var gesture: UITapGestureRecognizer!
    @IBOutlet weak var titleLabel: UILabel!
    
    var keyboardUtil: KeyboardUtil!
    
    var email: String!
    var forgetPassword: Bool!
    var passwordToken: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpViews()
        
        self.setText()
        
        keyboardUtil = KeyboardUtil(view: view, bottomConstraint: bottomConstraint)
        
        codeTextField1.delegate = self
        codeTextField2.delegate = self
        codeTextField3.delegate = self
        codeTextField4.delegate = self
        codeTextField5.delegate = self
        codeTextField6.delegate = self
        
        gesture.addTarget(self, action: #selector(tapGestureRecognizerTapped))
        sendCodeButton.addTarget(self, action: #selector(sendCodeButtonTapped), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc func setText(){
        titleLabel.text = "Please enter 6 digit OTP code".localized(using: "ScreenTitles")
        confirmButton.setTitle("Confirm".localized(using: "ButtonTitles"), for: .normal)
        sendCodeButton.setTitle("Resend Code".localized(using: "ButtonTitles"), for: .normal)
    }
    
    func setUpViews(){
        titleLabel.font = UIFont(name: "KhmerOSBattambang-Bold", size: 18)
        confirmButton.titleLabel?.font = UIFont(name: "KhmerOSBattambang-Regular", size: 14)
        sendCodeButton.titleLabel?.font = UIFont(name: "KhmerOSBattambang-Bold", size: 14)
        
        codeTextField1.backgroundColor = .white
        codeTextField1.textColor = .black
        codeTextField2.backgroundColor = .white
        codeTextField2.textColor = .black
        codeTextField3.backgroundColor = .white
        codeTextField3.textColor = .black
        codeTextField4.backgroundColor = .white
        codeTextField4.textColor = .black
        codeTextField5.backgroundColor = .white
        codeTextField5.textColor = .black
        codeTextField6.backgroundColor = .white
        codeTextField6.textColor = .black
        confirmButton.layer.cornerRadius = 5
    }
    
    @objc func tapGestureRecognizerTapped(sender: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func sendCodeButtonTapped(){
        let alertController = LoadingViewController()
        present(alertController, animated: true) {
            AuthAPIService.shared.resendCode(email: self.email) { response in
                alertController.dismiss(animated: true) {
                    switch response {
                    case .success(let result):
                        print("Response success :", result)
                        PopUpUtil.popUp(withTitle: "Success".localized(using: "Generals"), withMessage: result.message, withAlert: .success) { }
                    case .failure(let error):
                        print("Response failure :", error)
                        if error.code == 400 {
                            PopUpUtil.popUp(withTitle: "Warning".localized(using: "Generals"), withMessage: error.errors[0].message, withAlert: .warning) {}
                        } else if error.code == 401 {
                            PopUpUtil.popUp(withTitle: "Invalid".localized(using: "Generals"), withMessage: error.message, withAlert: .cross) {}
                        } else {
                            PopUpUtil.popUp(withTitle: "No Connection".localized(using: "Generals"), withMessage: error.message, withAlert: .warning) {}
                        }
                    }
                }
            }
        }
    }
    
    @objc func closeButtonTapped(){
        dismiss(animated: true)
    }
    
    @objc func confirmButtonTapped(){
        let code1 = codeTextField1.text ?? ""
        let code2 = codeTextField2.text ?? ""
        let code3 = codeTextField3.text ?? ""
        let code4 = codeTextField4.text ?? ""
        let code5 = codeTextField5.text ?? ""
        let code6 = codeTextField6.text ?? ""
        
        let message = "Please fill in OTP Code"
        
        //validate OTP code
        if DataValidation.validateRequired(field: code1, fieldName: "", message: message) &&
            DataValidation.validateRequired(field: code2, fieldName: "", message: message) &&
            DataValidation.validateRequired(field: code3, fieldName: "", message: message) &&
            DataValidation.validateRequired(field: code4, fieldName: "", message: message) &&
            DataValidation.validateRequired(field: code5, fieldName: "", message: message) &&
            DataValidation.validateRequired(field: code6, fieldName: "", message: message){
            let otpCode = code1 + code2 + code3 + code4 + code5 + code6
            print("OTP Code : \(otpCode)")
            
            let alertController = LoadingViewController()
            present(alertController, animated: true) {
                AuthAPIService.shared.verifyCode(email: self.email, verifiedCode: otpCode) { response in
                    alertController.dismiss(animated: true) {
                        switch response {
                        case .success(let result):
                            print("Response success :", result)
                            PopUpUtil.popUp(withTitle: "Success".localized(using: "Generals"), withMessage: result.message, withAlert: .success) { [weak self] in
                                guard let self = self else { return }
                                if forgetPassword {
                                    //reset password view controller
                                    let storyboard = UIStoryboard(name: "AuthScreen", bundle: nil)
                                    let resetPasswordViewController = storyboard.instantiateViewController(withIdentifier: "ResetPasswordViewController") as! ResetPasswordViewController
                                    resetPasswordViewController.modalPresentationStyle = .fullScreen
                                    resetPasswordViewController.email = email
                                    resetPasswordViewController.passwordToken = passwordToken!
                                    present(resetPasswordViewController, animated: true){
                                        NotificationCenter.default.addObserver(self, selector: #selector(self.closeButtonTapped), name: NSNotification.Name.dismissVerifyCodeScreen, object: nil)
                                    }
                                } else {
                                    dismiss(animated: true)
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
                                    PopUpUtil.popUp(withTitle: "Invalid".localized(using: "Generals"), withMessage: errorResponseMessage.errors, withAlert: .cross) {}
                                }
                            }
                        }
                    }
                }
            }
        }
    }

}

extension VerifyCodeViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Check if the replacement string is a number
        if let _ = Int(string) {
            // Get the current text
            let currentText = textField.text ?? ""
            
            // Compute the new text
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            
            // Allow change if new text length is 1 or less
            if newText.count <= 1 {
                if newText.count == 1 {
                    // Move to the next text field if input is valid
                    if textField == codeTextField1 {
                        codeTextField1.text = newText
                        codeTextField2.becomeFirstResponder()
                    } else if textField == codeTextField2 {
                        codeTextField2.text = newText
                        codeTextField3.becomeFirstResponder()
                    } else if textField == codeTextField3 {
                        codeTextField3.text = newText
                        codeTextField4.becomeFirstResponder()
                    } else if textField == codeTextField4 {
                        codeTextField4.text = newText
                        codeTextField5.becomeFirstResponder()
                    } else if textField == codeTextField5 {
                        codeTextField5.text = newText
                        codeTextField6.becomeFirstResponder()
                    }
                }
                return true
            }
        } else if string.isEmpty {
            // Move to the previous text field to handle backspace
            if textField == codeTextField1 {
                codeTextField1.text = ""
            } else if textField == codeTextField2 {
                codeTextField2.text = ""
                codeTextField1.becomeFirstResponder()
            } else if textField == codeTextField3 {
                codeTextField3.text = ""
                codeTextField2.becomeFirstResponder()
            } else if textField == codeTextField4 {
                codeTextField4.text = ""
                codeTextField3.becomeFirstResponder()
            } else if textField == codeTextField5 {
                codeTextField5.text = ""
                codeTextField4.becomeFirstResponder()
            } else if textField == codeTextField6 {
                codeTextField6.text = ""
                codeTextField5.becomeFirstResponder()
            }
            return false
        }
        
        // Disallow any non-number input
        return string.isEmpty
    }
    
}
