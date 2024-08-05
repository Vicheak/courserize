//
//  ContactViewController.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 2/8/24.
//

import UIKit
import Localize_Swift

class ContactViewController: UIViewController {

    let titleLabel = UILabel()
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var telegramImageView: UIImageView!
    @IBOutlet weak var linkedinImageView: UIImageView!
    @IBOutlet weak var webImageView: UIImageView!
    @IBOutlet weak var facebookImageView: UIImageView!
    @IBOutlet weak var phoneImageView: UIImageView!
    @IBOutlet weak var emailImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var socialLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpViews()
        
        self.setColor()
        NotificationCenter.default.addObserver(self, selector: #selector(setColor), name: .changeTheme, object: nil)
    }
    
    private func setUpViews(){
        titleLabel.text = "Contact".localized(using: "Generals")
        titleLabel.font = UIFont(name: "KhmerOSBattambang-Bold", size: 18)
        titleLabel.textAlignment = .center
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        mainView.layer.cornerRadius = 20
        mainView.layer.borderWidth = 3
        mainView.layer.borderColor = UIColor.lightGray.cgColor
        
        telegramImageView.isUserInteractionEnabled = true
        telegramImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(telegramLinkTap)))
        
        linkedinImageView.isUserInteractionEnabled = true
        linkedinImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(linkedinLinkTap)))
        
        webImageView.isUserInteractionEnabled = true
        webImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(webLinkTap)))
        
        facebookImageView.isUserInteractionEnabled = true
        facebookImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(facebookLinkTap)))
        
        phoneImageView.isUserInteractionEnabled = true
        phoneImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(phoneLinkTap)))
        
        emailImageView.isUserInteractionEnabled = true
        emailImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(emailLinkTap)))
    }
    
    @objc func setColor() {
        let theme = ThemeManager.shared.theme
        view.backgroundColor = theme.view.backgroundColor
        mainView.backgroundColor = .white
        titleLabel.textColor = theme.label.primaryColor
        containerView.backgroundColor = theme.view.backgroundColor
        phoneLabel.textColor = .black
        emailLabel.textColor = .black
        locationLabel.textColor = .black
        socialLabel.textColor = .black
    }
    
    @objc func telegramLinkTap(_ sender: UITapGestureRecognizer) {
        if let url = URL(string: "https://t.me/suonvicheak") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func linkedinLinkTap(_ sender: UITapGestureRecognizer) {
        if let url = URL(string: "https://www.linkedin.com/in/suon-vicheak-68a738283/") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func webLinkTap(_ sender: UITapGestureRecognizer) {
        if let url = URL(string: "https://portfolio.cheakautomate.online/") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func facebookLinkTap(_ sender: UITapGestureRecognizer) {
        if let url = URL(string: "https://portfolio.cheakautomate.online/") {
            UIApplication.shared.open(url)
        }
    }
                                            
    @objc func phoneLinkTap(_ sender: UITapGestureRecognizer) {
        let phoneNumber = "tel://089738460"
        if let url = URL(string: phoneNumber) {
            // Check if the device can open the URL
            if UIApplication.shared.canOpenURL(url) {
                // Open the URL to initiate the phone call
                UIApplication.shared.open(url)
            } else {
                 // Handle the case where the device cannot make phone calls
                let alert = UIAlertController(title: "Error", message: "Your device cannot make phone calls.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func emailLinkTap(_ sender: UITapGestureRecognizer) {
        let email = "suonvicheak991@gmail.com"
        if let url = URL(string: "mailto:\(email)") {
            // Check if the device can open the URL
            if UIApplication.shared.canOpenURL(url) {
                // Open the URL to initiate the email
                UIApplication.shared.open(url)
            } else {
                // Handle the case where the device cannot send emails
                let alert = UIAlertController(title: "Error", message: "Your device cannot send emails.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        }
    }

}
