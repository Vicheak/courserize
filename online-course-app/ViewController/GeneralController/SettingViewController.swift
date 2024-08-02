//
//  SettingViewController.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 28/7/24.
//

import UIKit
import Localize_Swift

class SettingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        
        self.setText()
        
        tableView.delegate = self
        tableView.dataSource = self
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
        navigationItem.title = "Settings".localized(using: "ScreenTitles")
    
    }
    
    func setUpViews(){
        let titleLabel = UILabel()
        titleLabel.text = "Settings".localized(using: "ScreenTitles")
        titleLabel.font = UIFont(name: "KhmerOSBattambang-Bold", size: 18)
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
        
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
    }

}

extension SettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            let storyboard = UIStoryboard(name: "SettingScreen", bundle: nil)
            let aboutUsViewController = storyboard.instantiateViewController(withIdentifier: "AboutUsViewController")
            navigationController?.pushViewController(aboutUsViewController, animated: true)
        } else if indexPath.row == 1 {
           
        } else if indexPath.row == 2  {
           
        } else if indexPath.row == 3  {
         
        } else if indexPath.row == 4  {
           
        }
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
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "prototype1", for: indexPath) as? SettingTableViewCell else { return UITableViewCell() }
            cell.settingImageView.image = UIImage(named: "dev-profile")!
            cell.titleLabel.text = "About Us".localized(using: "Generals")
            return cell
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "prototype2", for: indexPath) as? SettingNotificationTableViewCell else { return UITableViewCell() }
            cell.settingImageView.image = UIImage(named: "notification-icon")!
            cell.titleLabel.text = "Notification".localized(using: "Generals")
            return cell
        } else if indexPath.row == 2  {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "prototype1", for: indexPath) as? SettingTableViewCell else { return UITableViewCell() }
            cell.settingImageView.image = UIImage(named: "language-icon")!
            cell.titleLabel.text = "Language".localized(using: "Generals")
            return cell
        } else if indexPath.row == 3  {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "prototype1", for: indexPath) as? SettingTableViewCell else { return UITableViewCell() }
            cell.settingImageView.image = UIImage(systemName: "sun.min")
            cell.settingImageView.tintColor = .black
            cell.titleLabel.text = "Theme".localized(using: "Generals")
            return cell
        } else if indexPath.row == 4  {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "prototype1", for: indexPath) as? SettingTableViewCell else { return UITableViewCell() }
            cell.settingImageView.image = UIImage(systemName: "phone.bubble")
            cell.settingImageView.tintColor = .black
            cell.titleLabel.text = "Contact".localized(using: "Generals")
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
}
