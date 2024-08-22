//
//  SearchCourseTableViewCell.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 21/8/24.
//

import UIKit
import SkeletonView

class SearchCourseTableViewCell: UITableViewCell {

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
    
}
