//
//  Tweet.swift
//  Twitter
//
//  Created by Pratyush Thapa on 2/22/17.
//  Copyright © 2017 Pratyush Thapa. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User
    var text: String?
    var timestamp: Date?
    var retweetCount: Int = 0
    var favoritescount: Int = 0
    var author: NSString?
    var authorProfilePicURL: NSURL?
    var TweetID: NSNumber?
    var urls: [NSDictionary]?
    var media: [NSDictionary]?
    
    
    init(dictionary: NSDictionary){
        self.user = User(dictionary: dictionary["user"] as! NSDictionary)
        TweetID = dictionary["id"] as? NSNumber
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritescount = (dictionary["favourites_count"] as? Int) ?? 0
        urls = dictionary["urls"] as? [NSDictionary]
        media = dictionary["media"] as? [NSDictionary]
        let timestampstring = dictionary["created_at"] as? String
        let user = dictionary["user"] as! NSDictionary
        author = user["name"] as? NSString
        authorProfilePicURL = NSURL(string: (user["profile_image_url_https"] as! String))
        print("\(authorProfilePicURL)")
        if let timestampstring = timestampstring{
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM  HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampstring)
        }

    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        
        for dictionary in dictionaries{
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
}
