//
//  MainCourseCollectionViewCell.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 19/8/24.
//

import UIKit
import SkeletonView

class MainCourseCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var courseImageView: UIImageView!
    @IBOutlet weak var courseTitle: UILabel!
    @IBOutlet weak var courseShortDescription: UILabel!
    @IBOutlet weak var coursePrice: UILabel!
    @IBOutlet weak var courseDuration: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        courseImageView.contentMode = .scaleAspectFill
        isSkeletonable = true
        courseImageView.isSkeletonable = true
        courseImageView.showAnimatedGradientSkeleton()
        courseTitle.isSkeletonable = true
        courseTitle.showAnimatedGradientSkeleton()
        courseShortDescription.isSkeletonable = true
        courseShortDescription.skeletonTextNumberOfLines = 3
        courseShortDescription.showAnimatedGradientSkeleton()
        coursePrice.isSkeletonable = true
        coursePrice.showAnimatedGradientSkeleton()
        courseDuration.isSkeletonable = true
        courseDuration.showAnimatedGradientSkeleton()
    }

}
