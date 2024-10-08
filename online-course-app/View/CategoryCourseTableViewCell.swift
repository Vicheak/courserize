//
//  CategoryCourseTableViewCell.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 20/8/24.
//

import UIKit
import SkeletonView

class CategoryCourseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var courseImageView: UIImageView!
    @IBOutlet weak var courseTitleLabel: UILabel!
    @IBOutlet weak var coursePriceLabel: UILabel!
    @IBOutlet weak var courseDurationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        courseImageView.contentMode = .scaleAspectFill
        courseImageView.layer.cornerRadius = 5
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setUpCourseDataSkeletonView(){
        layoutIfNeeded()
        isSkeletonable = true
        courseImageView.isSkeletonable = true
        courseImageView.showAnimatedGradientSkeleton()
        courseTitleLabel.isSkeletonable = true
        courseTitleLabel.showAnimatedGradientSkeleton()
        coursePriceLabel.isSkeletonable = true
        coursePriceLabel.showAnimatedGradientSkeleton()
        courseDurationLabel.isSkeletonable = true
        courseDurationLabel.showAnimatedGradientSkeleton()
    }
    
    public func hideCourseDataSkeletonView(){
        courseTitleLabel.hideSkeleton()
        coursePriceLabel.hideSkeleton()
        courseDurationLabel.hideSkeleton()
    }

}
