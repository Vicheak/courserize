//
//  ThemeTableViewCell.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 2/8/24.
//

import UIKit

class ThemeTableViewCell: UITableViewCell {

    @IBOutlet weak var themeImageView: UIImageView!
    @IBOutlet weak var themeTitle: UILabel!
    @IBOutlet weak var themeImageViewCheck: UIImageView!
    @IBOutlet weak var innerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
