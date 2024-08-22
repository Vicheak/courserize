//
//  SubscriptionAuthorTableViewCell.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 22/8/24.
//

import UIKit

class SubscriptionAuthorTableViewCell: UITableViewCell {

    @IBOutlet weak var subscriberImageView: UIImageView!
    @IBOutlet weak var subscriberUsername: UILabel!
    @IBOutlet weak var subscriberEmail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
