//
//  VideoViewController.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 5/8/24.
//

import UIKit
import SnapKit
import Localize_Swift
import KeychainSwift
import SkeletonView

class VideoViewController: UIViewController {

    @IBOutlet weak var profileButton: UIBarButtonItem!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var settingButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    lazy var emptyImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "404-background")
        return imageView
    }()
    lazy var emptyLabel = {
        let label = UILabel()
        print("rendering")
        label.text = "You have no subscribed courses"
        return label
    }()
    
    private var subscriptionDetails: [SubscriberSubscriptionDetail] = []
    
    private var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        
        self.setText()
        
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.addSubview(refreshControl)
    
        profileButton.target = self
        profileButton.action = #selector(profileButtonTapped)
        settingButton.target = self
        settingButton.action = #selector(settingButtonTapped)
        searchButton.target = self
        searchButton.action = #selector(searchButtonTapped)
        
        self.setColor()
        NotificationCenter.default.addObserver(self, selector: #selector(setColor), name: .changeTheme, object: nil)
        
        refreshData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func setUpViews(){
        view.addSubview(emptyImageView)
        view.addSubview(emptyLabel)
    
        emptyImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(300)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyImageView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        emptyImageView.isHidden = true
        emptyLabel.isHidden = true
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
    
    @objc func searchButtonTapped(){
        let storyboard = UIStoryboard(name: "CoreScreen", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SearchCourseViewController")
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func setColor() {
        let theme = ThemeManager.shared.theme
        view.backgroundColor = theme.view.backgroundColor
        tableView.backgroundColor = theme.view.backgroundColor
    }
    
    @objc private func refreshData() {
        loadSubscriptionDetailView { [weak self] subscriptionPayload in
            guard let self = self else { return }
            subscriptionDetails = subscriptionPayload.subscriptionDetails
            tableView.reloadData()
            refreshControl.endRefreshing()
            
            if subscriptionDetails.count == 0 {
                emptyImageView.isHidden = false
                emptyLabel.isHidden = false
                tableView.isHidden = true
            } else {
                emptyImageView.isHidden = true
                emptyLabel.isHidden = true
                tableView.isHidden = false
            }
        }
    }
    
    private func loadSubscriptionDetailView(completion: @escaping (SubscriberSubscriptionPayload) -> Void){
        let keychain = KeychainSwift()
        let accessToken = keychain.get("accessToken")!
        let alertController = LoadingViewController()
        present(alertController, animated: true) {
            SubscriptionAPIService.shared.loadSubscriptionByAuthenticatedSubscriber(token: accessToken){ response in
                alertController.dismiss(animated: true) { [weak self] in
                    guard let self = self else { return }
                    switch response {
                    case .success(let result):
                        completion(result.payload)
                    case .failure(let error):
                        print("Cannot get courses :", error.errors)
                        if error.code == 401 {
                            AuthAPIService.shared.shouldRefreshToken { didReceiveToken in
                                if didReceiveToken {
                                    self.loadSubscriptionDetailView(completion: completion)
                                } else {
                                    print("Cannot refresh the token, something went wrong!")
                                }
                            }
                        } else if error.code == 404 {
                            PopUpUtil.popUp(withTitle: "Warning".localized(using: "Generals"), withMessage: error.errors, withAlert: .warning) {
                                self.navigationController?.popViewController(animated: true)
                            }
                        } else {
                            PopUpUtil.popUp(withTitle: "No Connection".localized(using: "Generals"), withMessage: error.errors, withAlert: .warning) {}
                        }
                    }
                }
            }
        }
    }
    
    private func loadCourseImageUriByUuid(courseUuid: String, completion: @escaping (String?) -> Void) {
        let keychain = KeychainSwift()
        let accessToken = keychain.get("accessToken")!
        CourseAPIService.shared.loadCourseByUuid(token: accessToken, uuid: courseUuid) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let result):
                completion(result.payload.imageUri)
            case .failure(let error):
                print("Cannot get course subscriptios :", error.message)
                if error.code == 401 {
                    AuthAPIService.shared.shouldRefreshToken { didReceiveToken in
                        if didReceiveToken {
                            self.loadCourseImageUriByUuid(courseUuid: courseUuid, completion: completion)
                        } else {
                            print("Cannot refresh the token, something went wrong!")
                        }
                    }
                } else if error.code == 404 {
                    PopUpUtil.popUp(withTitle: "Warning".localized(using: "Generals"), withMessage: error.errors, withAlert: .warning) {}
                } else {
                    PopUpUtil.popUp(withTitle: "No Connection".localized(using: "Generals"), withMessage: error.message, withAlert: .warning) {}
                }
            }
        }
    }

}

extension VideoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "CoreScreen", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "VideoListViewController") as! VideoListViewController
        viewController.hidesBottomBarWhenPushed = true
        let subscriptionDetail = subscriptionDetails[indexPath.row]
        if subscriptionDetail.isApproved {
            viewController.courseUuid = subscriptionDetail.courseUuid
            viewController.courseTitle = subscriptionDetail.courseTitle
            navigationController?.pushViewController(viewController, animated: true)
        } else {
            PopUpUtil.popUp(withTitle: "Warning".localized(using: "Generals"), withMessage: "The course has not been approved yet! request pending", withAlert: .warning) {}
        }
    }
    
}

extension VideoViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscriptionDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "prototype1", for: indexPath) as? CourseVideoTableViewCell else { return UITableViewCell() }
        let theme = ThemeManager.shared.theme
        cell.contentView.backgroundColor = theme.view.backgroundColor
        cell.courseTitle.textColor = .systemGreen
        cell.courseImageView.tintColor = theme.imageView.tintColor
        cell.coursePrice.textColor = theme.label.primaryColor
        cell.courseDuration.textColor = theme.label.primaryColor
        cell.courseImageView.isSkeletonable = true
        cell.courseImageView.showAnimatedGradientSkeleton()
        
        if !subscriptionDetails.isEmpty {
            let subscriptionDetail = subscriptionDetails[indexPath.row]
            cell.courseTitle.text = subscriptionDetail.courseTitle
            cell.coursePrice.text = "$\(String(describing: subscriptionDetail.coursePrice))"
            cell.courseDuration.text = "/ \(String(describing: subscriptionDetail.courseDurationInHour)) Hours"
           
            loadCourseImageUriByUuid(courseUuid: subscriptionDetail.courseUuid) { imageUri in
                if let imageUri = imageUri {
                    FileUtil.setUpCourseImage(imageUri: imageUri, withImageView: cell.courseImageView)
                    cell.courseImageView.hideSkeleton()
                }
            }
        }
      
        return cell
    }
    
}

