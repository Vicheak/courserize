//
//  HomeViewController.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 30/7/24.
//

import UIKit
import SnapKit
import Localize_Swift
import KeychainSwift
import SkeletonView

class HomeViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var profileButton: UIBarButtonItem!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var settingButton: UIBarButtonItem!
    @IBOutlet weak var categoryCollectionContainer: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var categoryShowAll: UILabel!
    @IBOutlet weak var mainStackView: UIStackView!
    //for categories
    var courseCollectionContainer1: UIView!
    var courseCollectionContainer2: UIView!
    var courseCollectionContainer3: UIView!
    var courseCollectionContainer4: UIView!
    var courseCollectionContainer5: UIView!
    var courseCollectionContainer6: UIView!
    var courseCollectionContainer7: UIView!
    var courseCollectionContainer8: UIView!
    var courseCollectionContainer9: UIView!
    var courseCollectionContainer10: UIView!
    var courseCollectionContainer11: UIView!
    
    private var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up each category view
        courseCollectionContainer1 = CourseContainerView(withTitle: "Programming", withCategory: "Programming")
        courseCollectionContainer2 = CourseContainerView(withTitle: "Software Delevelopment", withCategory: "Software Delevelopment")
        courseCollectionContainer3 = CourseContainerView(withTitle: "Trend and Modern Technologies", withCategory: "Trend and Modern Technologies")
        courseCollectionContainer4 = CourseContainerView(withTitle: "Basic Coding", withCategory: "Basic Coding")
        courseCollectionContainer5 = CourseContainerView(withTitle: "General Computer and Office", withCategory: "General Computer and Office")
        courseCollectionContainer6 = CourseContainerView(withTitle: "Mathematics", withCategory: "Mathematics")
        courseCollectionContainer7 = CourseContainerView(withTitle: "English", withCategory: "English")
        courseCollectionContainer8 = CourseContainerView(withTitle: "Khmer", withCategory: "Khmer")
        courseCollectionContainer9 = CourseContainerView(withTitle: "Exam Preparation", withCategory: "Exam Preparation")
        courseCollectionContainer10 = CourseContainerView(withTitle: "General Knowledge", withCategory: "General Knowledge")
        courseCollectionContainer11 = CourseContainerView(withTitle: "Specialization", withCategory: "Specialization")
        
        setUpViews()
        
        self.setText()
    
        profileButton.target = self
        profileButton.action = #selector(profileButtonTapped)
        settingButton.target = self
        settingButton.action = #selector(settingButtonTapped)
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        scrollView.addSubview(refreshControl)
        
        self.setColor()
        NotificationCenter.default.addObserver(self, selector: #selector(setColor), name: .changeTheme, object: nil)
        
        setUpCategoryCollectionView()
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
        
        mainStackView.addArrangedSubview(courseCollectionContainer1)
        courseCollectionContainer1.snp.makeConstraints { make in
            make.height.equalTo(330)
        }

        mainStackView.addArrangedSubview(courseCollectionContainer2)
        courseCollectionContainer2.snp.makeConstraints { make in
            make.height.equalTo(330)
        }
        
        mainStackView.addArrangedSubview(courseCollectionContainer3)
        courseCollectionContainer3.snp.makeConstraints { make in
            make.height.equalTo(330)
        }
        
        mainStackView.addArrangedSubview(courseCollectionContainer4)
        courseCollectionContainer4.snp.makeConstraints { make in
            make.height.equalTo(330)
        }
        
        mainStackView.addArrangedSubview(courseCollectionContainer5)
        courseCollectionContainer5.snp.makeConstraints { make in
            make.height.equalTo(330)
        }
        
        mainStackView.addArrangedSubview(courseCollectionContainer6)
        courseCollectionContainer6.snp.makeConstraints { make in
            make.height.equalTo(330)
        }
        
        mainStackView.addArrangedSubview(courseCollectionContainer7)
        courseCollectionContainer7.snp.makeConstraints { make in
            make.height.equalTo(330)
        }
        
        mainStackView.addArrangedSubview(courseCollectionContainer8)
        courseCollectionContainer8.snp.makeConstraints { make in
            make.height.equalTo(330)
        }
        
        mainStackView.addArrangedSubview(courseCollectionContainer9)
        courseCollectionContainer9.snp.makeConstraints { make in
            make.height.equalTo(330)
        }
        
        mainStackView.addArrangedSubview(courseCollectionContainer10)
        courseCollectionContainer10.snp.makeConstraints { make in
            make.height.equalTo(330)
        }
        
        mainStackView.addArrangedSubview(courseCollectionContainer11)
        courseCollectionContainer11.snp.makeConstraints { make in
            make.height.equalTo(330)
        }
    }
    
    @objc func setText(){
        categoryLabel.text = "Course Categories".localized(using: "Generals")
        categoryLabel.font = UIFont(name: "KhmerOSBattambang-Bold", size: 17)
        categoryShowAll.text = "Show All".localized(using: "Generals")
        categoryShowAll.font = UIFont(name: "KhmerOSBattambang-Bold", size: 17)
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
    }
    
    func setUpCategoryCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 200, height: 50)
        
        categoryCollectionView.collectionViewLayout = layout
        categoryCollectionView.showsHorizontalScrollIndicator = false
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        categoryCollectionView.reloadData()
    }
    
    
    @objc private func refreshData() {
        NotificationCenter.default.post(name: NSNotification.Name.refreshData, object: nil)
        refreshControl.endRefreshing()
    }

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            return 11
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellPrototype1", for: indexPath) as! CategoryCollectionViewCell
            let theme = ThemeManager.shared.theme
            cell.categoryImageView.tintColor = theme.imageView.tintColor
            cell.contentView.backgroundColor = UIColor(rgb: 0x808080, alpha: 0.15)
            cell.contentView.layer.cornerRadius = 5
                    
            if #available(iOS 13.0, *) {
                switch indexPath.row {
                case 0:
                    cell.categoryTitle.text = "Programming"
                    cell.categoryImageView.image = UIImage(systemName: "laptopcomputer")
                case 1:
                    cell.categoryTitle.text = "Mathematics"
                    cell.categoryImageView.image = UIImage(systemName: "numbersign")
                case 2:
                    cell.categoryTitle.text = "English"
                    cell.categoryImageView.image = UIImage(systemName: "textformat")
                case 3:
                    cell.categoryTitle.text = "Khmer"
                    cell.categoryImageView.image = UIImage(systemName: "doc.text.fill")
                case 4:
                    cell.categoryTitle.text = "Exam Preparation"
                    cell.categoryImageView.image = UIImage(systemName: "pencil.line")
                case 5:
                    cell.categoryTitle.text = "General Knowledge"
                    cell.categoryImageView.image = UIImage(systemName: "pencil.and.list.clipboard")
                case 6:
                    cell.categoryTitle.text = "Basic Coding"
                    cell.categoryImageView.image = UIImage(systemName: "laptopcomputer")
                case 7:
                    cell.categoryTitle.text = "General Computer and Office"
                    cell.categoryImageView.image = UIImage(systemName: "laptopcomputer.and.arrow.down")
                case 8:
                    cell.categoryTitle.text = "Specialization"
                    cell.categoryImageView.image = UIImage(systemName: "pencil.and.outline")
                case 9:
                    cell.categoryTitle.text = "Trend and Modern Technologies"
                    cell.categoryImageView.image = UIImage(systemName: "mosaic.fill")
                case 10:
                    cell.categoryTitle.text = "Software Development"
                    cell.categoryImageView.image = UIImage(systemName: "laptopcomputer")
                default:
                    break
                }
            }
            return cell
            
        }
        
        return UICollectionViewCell()
    }
   
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
    }
    
}
