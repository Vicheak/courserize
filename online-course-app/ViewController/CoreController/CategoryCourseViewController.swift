//
//  CategoryCourseViewController.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 20/8/24.
//

import UIKit
import Localize_Swift
import KeychainSwift

class CategoryCourseViewController: UIViewController {

    let titleLabel = UILabel()
    @IBOutlet weak var tableView: UITableView!
    var category: String!
    private var courses: [CourseResponsePayload]?
    
    private var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        
        self.setText()

        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        self.setColor()
        NotificationCenter.default.addObserver(self, selector: #selector(setColor), name: .changeTheme, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name.refreshData, object: nil)
        
        refreshData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func setUpViews(){
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
    }
    
    @objc func setText(){
        titleLabel.text = self.category.localized(using: "Generals")
        titleLabel.font = UIFont(name: "KhmerOSBattambang-Bold", size: 18)
        titleLabel.textAlignment = .center
        navigationItem.titleView = titleLabel
    }
    
    @objc func setColor() {
        let theme = ThemeManager.shared.theme
        view.backgroundColor = theme.view.backgroundColor
        tableView.backgroundColor = theme.view.backgroundColor
        
        tableView.reloadData()
    }
    
    func setUpTableView(completion: @escaping ([CourseResponsePayload]) -> Void){
        let keychain = KeychainSwift()
        let accessToken = keychain.get("accessToken")!
        CourseAPIService.shared.loadCourseByCategoryName(token: accessToken, withCategoryName: category) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let result):
                completion(result.payload)
            case .failure(let error):
                print("Cannot get courses :", error.message)
                if error.code == 401 {
                    AuthAPIService.shared.shouldRefreshToken { didReceiveToken in
                        if didReceiveToken {
                            self.setUpTableView(completion: completion)
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
    
    @objc private func refreshData() {
        setUpTableView { [weak self] coursePayload in
            guard let self = self else { return }
            if !coursePayload.isEmpty {
                courses = coursePayload
            }
            tableView.reloadData()
        }
        refreshControl.endRefreshing()
    }
    
}

extension CategoryCourseViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let courses = courses {
            let storyboard = UIStoryboard(name: "CoreScreen", bundle: nil)
            let courseDetailViewController = storyboard.instantiateViewController(withIdentifier: "CourseDetailViewController") as! CourseDetailViewController
            let course = courses[indexPath.row]
            courseDetailViewController.courseUuid = course.uuid
            courseDetailViewController.modalPresentationStyle = .fullScreen
            present(courseDetailViewController, animated: true)
        }
    }
    
}

extension CategoryCourseViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses?.count ?? 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "prototype1", for: indexPath) as? CategoryCourseTableViewCell else { return UITableViewCell() }
        let theme = ThemeManager.shared.theme
        cell.contentView.backgroundColor = theme.view.backgroundColor
        cell.courseTitleLabel.textColor = .systemGreen
        cell.courseImageView.tintColor = theme.imageView.tintColor
        cell.coursePriceLabel.textColor = theme.label.primaryColor
        cell.courseDurationLabel.textColor = theme.label.primaryColor
        
        if let courses = courses {
            if !courses.isEmpty {
                cell.courseTitleLabel.hideSkeleton()
                cell.coursePriceLabel.hideSkeleton()
                cell.courseDurationLabel.hideSkeleton()
                
                let course = courses[indexPath.row]
                cell.courseTitleLabel.text = course.title
                cell.coursePriceLabel.text = "$\(String(describing: course.cost))"
                cell.courseDurationLabel.text = "/ \(String(describing: course.durationInHour)) Hours"
                
                //set up course image
                if let imageUri = course.imageUri {
                    setUpCourseImage(imageUri: imageUri, withImageView: cell.courseImageView)
                    cell.courseImageView.hideSkeleton()
                }
            }
        }
      
        return cell
    }
    
}
