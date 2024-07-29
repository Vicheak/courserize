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
    
    var keyboardUtil: KeyboardUtil!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        
        self.setText()

        keyboardUtil = KeyboardUtil(view: view, bottomConstraint: bottomConstraint)
        
        emailTextField.delegate = self
        
        gesture.addTarget(self, action: #selector(tapGestureRecognizerTapped))
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
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
    
    @objc func tapGestureRecognizerTapped(sender: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func continueButtonTapped(){

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

