//
//  SubscriptionDetailViewController.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 22/8/24.
//

import UIKit
import SnapKit
import Localize_Swift
import KeychainSwift
import SkeletonView

class SubscriptionDetailViewController: UIViewController {

    let navItemLabel = UILabel()
    @IBOutlet weak var tableView: UITableView!
    
    private var subscriptionDetails: [SubscriberSubscriptionDetail] = []
    
    private var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setText()
        
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
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
    
    @objc func setText(){
        navItemLabel.text = "Subscription Detail".localized(using: "Generals")
        navItemLabel.font = UIFont(name: "KhmerOSBattambang-Bold", size: 18)
        navItemLabel.textAlignment = .center
        navItemLabel.sizeToFit()
        navigationItem.titleView = navItemLabel
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

extension SubscriptionDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
}

extension SubscriptionDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscriptionDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "prototype1", for: indexPath) as? SubscriptionDetailTableViewCell else { return UITableViewCell() }
        let theme = ThemeManager.shared.theme
        cell.contentView.backgroundColor = theme.view.backgroundColor
        cell.courseTitle.textColor = .systemGreen
        cell.subscriptionCourseImageView.tintColor = theme.imageView.tintColor
        cell.coursePrice.textColor = theme.label.primaryColor
        cell.subscriptionCourseImageView.isSkeletonable = true
        cell.subscriptionCourseImageView.showAnimatedGradientSkeleton()
        
        if !subscriptionDetails.isEmpty {
            let subscriptionDetail = subscriptionDetails[indexPath.row]
            cell.courseTitle.text = subscriptionDetail.courseTitle
            cell.coursePrice.text = "$\(String(describing: subscriptionDetail.coursePrice))"
            cell.subscriptionStatus.text = subscriptionDetail.isApproved ? "Approved" : "Request Pending"
            cell.subscriptionStatus.textColor = subscriptionDetail.isApproved ? .systemGreen : .systemYellow
           
            loadCourseImageUriByUuid(courseUuid: subscriptionDetail.courseUuid) { imageUri in
                if let imageUri = imageUri {
                    FileUtil.setUpCourseImage(imageUri: imageUri, withImageView: cell.subscriptionCourseImageView)
                    cell.subscriptionCourseImageView.hideSkeleton()
                }
            }
        }
      
        return cell
    }
    
}
