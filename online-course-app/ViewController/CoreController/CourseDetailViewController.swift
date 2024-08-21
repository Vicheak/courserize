//
//  CourseDetailViewController.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 20/8/24.
//

import UIKit
import KeychainSwift
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
    
    var courseUuid: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpViews()
        
        courseDescriptionReadMore.isUserInteractionEnabled = true
        courseDescriptionReadMore.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(readMoreTapped)))
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
        let borderColor = UIColor.black.withAlphaComponent(0.05).cgColor

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
        
       
        setUpCourseDataSkeletonView()
        setUpCourseDetail()
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
                hideCourseDataSkeletonView()
                setUpCourseDetailData(course: course)
                if let imageUri = course.imageUri {
                    courseImageView.hideSkeleton()
                    setUpCourseImage(imageUri: imageUri)
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
    
    private func setUpCourseImage(imageUri: String){
        //load image from document directory
        let fileURL = URL(string: imageUri)!
        if let courseImage = FileUtil.loadImageFromDocumentDirectory(fileName: fileURL.lastPathComponent) {
            UIView.transition(with: courseImageView, duration: 1.5, options: [.curveEaseInOut]) {
                self.courseImageView.image = courseImage
            } completion: { _ in }
        } else {
            FileAPIService.shared.downloadImageAndSave(fileURL: imageUri) { [weak self] response in
                guard let self = self else { return }
                switch response {
                case .success(_):
                    setUpCourseImage(imageUri: imageUri)
                case .failure(let error):
                    print("Error :", error)
                    if #available(iOS 13.0, *) {
                        //set up loading
                        courseImageView.isSkeletonable = true
                        courseImageView.showAnimatedGradientSkeleton()
                    }
                }
            }
        }
    }
    
    private func setUpCourseDataSkeletonView(){
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
    
}
