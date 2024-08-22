//
//  SearchCourseViewController.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 22/8/24.
//

import UIKit
import SnapKit
import Localize_Swift
import KeychainSwift
import SkeletonView

class SearchCourseViewController: UIViewController {
    
    let navItemLabel = UILabel()
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var searchImageView: UIImageView!
    @IBOutlet weak var searchDescriptionLabel: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    let tableView = UITableView()
    var keyboardUtil: KeyboardUtil!
    
    private var courses: [CourseResponsePayload] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        
        keyboardUtil = KeyboardUtil(view: view, bottomConstraint: bottomConstraint)
        
        setUpViews()
        
        self.setText()
        
        tableView.keyboardDismissMode = .onDrag
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "SearchCourseTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "prototype1")
        
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
    
    private func setUpViews(){
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.isHidden = true
    }
    
    @objc func setText(){
        navItemLabel.text = "Search Any Courses".localized(using: "Generals")
        navItemLabel.font = UIFont(name: "KhmerOSBattambang-Bold", size: 18)
        navItemLabel.textAlignment = .center
        navItemLabel.sizeToFit()
        navigationItem.titleView = navItemLabel
        
        searchController.searchBar.placeholder = "Search".localized(using: "Generals")
        searchDescriptionLabel.text = "Please type something to search".localized(using: "Generals")
        searchDescriptionLabel.font = UIFont(name: "KhmerOSBattambang-Bold", size: 17)
    }
    
    @objc func setColor() {
        let theme = ThemeManager.shared.theme
        view.backgroundColor = theme.view.backgroundColor
        mainView.backgroundColor = theme.view.backgroundColor
        tableView.backgroundColor = theme.view.backgroundColor
        searchDescriptionLabel.textColor = theme.label.primaryColor
    }
    
    private func toggleSearchView(enable: Bool, searchText: String){
        mainView.isHidden = enable
        tableView.isHidden = !enable
        
        if !enable {
            searchImageView.image = UIImage(named: "404-background")
            searchDescriptionLabel.text = "Search not found".localized(using: "Generals") + " \"\(searchText)\""
        }
    }
    
    func searchCourses(searchText: String, completion: @escaping ([CourseResponsePayload]) -> Void){
        let keychain = KeychainSwift()
        let accessToken = keychain.get("accessToken")!
        let alertController = LoadingViewController()
        present(alertController, animated: true) {
            CourseAPIService.shared.searchCourses(token: accessToken, searchCriteria: searchText) { response in
                alertController.dismiss(animated: true) { [weak self] in
                    guard let self = self else { return }
                    switch response {
                    case .success(let result):
                        completion(result.payload)
                    case .failure(let error):
                        print("Cannot get courses :", error.message)
                        if error.code == 401 {
                            AuthAPIService.shared.shouldRefreshToken { didReceiveToken in
                                if didReceiveToken {
                                    self.searchCourses(searchText: searchText, completion: completion)
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
        }
    }

}

extension SearchCourseViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            return
        }
        
        searchController.isActive = false
        
        searchCourses(searchText: searchText) { [weak self] coursePayload in
            guard let self = self else { return }
            courses = coursePayload
            
            tableView.reloadData()
            toggleSearchView(enable: courses.count != 0, searchText: searchText)
        }
    }
  
}

extension SearchCourseViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "CoreScreen", bundle: nil)
        let courseDetailViewController = storyboard.instantiateViewController(withIdentifier: "CourseDetailViewController") as! CourseDetailViewController
        let course = courses[indexPath.row]
        courseDetailViewController.courseUuid = course.uuid
        courseDetailViewController.authorUuid = course.authorUuid
        courseDetailViewController.modalPresentationStyle = .fullScreen
        present(courseDetailViewController, animated: true)
    }
    
}

extension SearchCourseViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "prototype1", for: indexPath) as? SearchCourseTableViewCell else { return UITableViewCell() }
        let theme = ThemeManager.shared.theme
        cell.contentView.backgroundColor = theme.view.backgroundColor
        cell.courseTitleLabel.textColor = .systemGreen
        cell.courseImageView.tintColor = theme.imageView.tintColor
        cell.coursePriceLabel.textColor = theme.label.primaryColor
        cell.courseDurationLabel.textColor = theme.label.primaryColor
        
        if !courses.isEmpty {
            let course = courses[indexPath.row]
            cell.courseTitleLabel.text = course.title
            cell.coursePriceLabel.text = "$\(String(describing: course.cost))"
            cell.courseDurationLabel.text = "/ \(String(describing: course.durationInHour)) Hours"
            
            //set up course image
            if let imageUri = course.imageUri {
                FileUtil.setUpCourseImage(imageUri: imageUri, withImageView: cell.courseImageView)
                cell.courseImageView.hideSkeleton()
            }
        }
      
        return cell
    }
    
}
