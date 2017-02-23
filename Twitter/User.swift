//
//  User.swift
//  Twitter
//
//  Created by Pratyush Thapa on 2/22/17.
//  Copyright © 2017 Pratyush Thapa. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    var screenname: String?
    var profileURL: NSURL?
    var tagline: String?
    
    init(dictionary: NSDictionary){
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        let profileURLString = dictionary["profile_image_url_https"] as? String
        
        if let profileURLString = profileURLString{
            profileURL = NSURL(string: profileURLString)
        }
        tagline = dictionary["description"] as? String
    }
}
