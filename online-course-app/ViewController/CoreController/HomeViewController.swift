//
//  HomeViewController.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 30/7/24.
//

import UIKit
import Localize_Swift
import KeychainSwift

class HomeViewController: UIViewController {

    @IBOutlet weak var profileButton: UIBarButtonItem!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var settingButton: UIBarButtonItem!
    @IBOutlet weak var categoryCollectionContainer: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setText()
    
        profileButton.target = self
        profileButton.action = #selector(profileButtonTapped)
        settingButton.target = self
        settingButton.action = #selector(settingButtonTapped)
        
        self.setColor()
        NotificationCenter.default.addObserver(self, selector: #selector(setColor), name: .changeTheme, object: nil)
        
        setUpCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc func setText(){
        categoryLabel.text = "Course Categories".localized(using: "Generals")
        categoryLabel.font = UIFont(name: "KhmerOSBattambang-Bold", size: 17)
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
        categoryCollectionContainer.backgroundColor = theme.view.backgroundColor
        categoryCollectionView.backgroundColor = theme.view.backgroundColor
        categoryLabel.textColor = theme.label.primaryColor
        
        categoryCollectionView.reloadData()
    }
    
    func setUpCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 200, height: 50)
        
        categoryCollectionView.collectionViewLayout = layout
        categoryCollectionView.showsHorizontalScrollIndicator = false
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return 11
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellPrototype1", for: indexPath) as! CategoryCollectionViewCell
        let theme = ThemeManager.shared.theme
        cell.categoryImageView.tintColor = theme.imageView.tintColor
        cell.contentView.backgroundColor = UIColor(rgb: 0x808080, alpha: 0.15)
        cell.contentView.layer.cornerRadius = 5
        if indexPath.row == 0 {
            cell.categoryTitle.text = "Programming"
            if #available(iOS 13.0, *) {
                cell.categoryImageView.image = UIImage(systemName: "laptopcomputer")
            }
        } else if indexPath.row == 1 {
            cell.categoryTitle.text = "Mathematics"
            if #available(iOS 13.0, *) {
                cell.categoryImageView.image = UIImage(systemName: "numbersign")
            }
        } else if indexPath.row == 2 {
            cell.categoryTitle.text = "English"
            if #available(iOS 13.0, *) {
                cell.categoryImageView.image = UIImage(systemName: "textformat")
            }
        } else if indexPath.row == 3 {
            cell.categoryTitle.text = "Khmer"
            if #available(iOS 13.0, *) {
                cell.categoryImageView.image = UIImage(systemName: "doc.text.fill")
            }
        } else if indexPath.row == 4 {
            cell.categoryTitle.text = "Exam Preparation"
            if #available(iOS 13.0, *) {
                cell.categoryImageView.image = UIImage(systemName: "pencil.line")
            }
        } else if indexPath.row == 5 {
            cell.categoryTitle.text = "General Knowledge"
            if #available(iOS 13.0, *) {
                cell.categoryImageView.image = UIImage(systemName: "pencil.and.list.clipboard")
            }
        } else if indexPath.row == 6 {
            cell.categoryTitle.text = "Basic Coding"
            if #available(iOS 13.0, *) {
                cell.categoryImageView.image = UIImage(systemName: "laptopcomputer")
            }
        } else if indexPath.row == 7 {
            cell.categoryTitle.text = "General Computer and Office"
            if #available(iOS 13.0, *) {
                cell.categoryImageView.image = UIImage(systemName: "laptopcomputer.and.arrow.down")
            }
        } else if indexPath.row == 8 {
            cell.categoryTitle.text = "Specialization"
            if #available(iOS 13.0, *) {
                cell.categoryImageView.image = UIImage(systemName: "pencil.and.outline")
            }
        } else if indexPath.row == 9 {
            cell.categoryTitle.text = "Trend and Modern Technologies"
            if #available(iOS 13.0, *) {
                cell.categoryImageView.image = UIImage(systemName: "mosaic.fill")
            }
        } else if indexPath.row == 10 {
            cell.categoryTitle.text = "Software Delevelopment"
            if #available(iOS 13.0, *) {
                cell.categoryImageView.image = UIImage(systemName: "laptopcomputer")
            }
        }
        return cell
    }
   
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
    }
    
}
