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
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var gesture: UITapGestureRecognizer!
    @IBOutlet weak var chooseGenderLabel: UILabel!
    @IBOutlet weak var chooseBirthDateLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    var passwordManager: PasswordTextFieldManager!
    var passwordConfirmationManager: PasswordTextFieldManager!
    var keyboardUtil: KeyboardUtil!
    
    let genders = ["male", "female"]
    var selectedGender: String?

    override func viewDidLoad() {
        super.viewDidLoad()
                
        setUpViews()
        
        self.setText()

        passwordManager = PasswordTextFieldManager(passwordTextField: passwordTextField)
        passwordConfirmationManager = PasswordTextFieldManager(passwordTextField: passwordConfirmTextField)
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
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
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
        registerButton.layer.cornerRadius = 5
    }
    
    @objc func setColor() {
        let theme = ThemeManager.shared.theme
        view.backgroundColor = theme.view.backgroundColor
        containerView.backgroundColor = theme.view.backgroundColor
        titleLabel.textColor = theme.label.primaryColor
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: theme.textField.placeholderColor
        ]
        usernameTextField.backgroundColor = theme.textField.backgroundColor
        usernameTextField.textColor = theme.label.primaryColor
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Enter your username".localized(using: "InputFields"), attributes: attributes)
        emailTextField.backgroundColor = theme.textField.backgroundColor
        emailTextField.textColor = theme.label.primaryColor
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Enter your email".localized(using: "InputFields"), attributes: attributes)
        phoneNumberTextField.backgroundColor = theme.textField.backgroundColor
        phoneNumberTextField.textColor = theme.label.primaryColor
        phoneNumberTextField.attributedPlaceholder = NSAttributedString(string: "Enter phone number".localized(using: "InputFields"), attributes: attributes)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Enter password".localized(using: "InputFields"), attributes: attributes)
        passwordConfirmTextField.attributedPlaceholder = NSAttributedString(string: "Enter password confirmation".localized(using: "InputFields"), attributes: attributes)
        chooseGenderLabel.textColor = theme.label.primaryColor
        chooseBirthDateLabel.textColor = theme.label.primaryColor
    }
    
    @objc func tapGestureRecognizerTapped(sender: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func registerButtonTapped(){
        let username = usernameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        //validate phone number format
        let phoneNumber = phoneNumberTextField.text ?? ""
        let gender = selectedGender ?? genders[0]
        let birthDate = RegisterViewController.dateFormatter.string(from: birthDatePicker.date)
        let password = passwordTextField.text ?? ""
        let passwordConfirmation = passwordConfirmTextField.text ?? ""
        
        if DataValidation.validateRequired(field: username, fieldName: "Username") &&
            DataValidation.validateRequired(field: email, fieldName: "Email") &&
            DataValidation.validateRequired(field: phoneNumber, fieldName: "Phone number") &&
            DataValidation.validateRequired(field: password, fieldName: "Password") &&
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
                AuthAPIService.shared.register(username: username, email: email, phoneNumber: phoneNumber, gender: gender, birthDate: birthDate, password: password) { response in
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
                                if errorResponseMessage.code == 409 {
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

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneNumberTextField {
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
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
        selectedGender = genders[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        if let reusedLabel = view as? UILabel {
            label = reusedLabel
        } else {
            label = UILabel()
        }
        label.textColor = ThemeManager.shared.theme.label.primaryColor
        label.textAlignment = .center
        let khmerLanguageCode = "km"
        label.text = Localize.currentLanguage() == khmerLanguageCode ? row == 0 ? "ប្រុស" : "ស្រី" : genders[row];
        return label
    }
    
    @objc func dateChanged(){
        //get the date from datePicker
        let birthDate = RegisterViewController.dateFormatter.string(from: birthDatePicker.date)
//        print(birthDate)
        
    }
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
    
}
