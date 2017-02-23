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
    
    var dictionary:  NSDictionary?
    
    init(dictionary: NSDictionary){
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        let profileURLString = dictionary["profile_image_url_https"] as? String
        
        if let profileURLString = profileURLString{
            profileURL = NSURL(string: profileURLString)
        }
        tagline = dictionary["description"] as? String
    }
    
    static var _currentUser: User?
    
    class var currentUser: User?{
        get{
            if _currentUser == nil{
            let defaults = UserDefaults.init()
            let userData = defaults.object(forKey: "currentUserData")
            if let userData = userData{
                let dictionary = try!  JSONSerialization.jsonObject(with: userData as! Data, options: [])
                _currentUser = User(dictionary: dictionary as! NSDictionary)
            }
                
            }
            return _currentUser
        }
        set(user){
            let defaults = UserDefaults.init()
            if let user = user {
                let data = try!  JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            }else{
                defaults.set(nil, forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
    
}
