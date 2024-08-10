//
//  UserViewController.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 5/8/24.
//

import UIKit
import Localize_Swift
import KeychainSwift

class UserViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userUsername: UILabel!
    @IBOutlet weak var userPhone: UILabel!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var profileContainer: UIView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var userGender: UILabel!
    @IBOutlet weak var birthDateLabel: UILabel!
    @IBOutlet weak var userBirthDate: UILabel!
    @IBOutlet weak var joinedDateLabel: UILabel!
    @IBOutlet weak var userJoinedDate: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var userRoles: UILabel!
    @IBOutlet weak var uploadProfileTab: UIView!
    @IBOutlet weak var uploadProfileTabTitle: UILabel!
    @IBOutlet weak var uploadProfileTabDetail: UILabel!
    @IBOutlet weak var updateProfileTab: UIView!
    @IBOutlet weak var updateProflieTabTitle: UILabel!
    @IBOutlet weak var updateProflieTabDetail: UILabel!
    @IBOutlet weak var changePasswordTab: UIView!
    @IBOutlet weak var changePasswordTabTitle: UILabel!
    @IBOutlet weak var changePasswordTabDetail: UILabel!
    @IBOutlet weak var logoutTab: UIView!
    @IBOutlet weak var logoutTabTitle: UILabel!
    @IBOutlet weak var logoutTabDetail: UILabel!
    @IBOutlet weak var uploadProfileImageView: UIImageView!
    @IBOutlet weak var updateProfileImageView: UIImageView!
    @IBOutlet weak var changePasswordImageView: UIImageView!
    @IBOutlet weak var logoutImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        
        self.setText()

        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        self.setColor()
        NotificationCenter.default.addObserver(self, selector: #selector(setColor), name: .changeTheme, object: nil)
        
        uploadProfileTab.isUserInteractionEnabled = true
        uploadProfileTab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(uploadProfileTapped)))
        
        updateProfileTab.isUserInteractionEnabled = true
        updateProfileTab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(updateProfileTapped)))
        
        changePasswordTab.isUserInteractionEnabled = true
        changePasswordTab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changePasswordTapped)))
        
        logoutTab.isUserInteractionEnabled = true
        logoutTab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(logoutTapped)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc func setText() {
        titleLabel.text = "Account".localized(using: "Generals")
        profileLabel.text = "   " + "Profile".localized(using: "Generals")
        emailLabel.text = "Email".localized(using: "Generals")
        genderLabel.text = "Gender".localized(using: "Generals")
        birthDateLabel.text = "Birth Date".localized(using: "Generals")
        joinedDateLabel.text = "Joined Date".localized(using: "Generals")
        roleLabel.text = "Role".localized(using: "Generals")
        uploadProfileTabTitle.text = "Upload Profile".localized(using: "Generals")
        uploadProfileTabDetail.text = "Choose your photo".localized(using: "Generals")
        updateProflieTabTitle.text = "Update Profile Info".localized(using: "Generals")
        updateProflieTabDetail.text = "Click here to update".localized(using: "Generals")
        changePasswordTabTitle.text = "Change Password".localized(using: "Generals")
        changePasswordTabDetail.text = "Change the latest password".localized(using: "Generals")
        logoutTabTitle.text = "Logout".localized(using: "Generals")
        logoutTabDetail.text = "Exit from the app".localized(using: "Generals")
    }

    private func setUpViews(){
        titleLabel.font = UIFont(name: "KhmerOSBattambang-Bold", size: 18)
        profileLabel.font = UIFont(name: "KhmerOSBattambang-Bold", size: 22)
        uploadProfileTabTitle.font = UIFont(name: "KhmerOSBattambang-Bold", size: 14)
        updateProflieTabTitle.font = UIFont(name: "KhmerOSBattambang-Bold", size: 14)
        changePasswordTabTitle.font = UIFont(name: "KhmerOSBattambang-Bold", size: 14)
        logoutTabTitle.font = UIFont(name: "KhmerOSBattambang-Bold", size: 14)
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        toImageCircleBound()
        //load image from document directory
        let imageName = UserDefaults.standard.string(forKey: "imageName")
        if let imageName = imageName {
            let fileManager = FileManager.default
            let directoryPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let filePath = directoryPath.appendingPathComponent(imageName)

            if let image = UIImage(contentsOfFile: filePath.path) {
                UIView.transition(with: userImageView, duration: 1.5, options: [.transitionFlipFromLeft]) { [weak self] in
                    guard let self = self else { return }
                    userImageView.image = image
                } completion: { _ in }
                
            } else {
                //handle image loading failure (e.g., file not found, invalid format)
                print("Error : could not load image from document directory : \(filePath)")
                 
                UIView.transition(with: userImageView, duration: 1.5, options: [.transitionFlipFromLeft]) { [weak self] in
                    guard let self = self else { return }
                    if #available(iOS 13.0, *) {
                        userImageView.image = UIImage(systemName: "person.circle.fill")
                    }
                } completion: { _ in }
            }
        } else {
            print("No image is found in user defaults")
        
            //set the default ui image
            UIView.transition(with: userImageView, duration: 1.5, options: [.transitionFlipFromLeft]) { [weak self] in
                guard let self = self else { return }
                if #available(iOS 13.0, *) {
                    userImageView.image = UIImage(systemName: "person.circle.fill")
                }
            } completion: { _ in }
        }
        
        if let userProfileResponseData = UserDefaults.standard.data(forKey: "userProfileResponse")  {
            let decoder = JSONDecoder()
//            if let userProfileResponse = try? decoder.decode(UserProfileResponse.self, from: userProfileResponseData) {
//                print(userProfileResponseData)
//                setUpProfile(userProfileResponse)
//            } else {
//                print("error decoding")
//            }
            
            let userProfileString = String(data: userProfileResponseData, encoding: .utf8)
            print(userProfileString)
            do {
                let userProfileResponse = try decoder.decode(UserProfileResponse.self, from: userProfileResponseData)
                print(userProfileResponseData)
            } catch {
                print(error.localizedDescription)
            }
        } else {
            //request to server again to get user profile
            let keychain = KeychainSwift()
            let accessToken = keychain.get("accessToken")!
            UserAPIService.shared.userProfile(token: accessToken) { [weak self] response in
                guard let self = self else { return }
                switch response {
                case .success(let result):
                    print("Get user profile :", result)
                    let encoder = JSONEncoder()
                    if let userProfileResponse = try? encoder.encode(result) {
                        UserDefaults.standard.setValue(userProfileResponse, forKey: "userProfileResponse")
                    }
                    setUpProfile(result)
                case .failure(let error):
                    print("Cannot get user profile :", error.message)
                }
            }
        }
        
        profileContainer.layer.cornerRadius = 6
        profileContainer.layer.borderWidth = 0.3
        uploadProfileTab.layer.cornerRadius = 6
        uploadProfileTab.layer.borderWidth = 0.3
        updateProfileTab.layer.cornerRadius = 6
        updateProfileTab.layer.borderWidth = 0.3
        changePasswordTab.layer.cornerRadius = 6
        changePasswordTab.layer.borderWidth = 0.3
        logoutTab.layer.cornerRadius = 6
        logoutTab.layer.borderWidth = 0.3
    }
    
    private func setUpProfile(_ userProfile: UserProfileResponse){
        emailLabel.text = userProfile.payload.email
        
    }
    
    @objc func setColor() {
        let theme = ThemeManager.shared.theme
        view.backgroundColor = theme.view.backgroundColor
        profileContainer.layer.borderColor = theme.label.primaryColor.cgColor
        uploadProfileTab.layer.borderColor = theme.label.primaryColor.cgColor
        updateProfileTab.layer.borderColor = theme.label.primaryColor.cgColor
        changePasswordTab.layer.borderColor = theme.label.primaryColor.cgColor
        logoutTab.layer.borderColor = UIColor.red.cgColor
        userImageView.tintColor = theme.imageView.tintColor
        uploadProfileImageView.tintColor = theme.imageView.tintColor
        updateProfileImageView.tintColor = theme.imageView.tintColor
        changePasswordImageView.tintColor = theme.imageView.tintColor
    }
    
    @objc func closeButtonTapped(){
       dismiss(animated: true)
    }
    
    @objc func uploadProfileTapped(){
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            //handle the case where the source type is not available
            return
        }
        ImageUtil.checkPhotoPermission { granted in
            DispatchQueue.main.async {
                if granted {
                    self.presentImagePickerController(sourceType: .photoLibrary)
                } else {
                    self.presentCameraSettings()
                }
            }
        }
    }
    
    func presentImagePickerController(sourceType: UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }

    func presentCameraSettings(){
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        let alertController = UIAlertController(title: "Error", message: "Access is denied", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
        alertController.addAction(UIAlertAction(title: "Settings", style: .cancel, handler: { _ in
            UIApplication.shared.open(url, options: [:])
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func updateProfileTapped(){
        
    }
    
    @objc func changePasswordTapped(){
        
    }
    
    @objc func logoutTapped(){
        let alertCotroller = UIAlertController(title: "Confrim".localized(using: "Generals"), message: "Are you sure to log out?".localized(using: "Generals"), preferredStyle: .alert)
        alertCotroller.addAction(UIAlertAction(title: "Cancel".localized(using: "Generals"), style: .destructive))
        alertCotroller.addAction(UIAlertAction(title: "Log out".localized(using: "Generals"), style: .default, handler: { _ in
            UserDefaults.standard.setValue(false, forKey: "isLogin")
            UserDefaults.standard.setValue("", forKey: "userProfileResponse")
            UserDefaults.standard.set("", forKey: "imageName")
            let keychain = KeychainSwift()
            keychain.delete("accessToken")
            keychain.delete("refreshToken")
            UIApplication.shared.showLoginViewController()
        }))
        present(alertCotroller, animated: true)
    }

}

extension UserViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[.originalImage] as? UIImage {
            //save the seleted image as JPEG file
            let fileName = UUID().uuidString + ".jpg"
            if let savedURL = ImageUtil.saveImageAsJPEG(image, to: .documentDirectory, withName: fileName, compressionQuality: 0.8){
                print("Save image URL : \(savedURL)")
                
                //set to user image view
                UIView.transition(with: userImageView, duration: 1.5, options: [.transitionFlipFromLeft]) { [weak self] in
                    guard let self = self else { return }
                    userImageView.image = image
                } completion: { _ in }
        
                toImageCircleBound()
                
                //store image name in user defaults
                //and if user uploads new image, overwrite the filename to new image name
                UserDefaults.standard.set(fileName, forKey: "imageName")
                
                //upload file to server
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func toImageCircleBound(){
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        userImageView.clipsToBounds = true
        userImageView.contentMode = .scaleAspectFill
    }
    
}
