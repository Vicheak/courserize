//
//  KeyboardUtil.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 28/7/24.
//

import UIKit
import SnapKit

class KeyboardUtil {
        
    var view: UIView
    var bottomConstraint: NSLayoutConstraint
    
    init(view: UIView, bottomConstraint: NSLayoutConstraint) {
        self.view = view
        self.bottomConstraint = bottomConstraint
        
        keyboardNotification()
    }
    
    func keyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification){
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        bottomConstraint.constant = keyboardFrame.height
        view.layoutIfNeeded()
    }
    
    @objc func keyboardWillHide(notification: Notification){
        bottomConstraint.constant = 0
        view.layoutIfNeeded()
    }
    
}
