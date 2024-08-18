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

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var profileButton: UIBarButtonItem!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var settingButton: UIBarButtonItem!
    @IBOutlet weak var categoryCollectionContainer: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var categoryShowAll: UILabel!
    @IBOutlet weak var courseCollectionContainer: UIView!
    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var courseCollectionView: UICollectionView!
    @IBOutlet weak var courseShowAll: UILabel!
    
    private var featuredCourses: [CourseResponsePayload]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        
        self.setText()
    
        profileButton.target = self
        profileButton.action = #selector(profileButtonTapped)
        settingButton.target = self
        settingButton.action = #selector(settingButtonTapped)
        
        self.setColor()
        NotificationCenter.default.addObserver(self, selector: #selector(setColor), name: .changeTheme, object: nil)
        
        setUpCategoryCollectionView()
        setUpCourseCollectionView()
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
        categoryLabel.text = "Course Categories".localized(using: "Generals")
        categoryLabel.font = UIFont(name: "KhmerOSBattambang-Bold", size: 17)
        categoryShowAll.text = "Show All".localized(using: "Generals")
        categoryShowAll.font = UIFont(name: "KhmerOSBattambang-Bold", size: 17)
        courseLabel.text = "Featured Courses".localized(using: "Generals")
        courseLabel.font = UIFont(name: "KhmerOSBattambang-Bold", size: 17)
        courseShowAll.text = "Show All".localized(using: "Generals")
        courseShowAll.font = UIFont(name: "KhmerOSBattambang-Bold", size: 17)
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
        courseCollectionContainer.backgroundColor = theme.view.backgroundColor
        courseCollectionView.backgroundColor = theme.view.backgroundColor
        
        categoryCollectionView.reloadData()
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
    }
    
    func setUpCourseCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 200, height: 260)
        
        courseCollectionView.collectionViewLayout = layout
        courseCollectionView.showsHorizontalScrollIndicator = false
        courseCollectionView.delegate = self
        courseCollectionView.dataSource = self
        
        setUpCourseCollectionViewWithCategory(withCategoryName: "Programming") { [weak self] coursePayload in
            guard let self = self else { return }
            if !coursePayload.isEmpty {
                featuredCourses = coursePayload
                courseCollectionView.reloadData()
            }
        }
    }
    
    func setUpCourseCollectionViewWithCategory(withCategoryName categoryName: String, completion: @escaping ([CourseResponsePayload]) -> Void) {
        let keychain = KeychainSwift()
        let accessToken = keychain.get("accessToken")!
        CourseAPIService.shared.loadCourseByCategoryName(token: accessToken, withCategoryName: categoryName) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let result):
                completion(result.payload)
            case .failure(let error):
                print("Cannot get courses :", error.message)
                if error.code == 401 {
                    AuthAPIService.shared.shouldRefreshToken { didReceiveToken in
                        if didReceiveToken {
                            self.setUpCourseCollectionViewWithCategory(withCategoryName: categoryName, completion: completion)
                        } else {
                            print("Cannot refresh the token, something went wrong!")
                        }
                    }
                } else {
                    PopUpUtil.popUp(withTitle: "No Connection".localized(using: "Generals"), withMessage: error.message, withAlert: .warning) {}
                }
            }
        }
    }
    
    private func setUpCourseImage(imageUri: String, withImageView imageView: UIImageView){
        //load image from document directory
        let fileURL = URL(string: imageUri)!
        if let courseImage = FileUtil.loadImageFromDocumentDirectory(fileName: fileURL.lastPathComponent) {
            //set to user image view
            UIView.transition(with: imageView, duration: 1.5, options: [.curveEaseInOut]) {
                imageView.image = courseImage
            } completion: { _ in }
        } else {
            FileAPIService.shared.downloadImageAndSave(fileURL: imageUri) { [weak self] response in
                guard let self = self else { return }
                switch response {
                case .success(_):
                    setUpCourseImage(imageUri: imageUri, withImageView: imageView)
                case .failure(let error):
                    print("Error :", error)
                    //set to user image view
                    if #available(iOS 13.0, *) {
                        //set up loading
                    }
                }
            }
        }
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            return 11
        } else if collectionView == courseCollectionView {
            return featuredCourses?.count ?? 0
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
            
        } else if collectionView == courseCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellPrototype2", for: indexPath) as! CourseCollectionViewCell
            let theme = ThemeManager.shared.theme
            cell.courseImageView.tintColor = theme.imageView.tintColor
            cell.contentView.backgroundColor = UIColor(rgb: 0x808080, alpha: 0.05)
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.borderColor = UIColor(rgb: 0x808080, alpha: 0.2).cgColor
            cell.contentView.layer.cornerRadius = 3
            
            if !featuredCourses!.isEmpty {
                let course = featuredCourses?[indexPath.row]
                cell.courseTitle.text = course!.title
                cell.courseShortDescription.text = course!.description
                cell.coursePrice.text = "$\(String(describing: course!.cost))"
                cell.courseDuration.text = "/ \(String(describing: course!.durationInHour)) Hours"
                //set up course image
                if let imageUri = course?.imageUri {
                    setUpCourseImage(imageUri: imageUri, withImageView: cell.courseImageView)
                }
            }
                
            return cell
        }
        
        return UICollectionViewCell()
    }
   
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
    }
    
}
