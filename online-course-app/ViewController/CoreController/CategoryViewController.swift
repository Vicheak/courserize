//
//  CategoryViewController.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 5/8/24.
//

import UIKit
import Localize_Swift
import KeychainSwift
import SkeletonView

class CategoryViewController: UIViewController {

    @IBOutlet weak var profileButton: UIBarButtonItem!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var settingButton: UIBarButtonItem!
    @IBOutlet weak var categoryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        
        self.setText()
        
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
    
        profileButton.target = self
        profileButton.action = #selector(profileButtonTapped)
        settingButton.target = self
        settingButton.action = #selector(settingButtonTapped)
        
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
        categoryTableView.showsHorizontalScrollIndicator = false
        categoryTableView.showsVerticalScrollIndicator = false
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
    
    @objc func setColor() {
        let theme = ThemeManager.shared.theme
        view.backgroundColor = theme.view.backgroundColor
        categoryTableView.backgroundColor = theme.view.backgroundColor
        
        categoryTableView.reloadData()
    }

}

extension CategoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "CoreScreen", bundle: nil)
        let categoryCourseViewController = storyboard.instantiateViewController(withIdentifier: "CategoryCourseViewController") as! CategoryCourseViewController
        categoryCourseViewController.hidesBottomBarWhenPushed = true
        if indexPath.row == 0 {
            categoryCourseViewController.category = "Programming"
        } else if indexPath.row == 1 {
            categoryCourseViewController.category = "Mathematics"
        } else if indexPath.row == 2 {
            categoryCourseViewController.category = "English"
        } else if indexPath.row == 3 {
            categoryCourseViewController.category = "Khmer"
        } else if indexPath.row == 4 {
            categoryCourseViewController.category = "Exam Preparation"
        } else if indexPath.row == 5 {
            categoryCourseViewController.category = "General Knowledge"
        } else if indexPath.row == 6 {
            categoryCourseViewController.category = "Basic Coding"
        } else if indexPath.row == 7 {
            categoryCourseViewController.category = "General Computer and Office"
        } else if indexPath.row == 8 {
            categoryCourseViewController.category = "Specialization"
        } else if indexPath.row == 9 {
            categoryCourseViewController.category = "Trend and Modern Technologies"
        } else if indexPath.row == 10 {
            categoryCourseViewController.category = "Software Delevelopment"
        } else {
            categoryCourseViewController.category = "Programming"
        }
        navigationController?.pushViewController(categoryCourseViewController, animated: true)
    }
    
}

extension CategoryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "prototype1", for: indexPath) as? CategoryTableViewCell else { return UITableViewCell() }
        let theme = ThemeManager.shared.theme
        cell.contentView.backgroundColor = theme.view.backgroundColor
        cell.categoryNameLabel.textColor = theme.label.primaryColor
        cell.categoryImageView.tintColor = theme.imageView.tintColor
      
        if #available(iOS 13.0, *) {
            if indexPath.row == 0 {
                cell.categoryNameLabel.text = "Programming"
                cell.categoryImageView.image = UIImage(systemName: "laptopcomputer")
                return cell
            } else if indexPath.row == 1 {
                cell.categoryNameLabel.text = "Mathematics"
                cell.categoryImageView.image = UIImage(systemName: "numbersign")
                return cell
            } else if indexPath.row == 2 {
                cell.categoryNameLabel.text = "English"
                cell.categoryImageView.image = UIImage(systemName: "textformat")
                return cell
            } else if indexPath.row == 3 {
                cell.categoryNameLabel.text = "Khmer"
                cell.categoryImageView.image = UIImage(systemName: "doc.text.fill")
                return cell
            } else if indexPath.row == 4 {
                cell.categoryNameLabel.text = "Exam Preparation"
                cell.categoryImageView.image = UIImage(systemName: "pencil.line")
                return cell
            } else if indexPath.row == 5 {
                cell.categoryNameLabel.text = "General Knowledge"
                cell.categoryImageView.image = UIImage(systemName: "pencil.and.list.clipboard")
                return cell
            } else if indexPath.row == 6 {
                cell.categoryNameLabel.text = "Basic Coding"
                cell.categoryImageView.image = UIImage(systemName: "laptopcomputer")
                return cell
            } else if indexPath.row == 7 {
                cell.categoryNameLabel.text = "General Computer and Office"
                cell.categoryImageView.image = UIImage(systemName: "laptopcomputer.and.arrow.down")
                return cell
            } else if indexPath.row == 8 {
                cell.categoryNameLabel.text = "Specialization"
                cell.categoryImageView.image = UIImage(systemName: "pencil.and.outline")
                return cell
            } else if indexPath.row == 9 {
                cell.categoryNameLabel.text = "Trend and Modern Technologies"
                cell.categoryImageView.image = UIImage(systemName: "mosaic.fill")
                return cell
            } else if indexPath.row == 10 {
                cell.categoryNameLabel.text = "Software Delevelopment"
                cell.categoryImageView.image = UIImage(systemName: "laptopcomputer")
                return cell
            } else {
                return UITableViewCell()
            }
        } else {
            return UITableViewCell()
        }
    }
    
}
