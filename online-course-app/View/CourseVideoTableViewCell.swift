//
//  CourseVideoTableViewCell.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 23/8/24.
//

import UIKit

class CourseVideoTableViewCell: UITableViewCell {

    @IBOutlet weak var courseImageView: UIImageView!
    @IBOutlet weak var courseTitle: UILabel!
    @IBOutlet weak var coursePrice: UILabel!
    @IBOutlet weak var courseDuration: UILabel!
    
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
