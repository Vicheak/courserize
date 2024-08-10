//
//  LoginViewController.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 28/7/24.
//

import UIKit
import Localize_Swift
import KeychainSwift

@available(iOS 13.0, *)
class LoginViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgetPasswordButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var gesture: UITapGestureRecognizer!
    @IBOutlet weak var guestUserButton: UIBarButtonItem!
    @IBOutlet weak var settingButton: UIBarButtonItem!
    @IBOutlet weak var changeLocalizeButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var loginImageView: UIImageView!
    
    var passwordManager: PasswordTextFieldManager!
    var keyboardUtil: KeyboardUtil!
    
    let loginFormBg1 = UIImage(named: "login-form-background")!
    let loginFormBg2 = UIImage(named: "login-form-bg2")!
    let khmerLanguageIcon = UIImage(named: "cambodia-logo")!
    let englishLanguageIcon = UIImage(named: "usa-logo")!
    
    var actionSheet: UIAlertController!
    let availableLanguages = Localize.availableLanguages()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        
        self.setText()

        passwordManager = PasswordTextFieldManager(passwordTextField: passwordTextField)
        keyboardUtil = KeyboardUtil(view: view, bottomConstraint: bottomConstraint)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        gesture.addTarget(self, action: #selector(tapGestureRecognizerTapped))
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        changeLocalizeButton.addTarget(self, action: #selector(changeLocalizeButtonTapped), for: .touchUpInside)
        
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
        let khmerLanguageCode = "km"
        UIView.transition(with: changeLocalizeButton.imageView!, duration: 0.5, options: [.transitionCurlUp]) { [weak self] in
            guard let self = self else { return }
            changeLocalizeButton.setImage(Localize.currentLanguage() == khmerLanguageCode ? khmerLanguageIcon : englishLanguageIcon, for: .normal)
        }
        
        UIView.transition(with: loginImageView, duration: 1.5, options: [.transitionCrossDissolve]) { [weak self] in
            guard let self = self else { return }
            loginImageView.image = Localize.currentLanguage() == khmerLanguageCode ? loginFormBg2 : loginFormBg1
        }
        
        titleLabel.text = "Login".localized(using: "ScreenTitles")
        emailTextField.placeholder = "Email".localized(using: "InputFields")
        passwordTextField.placeholder = "Password".localized(using: "InputFields")
        loginButton.setTitle("Login".localized(using: "ButtonTitles"), for: .normal)
        forgetPasswordButton.setTitle("Forget password?".localized(using: "ButtonTitles"), for: .normal)
        registerButton.setTitle("Don't have an account? sign up now".localized(using: "ButtonTitles"), for: .normal)
    }
    
    func setUpViews(){
        //set up font
        titleLabel.font = UIFont(name: "KhmerOSBattambang-Bold", size: 24)
        emailTextField.font = UIFont(name: "KhmerOSBattambang-Regular", size: 14)
        passwordTextField.font = UIFont(name: "KhmerOSBattambang-Regular", size: 14)
        loginButton.titleLabel?.font = UIFont(name: "KhmerOSBattambang-Regular", size: 14)
        forgetPasswordButton.titleLabel?.font = UIFont(name: "KhmerOSBattambang-Regular", size: 14)
        registerButton.titleLabel?.font = UIFont(name: "KhmerOSBattambang-Regular", size: 14)
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        emailTextField.layer.cornerRadius = 5
        loginButton.layer.cornerRadius = 5
        guestUserButton.title = "Guest Login"
        guestUserButton.image = UIImage(systemName: "person.circle.fill")
        guestUserButton.tintColor = .black
        settingButton.image = UIImage(systemName: "gear")
        settingButton.tintColor = .black
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
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password".localized(using: "InputFields"), attributes: attributes)
        
        forgetPasswordButton.setTitleColor(theme.label.primaryColor, for: .normal)
        registerButton.setTitleColor(theme.label.primaryColor, for: .normal)
        guestUserButton.tintColor = theme.imageView.tintColor
        settingButton.tintColor = theme.imageView.tintColor
    }
    
    @objc func tapGestureRecognizerTapped(sender: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func loginButtonTapped(){
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        let alertController = LoadingViewController()
        
        if DataValidation.validateRequired(field: email, fieldName: "Email") &&
            DataValidation.validateRequired(field: password, fieldName: "Password") {
            present(alertController, animated: true) {
                AuthAPIService.shared.login(email: email, password: password) { response in
                    alertController.dismiss(animated: true) { [weak self] in
                        guard let self = self else { return }
                        switch response {
                        case .success(let result):
                            print("Response success :", result)
                            //request to server to get user profile
                            UserAPIService.shared.userProfile(token: result.accessToken) { response in
                                switch response {
                                case .success(let result):
                                    print("Get user profile :", result)
                                    //must encode the result before set it to user default
                                    let encoder = JSONEncoder()
                                    if let userProfileResponse = try? encoder.encode(result) {
                                        UserDefaults.standard.set(userProfileResponse, forKey: "userProfileResponse")
                                    }
                                case .failure(let error):
                                    print("Cannot get user profile :", error.message)
                                }
                            }
                            
                            proceedHomeScreen(email: email, accessToken: result.accessToken, refreshToken: result.refreshToken)
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
    }
    
    func proceedHomeScreen(email: String, accessToken: String, refreshToken: String) {
        let tabBarController = BaseTabBarViewController()
        
        emailTextField.text = ""
        passwordTextField.text = ""
        
        UserDefaults.standard.setValue(true, forKey: "isLogin")
        let keychain = KeychainSwift()
        keychain.set(accessToken, forKey: "accessToken")
        keychain.set(refreshToken, forKey: "refreshToken")
        
        UIApplication.shared.showPresent(viewController: tabBarController, animation: true)
    }
    
    @objc func changeLocalizeButtonTapped(){
        actionSheet = UIAlertController(title: nil, message: "Switch Language", preferredStyle: UIAlertController.Style.actionSheet)
        for language in availableLanguages {
            let displayName = Localize.displayNameForLanguage(language)
            let languageAction = UIAlertAction(title: displayName, style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                Localize.setCurrentLanguage(language)
                UserDefaults.standard.setValue(language, forKey: "language")
            })
            actionSheet.addAction(languageAction)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {
            (alert: UIAlertAction) -> Void in
        })
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
}

@available(iOS 13.0, *)
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
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
    
}
