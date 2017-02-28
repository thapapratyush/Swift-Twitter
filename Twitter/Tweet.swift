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
    var favoritescount: Int = 0
    var author: NSString?
    var authorProfilePicURL: NSURL?
    var TweetID: NSNumber?
    var urls: [NSDictionary]?
    var media: [NSDictionary]?
    var username: String?
    var userHandle: String?
    var retweetCount: Int = 0
    var retweeted: Bool?
    var retweeted_status: Tweet?
    var favoriteCount: Int = 0
    var favorited: Bool?
    var id_str: String?
    var current_user_retweet: Tweet?
    
    
    init(dictionary: NSDictionary){
        self.user = User(dictionary: dictionary["user"] as! NSDictionary)
        TweetID = dictionary["id"] as? NSNumber
        text = dictionary["text"] as? String
        id_str = dictionary["id_str"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritescount = (dictionary["favourites_count"] as? Int) ?? 0
        urls = dictionary["urls"] as? [NSDictionary]
        media = dictionary["media"] as? [NSDictionary]
        let timestampString = dictionary["created_at"] as? String
        let user = dictionary["user"] as! NSDictionary
        author = user["name"] as? NSString
        authorProfilePicURL = NSURL(string: (user["profile_image_url_https"] as! String))
        username = user["name"] as? String
        userHandle = user["screen_name"] as? String
        if let timestampString = timestampString{
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString)
        }
        let current_user_retweet_dict = (dictionary["current_user_retweet"] as? NSDictionary)
        if current_user_retweet_dict != nil {
            current_user_retweet = Tweet(dictionary: current_user_retweet_dict!)
        } else {
            current_user_retweet = nil
        }
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        retweeted = dictionary["retweeted"] as? Bool
        let retweeted_status_dict = (dictionary["retweeted_status"] as? NSDictionary) ?? nil
        if retweeted_status_dict != nil {
            retweeted_status = Tweet(dictionary: retweeted_status_dict!)
        } else {
            retweeted_status = nil
        }
        favoriteCount = (dictionary["favorite_count"] as? Int) ?? 0
        favorited = dictionary["favorited"] as? Bool
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
