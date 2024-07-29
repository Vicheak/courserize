//
//  RegisterViewController.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 28/7/24.
//

import UIKit
import Localize_Swift

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var genderPickerView: UIPickerView!
    @IBOutlet weak var birthDatePicker: UIDatePicker!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    @IBOutlet weak var eyeToggleButton: UIButton!
    @IBOutlet weak var eyeToggleConfirmButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var gesture: UITapGestureRecognizer!
    @IBOutlet weak var chooseGenderLabel: UILabel!
    @IBOutlet weak var chooseBirthDateLabel: UILabel!
    
    var keyboardUtil: KeyboardUtil!
    
    let eyeShowIcon = UIImage(named: "eye-show-icon")!
    let eyeHideIcon = UIImage(named: "eye-hide-icon")!
    
    let genders = ["male", "female"]

    override func viewDidLoad() {
        super.viewDidLoad()
                
        setUpViews()
        
        self.setText()

        keyboardUtil = KeyboardUtil(view: view, bottomConstraint: bottomConstraint)
        
        usernameTextField.delegate = self
        emailTextField.delegate = self
        phoneNumberTextField.delegate = self
        //setup UIPickerView
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        birthDatePicker.contentHorizontalAlignment = .center
        birthDatePicker.contentVerticalAlignment = .center
        birthDatePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        passwordTextField.delegate = self
        passwordConfirmTextField.delegate = self
        
        gesture.addTarget(self, action: #selector(tapGestureRecognizerTapped))
        eyeToggleButton.addTarget(self, action: #selector(togglePasswordShow), for: .touchUpInside)
        eyeToggleConfirmButton.addTarget(self, action: #selector(togglePasswordConfirmShow), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
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
        titleLabel.text = "Register New Account".localized(using: "ScreenTitles")
        usernameTextField.placeholder = "Enter your username".localized(using: "InputFields")
        emailTextField.placeholder = "Enter your email".localized(using: "InputFields")
        phoneNumberTextField.placeholder = "Enter phone number".localized(using: "InputFields")
        chooseGenderLabel.text = "Choose your gender".localized(using: "InputFields")
        chooseBirthDateLabel.text = "Choose your birth date".localized(using: "InputFields")
        passwordTextField.placeholder = "Enter password".localized(using: "InputFields")
        passwordConfirmTextField.placeholder = "Enter password confirmation".localized(using: "InputFields")
        registerButton.setTitle("Sign Up".localized(using: "ButtonTitles"), for: .normal)
    }
    
    func setUpViews(){
        titleLabel.font = UIFont(name: "KhmerOSBattambang-Bold", size: 24)
        usernameTextField.font = UIFont(name: "KhmerOSBattambang-Regular", size: 14)
        emailTextField.font = UIFont(name: "KhmerOSBattambang-Regular", size: 14)
        phoneNumberTextField.font = UIFont(name: "KhmerOSBattambang-Regular", size: 14)
        chooseGenderLabel.font = UIFont(name: "KhmerOSBattambang-Regular", size: 16)
        chooseBirthDateLabel.font = UIFont(name: "KhmerOSBattambang-Regular", size: 16)
        passwordTextField.font = UIFont(name: "KhmerOSBattambang-Regular", size: 14)
        passwordConfirmTextField.font = UIFont(name: "KhmerOSBattambang-Regular", size: 14)
        registerButton.titleLabel?.font = UIFont(name: "KhmerOSBattambang-Regular", size: 14)
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        usernameTextField.layer.cornerRadius = 5
        emailTextField.layer.cornerRadius = 5
        phoneNumberTextField.layer.cornerRadius = 5
        passwordTextField.layer.cornerRadius = 5
        passwordConfirmTextField.layer.cornerRadius = 5
        registerButton.layer.cornerRadius = 5
    }
    
    @objc func tapGestureRecognizerTapped(sender: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func togglePasswordShow(){
        eyeToggleButton.setImage(passwordTextField.isSecureTextEntry ? eyeHideIcon : eyeShowIcon, for: .normal)
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
    
    @objc func togglePasswordConfirmShow(){
        eyeToggleConfirmButton.setImage(passwordConfirmTextField.isSecureTextEntry ? eyeHideIcon : eyeShowIcon, for: .normal)
        passwordConfirmTextField.isSecureTextEntry = !passwordConfirmTextField.isSecureTextEntry
    }
    
    @objc func registerButtonTapped(){
        let storyboard = UIStoryboard(name: "AuthScreen", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "VerifyCodeViewController")
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .coverVertical
        present(viewController, animated: true)
    }

}

extension RegisterViewController: UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            phoneNumberTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordConfirmTextField.becomeFirstResponder()
        } else if textField == passwordConfirmTextField {
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let khmerLanguageCode = "km"
        return Localize.currentLanguage() == khmerLanguageCode ? row == 0 ? "ប្រុស" : "ស្រី" : genders[row];
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        print(genders[row])
    }
    
    @objc func dateChanged(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
               
        //get the date from datePicker
        let birthDate = dateFormatter.string(from: birthDatePicker.date)
        print(birthDate)
    }
    
}
