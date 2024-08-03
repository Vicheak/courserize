//
//  SettingViewController.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 28/7/24.
//

import UIKit
import Localize_Swift

class SettingViewController: UIViewController {

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
    }
    
    @objc func setText(){
        titleLabel.text = "Settings".localized(using: "ScreenTitles")
        titleLabel.font = UIFont(name: "KhmerOSBattambang-Bold", size: 18)
        titleLabel.textAlignment = .center
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
        
        tableView.reloadData()
    }
    
    func setUpViews(){
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
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

extension SettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "SettingScreen", bundle: nil)
        var viewController = UIViewController()
        if indexPath.row == 0 {
            viewController = storyboard.instantiateViewController(withIdentifier: "AboutUsViewController")
        } else if indexPath.row == 1 {
            return
        } else if indexPath.row == 2  {
            viewController = storyboard.instantiateViewController(withIdentifier: "LanguageViewController")
        } else if indexPath.row == 3  {
            viewController = storyboard.instantiateViewController(withIdentifier: "ThemeViewController")
        } else if indexPath.row == 4  {
            viewController = storyboard.instantiateViewController(withIdentifier: "ContactViewController")
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

extension SettingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let theme = ThemeManager.shared.theme
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "prototype1", for: indexPath) as? SettingTableViewCell else { return UITableViewCell() }
            cell.contentView.backgroundColor = theme.view.backgroundColor
            cell.titleLabel.textColor = theme.label.primaryColor
            cell.settingImageView.image = UIImage(named: "dev-profile")!
            cell.titleLabel.text = "About Us".localized(using: "Generals")
            return cell
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "prototype2", for: indexPath) as? SettingNotificationTableViewCell else { return UITableViewCell() }
            cell.contentView.backgroundColor = theme.view.backgroundColor
            cell.titleLabel.textColor = theme.label.primaryColor
            cell.settingImageView.tintColor = theme.imageView.tintColor
            cell.settingImageView.image = UIImage(systemName: "envelope.open")
            cell.titleLabel.text = "Notification".localized(using: "Generals")
            return cell
        } else if indexPath.row == 2  {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "prototype1", for: indexPath) as? SettingTableViewCell else { return UITableViewCell() }
            cell.contentView.backgroundColor = theme.view.backgroundColor
            cell.titleLabel.textColor = theme.label.primaryColor
            cell.settingImageView.tintColor = theme.imageView.tintColor
            cell.settingImageView.image = UIImage(systemName: "textformat")
            cell.titleLabel.text = "Language".localized(using: "Generals")
            return cell
        } else if indexPath.row == 3  {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "prototype1", for: indexPath) as? SettingTableViewCell else { return UITableViewCell() }
            cell.contentView.backgroundColor = theme.view.backgroundColor
            cell.titleLabel.textColor = theme.label.primaryColor
            cell.settingImageView.tintColor = theme.imageView.tintColor
            cell.settingImageView.image = UIImage(systemName: "sun.min")
            cell.titleLabel.text = "Theme".localized(using: "Generals")
            return cell
        } else if indexPath.row == 4  {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "prototype1", for: indexPath) as? SettingTableViewCell else { return UITableViewCell() }
            cell.contentView.backgroundColor = theme.view.backgroundColor
            cell.titleLabel.textColor = theme.label.primaryColor
            cell.settingImageView.tintColor = theme.imageView.tintColor
            cell.settingImageView.image = UIImage(systemName: "phone.bubble")
            cell.titleLabel.text = "Contact".localized(using: "Generals")
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
}
