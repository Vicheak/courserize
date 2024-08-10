//
//  LanguageViewController.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 2/8/24.
//

import UIKit
import Localize_Swift

class LanguageViewController: UIViewController {
    
    let titleLabel = UILabel()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        
        self.setText()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.setColor()
        NotificationCenter.default.addObserver(self, selector: #selector(setColor), name: .changeTheme, object: nil)
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
        titleLabel.text = "Language".localized(using: "Generals")
        titleLabel.font = UIFont(name: "KhmerOSBattambang-Bold", size: 18)
        titleLabel.textAlignment = .center
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
        
        tableView.reloadData()
    }
    
    func setUpViews(){
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
    }
    
    @objc func setColor() {
        let theme = ThemeManager.shared.theme
        view.backgroundColor = theme.view.backgroundColor
        titleLabel.textColor = theme.label.primaryColor
        tableView.backgroundColor = theme.view.backgroundColor
        tableView.separatorColor = theme.label.primaryColor
        
        tableView.reloadData()
    }

}

extension LanguageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            Localize.setCurrentLanguage("km")
            UserDefaults.standard.setValue("km", forKey: "language")
        } else if indexPath.row == 1 {
            Localize.setCurrentLanguage("en")
            UserDefaults.standard.setValue("en", forKey: "language")
        }
    }
    
}

extension LanguageViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "prototype1", for: indexPath) as? LanguageTableViewCell else { return UITableViewCell() }
        let theme = ThemeManager.shared.theme
        cell.contentView.backgroundColor = theme.view.backgroundColor
        cell.innerView.backgroundColor = theme.view.backgroundColor
        cell.languageTitle.textColor = theme.label.primaryColor
        cell.languageImageView.tintColor = theme.imageView.tintColor
        cell.languageImageViewCheck.tintColor = theme.imageView.tintColor
        if indexPath.row == 0 {
            cell.languageImageView.image = UIImage(named: "cambodia-logo")!
            cell.languageTitle.text = "Khmer".localized(using: "Generals")
            if #available(iOS 13.0, *) {
                cell.languageImageViewCheck.image = Localize.currentLanguage() == "km" ? UIImage(systemName: "checkmark") : nil
            }
            return cell
        } else if indexPath.row == 1 {
            cell.languageImageView.image = UIImage(named: "usa-logo")!
            cell.languageTitle.text = "English".localized(using: "Generals")
            if #available(iOS 13.0, *) {
                cell.languageImageViewCheck.image = Localize.currentLanguage() == "en" ? UIImage(systemName: "checkmark") : nil
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
}
