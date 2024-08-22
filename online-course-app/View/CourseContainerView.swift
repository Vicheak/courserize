//
//  CourseContainerView.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 18/8/24.
//

import UIKit
import SnapKit
import KeychainSwift
import SkeletonView

class CourseContainerView: UIView {
    
    var navController: UINavigationController!
    var courseLabel = UILabel()
    var courseShowAll = UILabel()
    var courseCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private var category: String!
    private var courses: [CourseResponsePayload]?
    
    init(withTitle title: String, withCategory category: String, withNavController navController: UINavigationController) {
        super.init(frame: .zero)
        setUpViews(withTitle: title)
        self.category = category
        self.navController = navController
        
        // Register the cell using its nib
        let nib = UINib(nibName: "MainCourseCollectionViewCell", bundle: nil)
        courseCollectionView.register(nib, forCellWithReuseIdentifier: "courseCellPrototype")
                
        self.setColor()
        NotificationCenter.default.addObserver(self, selector: #selector(setColor), name: .changeTheme, object: nil)
        
        setUpCourseCollectionView(withCategoryName: category)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name.refreshData, object: nil)
        
        courseShowAll.isUserInteractionEnabled = true
        courseShowAll.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showAllCoursesTapped)))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUpViews(withTitle title: String){
        courseLabel.text = title.localized(using: "Generals")
        courseLabel.font = UIFont(name: "KhmerOSBattambang-Bold", size: 17)
        courseShowAll.text = "Show All".localized(using: "Generals")
        courseShowAll.font = UIFont(name: "KhmerOSBattambang-Bold", size: 17)
        courseShowAll.textColor = .systemGreen
        self.addSubview(courseLabel)
        self.addSubview(courseCollectionView)
        self.addSubview(courseShowAll)
    
        courseLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(10)
        }
    
        courseCollectionView.snp.makeConstraints { make in
            make.top.equalTo(courseLabel.snp.bottom).offset(10)
            make.leading.bottom.trailing.equalToSuperview()
        }
        
        courseShowAll.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
    
    @objc func setColor() {
        let theme = ThemeManager.shared.theme
        self.backgroundColor = theme.view.backgroundColor
        courseCollectionView.backgroundColor = theme.view.backgroundColor
        courseLabel.textColor = theme.label.primaryColor
        
        courseCollectionView.reloadData()
    }
    
    func setUpCourseCollectionView(withCategoryName categoryName: String){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 200, height: 260)
        
        courseCollectionView.collectionViewLayout = layout
        courseCollectionView.showsHorizontalScrollIndicator = false
        courseCollectionView.delegate = self
        courseCollectionView.dataSource = self
        
        refreshData()
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
                    if #available(iOS 13.0, *) {
                        //set up loading
                        imageView.isSkeletonable = true
                        imageView.showAnimatedGradientSkeleton()
                    }
                }
            }
        }
    }
    
    @objc func refreshData(){
        setUpCourseCollectionViewWithCategory(withCategoryName: category) { [weak self] coursePayload in
            guard let self = self else { return }
            if !coursePayload.isEmpty {
                courses = coursePayload
            }
            courseCollectionView.reloadData()
        }
    }
    
    @objc func showAllCoursesTapped(){
        let storyboard = UIStoryboard(name: "CoreScreen", bundle: nil)
        let categoryCourseViewController = storyboard.instantiateViewController(withIdentifier: "CategoryCourseViewController") as! CategoryCourseViewController
        categoryCourseViewController.hidesBottomBarWhenPushed = true
        categoryCourseViewController.category = self.category
        self.navController.pushViewController(categoryCourseViewController, animated: true)
    }
    
}

extension CourseContainerView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return courses?.count ?? 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "courseCellPrototype", for: indexPath) as! MainCourseCollectionViewCell
        let theme = ThemeManager.shared.theme
        cell.courseImageView.tintColor = theme.imageView.tintColor
        cell.contentView.backgroundColor = UIColor(rgb: 0x808080, alpha: 0.05)
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.borderColor = UIColor(rgb: 0x808080, alpha: 0.2).cgColor
        cell.contentView.layer.cornerRadius = 3
        
        if let courses = courses {
            if !courses.isEmpty {
                cell.courseTitle.hideSkeleton()
                cell.courseShortDescription.hideSkeleton()
                cell.coursePrice.hideSkeleton()
                cell.courseDuration.hideSkeleton()
                
                let course = courses[indexPath.row]
                cell.courseTitle.text = course.title
                cell.courseShortDescription.text = course.description
                cell.coursePrice.text = "$\(String(describing: course.cost))"
                cell.courseDuration.text = "/ \(String(describing: course.durationInHour)) Hours"
                
                //set up course image
                if let imageUri = course.imageUri {
                    setUpCourseImage(imageUri: imageUri, withImageView: cell.courseImageView)
                    cell.courseImageView.hideSkeleton()
                }
            }
        }
            
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let courses = courses {
            let storyboard = UIStoryboard(name: "CoreScreen", bundle: nil)
            let courseDetailViewController = storyboard.instantiateViewController(withIdentifier: "CourseDetailViewController") as! CourseDetailViewController
            let course = courses[indexPath.row]
            courseDetailViewController.courseUuid = course.uuid
            courseDetailViewController.authorUuid = course.authorUuid
            courseDetailViewController.modalPresentationStyle = .fullScreen
            navController.topViewController?.present(courseDetailViewController, animated: true)
        }
    }
    
}
