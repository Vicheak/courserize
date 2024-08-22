//
//  CourseDetailViewController.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 20/8/24.
//

import UIKit
import KeychainSwift
import Localize_Swift
import SkeletonView

class CourseDetailViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var courseImageView: UIImageView!
    @IBOutlet weak var courseTopDetailView: UIView!
    @IBOutlet weak var courseTitle: UILabel!
    @IBOutlet weak var courseCreatedDate: UILabel!
    @IBOutlet weak var courseNumberOfView: UILabel!
    @IBOutlet weak var coursePrice: UILabel!
    @IBOutlet weak var courseDuration: UILabel!
    @IBOutlet weak var courseAuthorDetailView: UIView!
    @IBOutlet weak var courseAuthor: UILabel!
    @IBOutlet weak var courseDescriptionDetailView: UIView!
    @IBOutlet weak var courseDescriptionTitle: UILabel!
    @IBOutlet weak var courseDescription: UILabel!
    @IBOutlet weak var courseDescriptionReadMore: UILabel!
    @IBOutlet weak var courseAuthorImageView: UIImageView!
    @IBOutlet weak var enrollButtonView: UIView!
    @IBOutlet weak var enrollButton: UIButton!
    
    var courseUuid: String!
    var authorUuid: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpViews()
        
        self.setText()
        
        courseDescriptionReadMore.isUserInteractionEnabled = true
        courseDescriptionReadMore.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(readMoreTapped)))
        enrollButton.addTarget(self, action: #selector(enrollButtonTapped), for: .touchUpInside)
        
        self.setColor()
        NotificationCenter.default.addObserver(self, selector: #selector(setColor), name: .changeTheme, object: nil)
        
        setUpCourseDataSkeletonView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.bringSubviewToFront(backButton)
    }
    
    func setUpViews(){
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        courseImageView.isUserInteractionEnabled = false
        courseImageView.contentMode = .scaleAspectFill
        courseDescription.text = ""
        
        // Set the border color with alpha
        let borderColor = ThemeManager.shared.theme.label.primaryColor.withAlphaComponent(0.05).cgColor

        // Add top border
        let topBorder = CALayer()
        topBorder.backgroundColor = borderColor
        topBorder.frame = CGRect(x: 0, y: 0, width: courseAuthorDetailView.frame.width, height: 1)
        courseAuthorDetailView.layer.addSublayer(topBorder)

        // Add bottom border
        let bottomBorder = CALayer()
        bottomBorder.backgroundColor = borderColor
        bottomBorder.frame = CGRect(x: 0, y: courseAuthorDetailView.frame.height - 1, width:courseAuthorDetailView.frame.width, height: 1)
        courseAuthorDetailView.layer.addSublayer(bottomBorder)
        
        backButton.setTitle("", for: .normal)
        backButton.backgroundColor = UIColor(rgb: 0x000000, alpha: 0.60)
        
        let buttonSize = backButton.frame.size
        let minDimension = min(buttonSize.width, buttonSize.height)
        backButton.layer.cornerRadius = minDimension / 2
        backButton.clipsToBounds = true
        
        enrollButton.layer.cornerRadius = 5
        enrollButton.tintColor = .systemGreen
        enrollButton.backgroundColor = .systemGreen
        
        setUpCourseDetail()
    }
    
    @objc func setText(){
        courseDescriptionTitle.text = "Course Description".localized(using: "Generals")
        courseDescriptionTitle.font = UIFont(name: "KhmerOSBattambang-Bold", size: 15)
        courseDescriptionReadMore.text = "Read More".localized(using: "Generals")
        courseDescriptionReadMore.font = UIFont(name: "KhmerOSBattambang-Bold", size: 16)
        let font = UIFont(name: "KhmerOSBattambang-Bold", size: 17)
        let title = "Enroll".localized(using: "Generals")
        let attributedString = NSAttributedString(string: title, attributes: [
            .font: font as Any
        ])
        enrollButton.setAttributedTitle(attributedString, for: .normal)
    }
    
    @objc func setColor() {
        let theme = ThemeManager.shared.theme
        view.backgroundColor = theme.view.backgroundColor
        courseTopDetailView.backgroundColor = theme.view.backgroundColor
        courseTitle.textColor = theme.label.primaryColor
        coursePrice.textColor = theme.label.primaryColor
        courseCreatedDate.textColor = theme.label.primaryColor
        courseDuration.textColor = theme.label.primaryColor
        courseAuthorDetailView.backgroundColor = theme.view.backgroundColor
        courseAuthor.textColor = theme.label.primaryColor
        courseDescriptionDetailView.backgroundColor = theme.view.backgroundColor
        courseDescriptionTitle.textColor = theme.label.primaryColor
        courseDescription.textColor = theme.label.primaryColor
        enrollButtonView.backgroundColor = theme.view.backgroundColor
    }

    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    func setUpCourseDetail() {
        let keychain = KeychainSwift()
        let accessToken = keychain.get("accessToken")!
        CourseAPIService.shared.loadCourseByUuid(token: accessToken, uuid: self.courseUuid) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let result):
                let course = result.payload
                self.hideCourseDataSkeletonView()
                self.setUpCourseDetailData(course: course)
                if let imageUri = course.imageUri {
                    self.courseImageView.hideSkeleton()
                    FileUtil.setUpCourseImage(imageUri: imageUri, withImageView: courseImageView)
                }
            case .failure(let error):
                print("Cannot get courses :", error.message)
                if error.code == 401 {
                    AuthAPIService.shared.shouldRefreshToken { didReceiveToken in
                        if didReceiveToken {
                            self.setUpCourseDetail()
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
    
    private func setUpCourseDetailData(course: CourseResponsePayload){
        courseTitle.text = course.title
        courseNumberOfView.text = "\(course.numberOfView) Views"
        coursePrice.text = "$\(course.cost)"
        courseCreatedDate.text = DateUtil.dateFormatter.string(from: course.createdAt)
        courseDuration.text = "\(course.durationInHour) Hours"
        courseAuthor.text = course.author
        courseDescription.text = course.description
    }
    
    private func setUpCourseDataSkeletonView(){
        view.layoutIfNeeded()
        courseImageView.isSkeletonable = true
        courseImageView.showAnimatedGradientSkeleton()
        courseTitle.isSkeletonable = true
        courseTitle.showAnimatedGradientSkeleton()
        courseNumberOfView.isSkeletonable = true
        courseNumberOfView.showAnimatedGradientSkeleton()
        coursePrice.isSkeletonable = true
        coursePrice.showAnimatedGradientSkeleton()
        courseCreatedDate.isSkeletonable = true
        courseCreatedDate.showAnimatedGradientSkeleton()
        courseDuration.isSkeletonable = true
        courseDuration.showAnimatedGradientSkeleton()
        courseAuthor.isSkeletonable = true
        courseAuthor.showAnimatedGradientSkeleton()
        courseDescription.isSkeletonable = true
        courseDescription.skeletonTextNumberOfLines = 2
        courseDescription.showAnimatedGradientSkeleton()
    }
    
    private func hideCourseDataSkeletonView(){
        courseTitle.hideSkeleton()
        courseNumberOfView.hideSkeleton()
        coursePrice.hideSkeleton()
        courseCreatedDate.hideSkeleton()
        courseDuration.hideSkeleton()
        courseAuthor.hideSkeleton()
        courseDescription.hideSkeleton()
    }
    
    @objc func readMoreTapped(){
        let storyboard = UIStoryboard(name: "CoreScreen", bundle: nil)
        let readMoreViewController = storyboard.instantiateViewController(withIdentifier: "ReadMoreViewController") as! ReadMoreViewController
        readMoreViewController.descriptionDetailText = courseDescription.text ?? ""
        readMoreViewController.modalPresentationStyle = .popover
        present(readMoreViewController, animated: true)
    }
    
    @objc func enrollButtonTapped(){
        let alertCotroller = UIAlertController(title: "Confrim".localized(using: "Generals"), message: "Are you sure to enroll?".localized(using: "Generals"), preferredStyle: .alert)
        alertCotroller.addAction(UIAlertAction(title: "Cancel".localized(using: "Generals"), style: .destructive))
        alertCotroller.addAction(UIAlertAction(title: "Enroll".localized(using: "Generals"), style: .default, handler: { _ in
            self.enrollCourse()
        }))
        present(alertCotroller, animated: true)
    }
    
    private func enrollCourse(){
        let keychain = KeychainSwift()
        let accessToken = keychain.get("accessToken")!
        let alertController = LoadingViewController()
        present(alertController, animated: true) {
            SubscriptionAPIService.shared.enroll(token: accessToken, authorUuid: self.authorUuid, courseUuid: self.courseUuid){ response in
                alertController.dismiss(animated: true) { [weak self] in
                    guard let self = self else { return }
                    switch response {
                    case .success(let result):
                        PopUpUtil.popUp(withTitle: "Success".localized(using: "Generals"), withMessage: result.message, withAlert: .success) {}
                    case .failure(let error):
                        print("Cannot get courses :", error.message)
                        if error.code == 401 {
                            AuthAPIService.shared.shouldRefreshToken { didReceiveToken in
                                if didReceiveToken {
                                    self.enrollCourse()
                                } else {
                                    print("Cannot refresh the token, something went wrong!")
                                }
                            }
                        } else if error.code == 400 || error.code == 404 || error.code == 409 {
                            PopUpUtil.popUp(withTitle: "Warning".localized(using: "Generals"), withMessage: error.errors, withAlert: .warning) {}
                        } else {
                            PopUpUtil.popUp(withTitle: "No Connection".localized(using: "Generals"), withMessage: error.message, withAlert: .warning) {}
                        }
                    }
                }
            }
        }
    }
    
}
