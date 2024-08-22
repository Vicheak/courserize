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
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var userProfileContainer: UIView!
    @IBOutlet weak var profilePhoneContainer: UIView!
    let titleLabel = UILabel()
    
    var userProfileResponse: UserProfileResponse?
    
    var alertCotroller = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.target = self
        closeButton.action = #selector(closeButtonTapped)
        
        setUpViews()
        
        self.setText()
        
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
        titleLabel.font = UIFont(name: "KhmerOSBattambang-Bold", size: 18)
        titleLabel.textAlignment = .center
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
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
        profileLabel.font = UIFont(name: "KhmerOSBattambang-Bold", size: 22)
        uploadProfileTabTitle.font = UIFont(name: "KhmerOSBattambang-Bold", size: 14)
        updateProflieTabTitle.font = UIFont(name: "KhmerOSBattambang-Bold", size: 14)
        changePasswordTabTitle.font = UIFont(name: "KhmerOSBattambang-Bold", size: 14)
        logoutTabTitle.font = UIFont(name: "KhmerOSBattambang-Bold", size: 14) 
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
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
        
        toImageCircleBound()
    
        setUpUserView()
    }
    
    private func setUpUserView(){
        //request to server again to get user profile
        let keychain = KeychainSwift()
        let accessToken = keychain.get("accessToken")!
        UserAPIService.shared.userProfile(token: accessToken) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let result):
                userProfileResponse = result
                setUpProfile(result)
                if let photoUri = result.payload.photoUri {
                    setUpProfileImage(photoUri: photoUri)
                } else {
                    //set to user image view
                    if #available(iOS 13.0, *) {
                        userImageView.image = UIImage(systemName: "person.circle.fill")
                    }
                }
            case .failure(let error):
                print("Cannot get user profile :", error.message)
                if error.code == 401 {
                    AuthAPIService.shared.shouldRefreshToken { didReceiveToken in
                        if didReceiveToken {
                            self.setUpUserView()
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
    
    private func setUpProfile(_ userProfile: UserProfileResponse){
        let payload = userProfile.payload
        userUsername.text = payload.username
        userPhone.text = payload.phoneNumber
        userEmail.text = payload.email
        userGender.text = payload.gender
        userBirthDate.text = DateUtil.dateFormatter.string(from: payload.dateOfBirth)
        userJoinedDate.text = DateUtil.dateFormatter.string(from: payload.joinDate)
        var concatenateRole: String = ""
        for userRole in payload.userRoles {
            concatenateRole += userRole.role.name + " "
        }
        userRoles.text = concatenateRole
    }
    
    private func setUpProfileImage(photoUri: String){
        //load image from document directory
        let fileURL = URL(string: photoUri)!
        if let profileImage = FileUtil.loadImageFromDocumentDirectory(fileName: fileURL.lastPathComponent) {
            //set to user image view
            UIView.transition(with: userImageView, duration: 1.5, options: [.curveEaseInOut]) { [weak self] in
                guard let self = self else { return }
                userImageView.image = profileImage
            } completion: { _ in }
    
            toImageCircleBound()
        } else {
            FileAPIService.shared.downloadImageAndSave(fileURL: photoUri) { [weak self] response in
                guard let self = self else { return }
                switch response {
                case .success(let url):
                    setUpProfileImage(photoUri: url.absoluteString)
                case .failure(let error):
                    print("Error :", error)
                    //set to user image view
                    if #available(iOS 13.0, *) {
                        userImageView.image = UIImage(systemName: "person.circle.fill")
                    }
                }
            }
        }
    }
    
    @objc func setColor() {
        let theme = ThemeManager.shared.theme
        view.backgroundColor = theme.view.backgroundColor
        mainView.backgroundColor = theme.view.backgroundColor
        userProfileContainer.backgroundColor = theme.view.backgroundColor
        profilePhoneContainer.backgroundColor = theme.view.backgroundColor
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
        alertCotroller = UIAlertController(title: "Update".localized(using: "Generals"), message: "Please fill in your information".localized(using: "Generals"), preferredStyle: .alert)
        alertCotroller.addTextField { textField in
            textField.placeholder = "Enter your username here".localized(using: "Generals")
            textField.clearButtonMode = .whileEditing
        }
        alertCotroller.addTextField { textField in
            textField.placeholder = "Enter your phone number here".localized(using: "Generals")
            textField.keyboardType = .phonePad
            textField.clearButtonMode = .whileEditing
            textField.delegate = self
        }
        alertCotroller.addAction(UIAlertAction(title: "Cancel".localized(using: "Generals"), style: .cancel))
        alertCotroller.addAction(UIAlertAction(title: "Update".localized(using: "Generals"), style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            if let username = alertCotroller.textFields?[0].text,
               let phoneNumber = alertCotroller.textFields?[1].text {
                let alertController = LoadingViewController()
                
                if DataValidation.validateRequired(field: username, fieldName: "Username") &&
                    DataValidation.validateRequired(field: phoneNumber, fieldName: "Phone number") {
                    present(alertController, animated: true) {
                        alertController.dismiss(animated: true) { [weak self] in
                            guard let self = self else { return }
                            let keychain = KeychainSwift()
                            let accessToken = keychain.get("accessToken")!
                            if let userProfileResponse = userProfileResponse {
                                UserAPIService.shared.updateUserProfileByUuid(token: accessToken, username: username, phoneNumber: phoneNumber, uuid: userProfileResponse.payload.uuid) { response in
                                    switch response {
                                    case .success(let result):
                                        PopUpUtil.popUp(withTitle: "Success".localized(using: "Generals"), withMessage: result.message, withAlert: .success) {
                                            self.userUsername.text = username
                                            self.userPhone.text = phoneNumber
                                        }
                                    case .failure(let error):
                                        print("Error :", error)
                                        if error.code == 401 {
                                            PopUpUtil.popUp(withTitle: "Error".localized(using: "Generals"), withMessage: error.message, withAlert: .cross) {}
                                        } else if error.code == 409 {
                                            PopUpUtil.popUp(withTitle: "Invalid".localized(using: "Generals"), withMessage: error.errors, withAlert: .cross) {}
                                        } else {
                                            PopUpUtil.popUp(withTitle: "Error".localized(using: "Generals"), withMessage: error.message, withAlert: .cross) {}
                                        }
                                    }
                                }
                            } else {
                                PopUpUtil.popUp(withTitle: "Error".localized(using: "Generals"), withMessage: "Something went wrong!", withAlert: .warning) {}
                            }
                        }
                    }
                }
            }
        }))
        present(alertCotroller, animated: true)
    }
    
    @objc func changePasswordTapped(){
        let storyboard = UIStoryboard(name: "CoreScreen", bundle: nil)
        if #available(iOS 13.0, *) {
            let viewController = storyboard.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
            
            if let userProfileResponse = userProfileResponse {
                viewController.userUuid = userProfileResponse.payload.uuid
                navigationController?.pushViewController(viewController, animated: true)
            } else {
                PopUpUtil.popUp(withTitle: "Error".localized(using: "Generals"), withMessage: "Something went wrong!", withAlert: .warning) {}
            }
        }
    }
    
    @objc func logoutTapped(){
        let alertCotroller = UIAlertController(title: "Confrim".localized(using: "Generals"), message: "Are you sure to log out?".localized(using: "Generals"), preferredStyle: .alert)
        alertCotroller.addAction(UIAlertAction(title: "Cancel".localized(using: "Generals"), style: .destructive))
        alertCotroller.addAction(UIAlertAction(title: "Log out".localized(using: "Generals"), style: .default, handler: { _ in
            UserDefaults.standard.setValue(false, forKey: "isLogin")
            let keychain = KeychainSwift()
            keychain.delete("accessToken")
            keychain.delete("refreshToken")
            UIApplication.shared.showLoginViewController()
            NotificationCenter.default.post(name: NSNotification.Name.logoutEvent, object: nil)
        }))
        present(alertCotroller, animated: true)
    }

}

extension UserViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let imageURL =  info[.imageURL] as? URL {
            //upload file to server
            let alertController = LoadingViewController()
            present(alertController, animated: true) {
                alertController.dismiss(animated: true) { [weak self] in
                    guard let self = self else { return }
                    let keychain = KeychainSwift()
                    let accessToken = keychain.get("accessToken")!
                    if let userProfileResponse = userProfileResponse {
                        UserAPIService.shared.uploadUserPhotoByUuid(token: accessToken, uuid: userProfileResponse.payload.uuid, fileURL: imageURL) { response in
                            switch response {
                            case .success(let fileResponse):
                                self.setUpProfileImage(photoUri: fileResponse.uri)
                            case .failure(let error):
                                print("Error :", error)
                                PopUpUtil.popUp(withTitle: "Error".localized(using: "Generals"), withMessage: error.errors, withAlert: .warning) {}
                            }
                        }
                    } else {
                        PopUpUtil.popUp(withTitle: "Error".localized(using: "Generals"), withMessage: "Something went wrong!", withAlert: .warning) {}
                    }
                }
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

extension UserViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
}
