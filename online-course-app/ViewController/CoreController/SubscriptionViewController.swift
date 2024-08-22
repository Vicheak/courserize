//
//  SubscriptionViewController.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 5/8/24.
//

import UIKit
import Localize_Swift
import KeychainSwift
import SkeletonView

class SubscriptionViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var profileButton: UIBarButtonItem!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var settingButton: UIBarButtonItem!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var subscriptionDetailView: UIView!
    @IBOutlet weak var subscriptionDetailTitle: UILabel!
    @IBOutlet weak var subscriptionDetailDesc: UILabel!
    @IBOutlet weak var subscriptionRequestView: UIView!
    @IBOutlet weak var subscriptionRequestTitle: UILabel!
    @IBOutlet weak var subscriptionRequestDesc: UILabel!
    @IBOutlet weak var applyForAuthorView: UIView!
    @IBOutlet weak var applyForAuthorTitle: UILabel!
    @IBOutlet weak var applyForAuthorDesc: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        
        self.setText()
    
        profileButton.target = self
        profileButton.action = #selector(profileButtonTapped)
        settingButton.target = self
        settingButton.action = #selector(settingButtonTapped)
        searchButton.target = self
        searchButton.action = #selector(searchButtonTapped)
        
        subscriptionDetailView.isUserInteractionEnabled = true
        subscriptionDetailView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(subscriptionDetailViewTapped)))
        
        subscriptionRequestView.isUserInteractionEnabled = true
        subscriptionRequestView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(subscriptionRequestViewTapped)))
        
        applyForAuthorView.isUserInteractionEnabled = true
        applyForAuthorView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(applyForAuthorViewTapped)))
        
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
    
    func setUpViews(){        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        subscriptionDetailView.layer.cornerRadius = 6
        subscriptionDetailView.layer.borderWidth = 0.3
        subscriptionRequestView.layer.cornerRadius = 6
        subscriptionRequestView.layer.borderWidth = 0.3
        applyForAuthorView.layer.cornerRadius = 6
        applyForAuthorView.layer.borderWidth = 0.3
    }
    
    @objc func setText(){
        subscriptionDetailTitle.font = UIFont(name: "KhmerOSBattambang-Bold", size: 14)
        subscriptionRequestTitle.font = UIFont(name: "KhmerOSBattambang-Bold", size: 14)
        applyForAuthorTitle.font = UIFont(name: "KhmerOSBattambang-Bold", size: 14)
        
        subscriptionDetailTitle.text = "Subscription Detail".localized(using: "Generals")
        subscriptionDetailDesc.text = "Check your subscription detail".localized(using: "Generals")
        subscriptionRequestTitle.text = "Acknowledge Subscription".localized(using: "Generals")
        subscriptionRequestDesc.text = "Check the subscription request".localized(using: "Generals")
        applyForAuthorTitle.text = "Apply for Author".localized(using: "Generals")
        applyForAuthorDesc.text = "Manage courses with author permission".localized(using: "Generals")
    }
    
    @objc func profileButtonTapped(){
        let storyboard = UIStoryboard(name: "CoreScreen", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "UserViewController")
        let navUserViewController = BaseNavigationController(rootViewController: viewController)
        navUserViewController.modalPresentationStyle = .fullScreen
        present(navUserViewController, animated: true)
    }
    
    @objc func settingButtonTapped(){
        let storyboard = UIStoryboard(name: "AuthScreen", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SettingViewController")
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func searchButtonTapped(){
        let storyboard = UIStoryboard(name: "CoreScreen", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SearchCourseViewController")
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func setColor() {
        let theme = ThemeManager.shared.theme
        view.backgroundColor = theme.view.backgroundColor
        mainView.backgroundColor = theme.view.backgroundColor
        subscriptionDetailView.layer.borderColor = theme.label.primaryColor.cgColor
        subscriptionRequestView.layer.borderColor = theme.label.primaryColor.cgColor
        applyForAuthorView.layer.borderColor = theme.label.primaryColor.cgColor
    }
    
    @objc func subscriptionDetailViewTapped(){
        let storyboard = UIStoryboard(name: "CoreScreen", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SubscriptionDetailViewController")
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func subscriptionRequestViewTapped(){
        let storyboard = UIStoryboard(name: "CoreScreen", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SubscriptionAuthorViewController")
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func applyForAuthorViewTapped(){
        
    }

}
