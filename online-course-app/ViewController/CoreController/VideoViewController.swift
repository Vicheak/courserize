//
//  VideoViewController.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 5/8/24.
//

import UIKit
import Localize_Swift
import KeychainSwift
import SkeletonView

class VideoViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var profileButton: UIBarButtonItem!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var settingButton: UIBarButtonItem!
    @IBOutlet weak var stackView: UIStackView!
    
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
    }
    
    @objc func setText(){
        
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
    }

}
