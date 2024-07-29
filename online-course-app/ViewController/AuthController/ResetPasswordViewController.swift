//
//  ResetPasswordViewController.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 28/7/24.
//

import UIKit

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
    
    var keyboardUtil: KeyboardUtil!
    
    let eyeShowIcon = UIImage(named: "eye-show-icon")!
    let eyeHideIcon = UIImage(named: "eye-hide-icon")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()

        keyboardUtil = KeyboardUtil(view: view, bottomConstraint: bottomConstraint)
        
        passwordTextField.delegate = self
        passwordConfirmationTextField.delegate = self
        
        gesture.addTarget(self, action: #selector(tapGestureRecognizerTapped))
        eyeToggleButton.addTarget(self, action: #selector(togglePasswordShow), for: .touchUpInside)
        eyeToggleConfirmationButton.addTarget(self, action: #selector(togglePasswordConfirmShow), for: .touchUpInside)
        resetPasswordButton.addTarget(self, action: #selector(resetPasswordButtonTapped), for: .touchUpInside)
    }
    
    func setUpViews(){
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

