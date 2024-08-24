//
//  VideoListViewController.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 23/8/24.
//

import UIKit
import Localize_Swift
import KeychainSwift
import SkeletonView

class VideoListViewController: UIViewController {

    let navItemLabel = UILabel()
    @IBOutlet weak var tableView: UITableView!
    
    public var courseUuid: String!
    public var courseTitle: String!
    private var videos: [VideoResponsePayload] = []
    
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
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
    }
    
    @objc func setText(){
        navItemLabel.text = "Video List".localized(using: "Generals") + " \(String(describing: courseTitle!))"
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
        loadVideosByCourseUuid(){ [weak self] videoResponsePayload in
            guard let self = self else { return }
            videos = videoResponsePayload
            tableView.reloadData()
            refreshControl.endRefreshing()
            
            if videos.count == 0 {
                PopUpUtil.popUp(withTitle: "Warning".localized(using: "Generals"), withMessage: "No videos for the course", withAlert: .warning) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    private func loadVideosByCourseUuid(completion: @escaping ([VideoResponsePayload]) -> Void){
        let keychain = KeychainSwift()
        let accessToken = keychain.get("accessToken")!
        let alertController = LoadingViewController()
        present(alertController, animated: true) {
            VideoAPIService.shared.loadVideoByCourseUuid(token: accessToken, withCourseUuid: self.courseUuid){ response in
                alertController.dismiss(animated: true) { [weak self] in
                    guard let self = self else { return }
                    switch response {
                    case .success(let result):
                        completion(result.payload)
                    case .failure(let error):
                        print("Cannot get videos :", error.message)
                        if error.code == 401 {
                            AuthAPIService.shared.shouldRefreshToken { didReceiveToken in
                                if didReceiveToken {
                                    self.loadVideosByCourseUuid(completion: completion)
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

extension VideoListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "CoreScreen", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "VideoDetailViewController") as! VideoDetailViewController
        viewController.hidesBottomBarWhenPushed = true
        
        let video = videos[indexPath.row]
        viewController.videoUrl = video.videoLink
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

extension VideoListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "prototype1", for: indexPath) as? VideoListTableViewCell else { return UITableViewCell() }
        let theme = ThemeManager.shared.theme
        cell.contentView.backgroundColor = theme.view.backgroundColor
        cell.videoTitle.textColor = theme.label.primaryColor
        cell.playButton.tintColor = theme.imageView.tintColor
        
        let video = videos[indexPath.row]
        cell.videoTitle.text = "\(indexPath.row + 1). " + video.title
      
        return cell
    }
    
}
