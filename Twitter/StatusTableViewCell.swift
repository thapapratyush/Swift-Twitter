//
//  StatusTableViewCell.swift
//  Twitter
//
//  Created by Pratyush Thapa on 2/24/17.
//  Copyright © 2017 Pratyush Thapa. All rights reserved.
//

import UIKit

class StatusTableViewCell: UITableViewCell {

    @IBOutlet weak var profileURL: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var numberRetweet: UILabel!
    @IBOutlet weak var numberFavs: UILabel!
    @IBOutlet weak var tweetText: UILabel!

    @IBOutlet weak var userHandle: UILabel!
    
    @IBOutlet weak var timestampLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
