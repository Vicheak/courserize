//
//  LanguageTableViewCell.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 2/8/24.
//

import UIKit

class LanguageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var languageImageView: UIImageView!
    @IBOutlet weak var languageTitle: UILabel!
    @IBOutlet weak var languageImageViewCheck: UIImageView!
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
