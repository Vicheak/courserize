//
//  VideoListTableViewCell.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 23/8/24.
//

import UIKit

class VideoListTableViewCell: UITableViewCell {

    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        playButton.setTitle("", for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
