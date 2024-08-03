//
//  ThemeViewController.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 2/8/24.
//

import UIKit
import Localize_Swift

class ThemeViewController: UIViewController {

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
        titleLabel.text = "Theme".localized(using: "Generals")
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

extension ThemeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            ThemeManager.shared.applyTheme(type: .night)
            UserDefaults.standard.setValue(Theme.night.rawValue, forKey: "mode")
        } else if indexPath.row == 1 {
            ThemeManager.shared.applyTheme(type: .day)
            UserDefaults.standard.setValue(Theme.day.rawValue, forKey: "mode")
        } else if indexPath.row == 2 {
            ThemeManager.shared.applyTheme(type: .system)
            UserDefaults.standard.setValue(Theme.system.rawValue, forKey: "mode")
        }
        
        tableView.reloadData()
    }
    
}

extension ThemeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "prototype1", for: indexPath) as? ThemeTableViewCell else { return UITableViewCell() }
        let theme = ThemeManager.shared.theme
        let themeType = ThemeManager.shared.themeType
        cell.contentView.backgroundColor = theme.view.backgroundColor
        cell.innerView.backgroundColor = theme.view.backgroundColor
        cell.themeTitle.textColor = theme.label.primaryColor
        cell.themeImageView.tintColor = theme.imageView.tintColor
        cell.themeImageViewCheck.tintColor = theme.imageView.tintColor
        if indexPath.row == 0 {
            cell.themeImageView.image = UIImage(systemName: "moon")
            cell.themeTitle.text = "Dark".localized(using: "Generals")
            cell.themeImageViewCheck.image = themeType == .night ? UIImage(systemName: "checkmark") : nil
            return cell
        } else if indexPath.row == 1 {
            cell.themeImageView.image = UIImage(systemName: "sun.min")
            cell.themeTitle.text = "Light".localized(using: "Generals")
            cell.themeImageViewCheck.image = themeType == .day ? UIImage(systemName: "checkmark") : nil
            return cell
        } else if indexPath.row == 2 {
            cell.themeImageView.image = UIImage(systemName: "laptopcomputer")
            cell.themeTitle.text = "System".localized(using: "Generals")
            cell.themeImageViewCheck.image = themeType == .system ? UIImage(systemName: "checkmark") : nil
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
}

