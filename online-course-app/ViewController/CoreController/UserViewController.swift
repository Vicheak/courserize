//
//  UserViewController.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 5/8/24.
//

import UIKit
import Localize_Swift

class UserViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userPhone: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        
        self.setText()

        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
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
    
    @objc func setText() {
        titleLabel.text = "Account".localized(using: "Generals")
    }

    private func setUpViews(){
        titleLabel.font = UIFont(name: "KhmerOSBattambang-Bold", size: 18)
        
        let email = UserDefaults.standard.string(forKey: "email")!
        userEmail.text = email
    }
    
    @objc func setColor() {
//        let theme = ThemeManager.shared.theme
//        view.backgroundColor = theme.view.backgroundColor
    }
    
    @objc func closeButtonTapped(){
        let alertCotroller = UIAlertController(title: "Confrim", message: "Are you sure to log out?", preferredStyle: .alert)
        alertCotroller.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        alertCotroller.addAction(UIAlertAction(title: "Log out", style: .default, handler: { _ in
            UserDefaults.standard.setValue(false, forKey: "isLogin")
            UIApplication.shared.showLoginViewController()
        }))
        present(alertCotroller, animated: true)
    }

}
