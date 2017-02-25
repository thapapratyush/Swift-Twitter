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

    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileURL.layer.cornerRadius = 5
        profileURL.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
