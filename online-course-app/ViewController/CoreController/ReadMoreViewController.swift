//
//  ReadMoreViewController.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 20/8/24.
//

import UIKit
import Localize_Swift

class ReadMoreViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var stackInnerView: UIView!
    @IBOutlet weak var descriptionDetail: UILabel!
    @IBOutlet weak var detailTitle: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    var descriptionDetailText: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setText()

        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        descriptionDetail.text = descriptionDetailText
        closeButton.setTitle("", for: .normal)
        
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
    
    @objc func setText(){
        detailTitle.text = "Course Description".localized(using: "Generals")
        detailTitle.font = UIFont(name: "KhmerOSBattambang-Bold", size: 20)
    }
    
    @objc func setColor() {
        let theme = ThemeManager.shared.theme
        view.backgroundColor = theme.view.backgroundColor
        detailTitle.textColor = theme.label.primaryColor
        closeButton.tintColor = theme.label.primaryColor
        descriptionDetail.textColor = theme.label.primaryColor
    }

    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}
