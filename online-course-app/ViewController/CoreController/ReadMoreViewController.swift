//
//  ReadMoreViewController.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 20/8/24.
//

import UIKit

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

        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        descriptionDetail.text = descriptionDetailText
        closeButton.setTitle("", for: .normal)
    }

    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}
