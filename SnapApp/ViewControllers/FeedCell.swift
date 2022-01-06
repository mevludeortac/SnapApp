//
//  FeedCell.swift
//  SnapApp
//
//  Created by MEWO on 6.01.2022.
//

import UIKit

class FeedCell: UITableViewCell {

    
    @IBOutlet weak var usernameFeed: UILabel!
    @IBOutlet weak var imageViewFeed: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
