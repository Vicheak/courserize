//
//  AboutUsViewController.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 2/8/24.
//

import UIKit

class AboutUsViewController: UIViewController {

    let navTitleLabel = UILabel()
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navTitleLabel.text = "About Us".localized(using: "Generals")
        navTitleLabel.font = UIFont(name: "KhmerOSBattambang-Bold", size: 18)
        navTitleLabel.textAlignment = .center
        navTitleLabel.sizeToFit()
        navigationItem.titleView = navTitleLabel
        
        self.setColor()
        NotificationCenter.default.addObserver(self, selector: #selector(setColor), name: .changeTheme, object: nil)
    }
    
    @objc func setColor() {
        let theme = ThemeManager.shared.theme
        view.backgroundColor = theme.view.backgroundColor
        mainView.backgroundColor = theme.view.backgroundColor
        navTitleLabel.textColor = theme.label.primaryColor
        titleLabel.textColor = theme.label.primaryColor
        textLabel.textColor = theme.label.primaryColor
    }

}
