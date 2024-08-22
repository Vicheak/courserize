//
//  SubscriptionAuthorTableViewCell.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 22/8/24.
//

import UIKit

class SubscriptionAuthorDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var subscriptionCourseImageView: UIImageView!
    @IBOutlet weak var courseTitle: UILabel!
    @IBOutlet weak var coursePrice: UILabel!
    @IBOutlet weak var subscriptionStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
