//
//  StatusViewController.swift
//  Twitter
//
//  Created by Pratyush Thapa on 2/24/17.
//  Copyright © 2017 Pratyush Thapa. All rights reserved.
//

import UIKit

class StatusViewController: UIViewController {
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Tweet"
        
        self.profileImage.setImageWithURL(self.status?.user.profileImageUrl)
        self.profileImage.layer.cornerRadius = 9.0
        self.profileImage.layer.masksToBounds = true
        self.nameLabel.text = self.status?.user.name
        self.screennameLabel.text = "@\(self.status!.user.screenname)"
        self.statusTextLabel.text = self.status?.text
        
        var formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy 'at' h:mm aaa"
        self.dateLabel.text = formatter.string(from: self.status!.createdAt as Date)
        
        self.retweetNumberLabel.text = "\(self.status!.numberOfRetweets)"
        self.favoriteNumberLabel.text = "\(self.status!.numberOfFavorites)"
    }
    
}
