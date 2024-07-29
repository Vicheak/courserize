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
    
    var keyboardUtil: KeyboardUtil!
    
    let eyeShowIcon = UIImage(named: "eye-show-icon")!
    let eyeHideIcon = UIImage(named: "eye-hide-icon")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        
        self.setText()

        keyboardUtil = KeyboardUtil(view: view, bottomConstraint: bottomConstraint)
        
        passwordTextField.delegate = self
        passwordConfirmationTextField.delegate = self
        
        gesture.addTarget(self, action: #selector(tapGestureRecognizerTapped))
        eyeToggleButton.addTarget(self, action: #selector(togglePasswordShow), for: .touchUpInside)
        eyeToggleConfirmationButton.addTarget(self, action: #selector(togglePasswordConfirmShow), for: .touchUpInside)
        resetPasswordButton.addTarget(self, action: #selector(resetPasswordButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
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
