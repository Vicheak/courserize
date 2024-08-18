//
//  CourseCollectionViewCell.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 18/8/24.
//

import UIKit

class CourseCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var courseImageView: UIImageView!
    @IBOutlet weak var courseTitle: UILabel!
    @IBOutlet weak var courseShortDescription: UILabel!
    @IBOutlet weak var coursePrice: UILabel!
    @IBOutlet weak var courseDuration: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}
