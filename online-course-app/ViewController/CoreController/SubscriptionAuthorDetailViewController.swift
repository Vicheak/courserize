//
//  SubscriptionAuthorDetailViewController.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 22/8/24.
//

import UIKit
import SnapKit
import Localize_Swift
import KeychainSwift
import SkeletonView

class SubscriptionAuthorDetailViewController: UIViewController {

    let navItemLabel = UILabel()
    @IBOutlet weak var tableView: UITableView!
    
    public var subscriptionDetails: [SubscriberSubscriptionDetail]!
    public var subscriberEmail: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setText()
        
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        self.setColor()
        NotificationCenter.default.addObserver(self, selector: #selector(setColor), name: .changeTheme, object: nil)
        
        if subscriptionDetails.count == 0 {
            PopUpUtil.popUp(withTitle: "Warning".localized(using: "Generals"), withMessage: "No subscription details", withAlert: .warning) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc func setText(){
        navItemLabel.text = subscriberEmail
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
    
    private func approveOrRejectAction(subscriptionDetailId: Int, courseUuid: String, approve: Bool, completion: @escaping () -> Void) {
        let keychain = KeychainSwift()
        let accessToken = keychain.get("accessToken")!
        let alertController = LoadingViewController()
        present(alertController, animated: true) {
            SubscriptionAPIService.shared.approveOrRejectSubscription(token: accessToken, subscriptionDetailId: subscriptionDetailId, courseUuid: courseUuid, approve: approve){ response in
                alertController.dismiss(animated: true) { [weak self] in
                    guard let self = self else { return }
                    switch response {
                    case .success(let result):
                        PopUpUtil.popUp(withTitle: "Success".localized(using: "Generals"), withMessage: result.message, withAlert: .success) {}
                        completion()
                    case .failure(let error):
                        print("Cannot get subscriptions :", error.errors)
                        if error.code == 401 {
                            AuthAPIService.shared.shouldRefreshToken { didReceiveToken in
                                if didReceiveToken {
                                    self.approveOrRejectAction(subscriptionDetailId: subscriptionDetailId, courseUuid: courseUuid, approve: approve, completion: completion)
                                } else {
                                    print("Cannot refresh the token, something went wrong!")
                                }
                            }
                        } else if error.code == 403 || error.code == 404 {
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
    
    private func removeSubscriptionDetailById(subscriptionDetailId: Int, completion: @escaping () -> Void) {
        let keychain = KeychainSwift()
        let accessToken = keychain.get("accessToken")!
        let alertController = LoadingViewController()
        present(alertController, animated: true) {
            SubscriptionAPIService.shared.removeSubscriptionDetailById(token: accessToken, subscriptionDetailId: subscriptionDetailId){ response in
                alertController.dismiss(animated: true) { [weak self] in
                    guard let self = self else { return }
                    switch response {
                    case .success(let result):
                        PopUpUtil.popUp(withTitle: "Success".localized(using: "Generals"), withMessage: result.message, withAlert: .success) {}
                        completion()
                    case .failure(let error):
                        print("Cannot get subscriptions :", error.errors)
                        if error.code == 401 {
                            AuthAPIService.shared.shouldRefreshToken { didReceiveToken in
                                if didReceiveToken {
                                    self.removeSubscriptionDetailById(subscriptionDetailId: subscriptionDetailId, completion: completion)
                                } else {
                                    print("Cannot refresh the token, something went wrong!")
                                }
                            }
                        } else if error.code == 403 || error.code == 404 {
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

}

extension SubscriptionAuthorDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
}

extension SubscriptionAuthorDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscriptionDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "prototype1", for: indexPath) as? SubscriptionAuthorDetailTableViewCell else { return UITableViewCell() }
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
            cell.subscriptionStatus.text = subscriptionDetail.isApproved ? "Approved".localized(using: "Generals") : "Request Pending".localized(using: "Generals")
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let subscriptionDetail = subscriptionDetails[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Remove".localized(using: "Generals")) { [weak self] _, _, complete in
            guard let self = self else { return}
            let alertController = UIAlertController(title: "Confirm".localized(using: "Generals"), message: "Are you sure to remove the subscription?".localized(using: "Generals"), preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Remove".localized(using: "Generals"), style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                removeSubscriptionDetailById(subscriptionDetailId: subscriptionDetail.subscriptionDetailId) {
                    self.subscriptionDetails.remove(at: indexPath.row)
                    tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .automatic)
                    if self.subscriptionDetails.count == 0 {
                        self.navigationController?.popViewController(animated: true)
                        NotificationCenter.default.post(name: NSNotification.Name.refreshSubscription, object: nil)
                    }
                }
            }
            let noAction = UIAlertAction(title: "Cancel".localized(using: "Generals"), style: .cancel) { _ in
                complete(true)
            }
            alertController.addAction(yesAction)
            alertController.addAction(noAction)
            present(alertController, animated: true)
        }
        
        let rejectAction = UIContextualAction(style: .normal, title: "Reject".localized(using: "Generals")) { [weak self] _, _, complete in
            guard let self = self else { return }
            approveOrRejectAction(subscriptionDetailId: subscriptionDetail.subscriptionDetailId, courseUuid: subscriptionDetail.courseUuid, approve: false){
                subscriptionDetail.isApproved = false
                tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .automatic)
            }
            complete(true)
        }
        rejectAction.backgroundColor = .systemYellow
        
        let approveAction = UIContextualAction(style: .normal, title: "Approve".localized(using: "Generals")) { [weak self] _, _, complete in
            guard let self = self else { return }
            approveOrRejectAction(subscriptionDetailId: subscriptionDetail.subscriptionDetailId, courseUuid: subscriptionDetail.courseUuid, approve: true){
                subscriptionDetail.isApproved = true
                tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .automatic)
            }
            complete(true)
        }
        approveAction.backgroundColor = .systemGreen
    
        let config = UISwipeActionsConfiguration(actions: [deleteAction, rejectAction, approveAction])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
}
