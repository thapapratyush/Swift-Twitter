//
//  Tweet.swift
//  Twitter
//
//  Created by Pratyush Thapa on 2/22/17.
//  Copyright © 2017 Pratyush Thapa. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var text: String?
    var timestamp: Date?
    var retweetCount: Int = 0
    var favoritescount: Int = 0
    
    init(dictionary: NSDictionary){
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritescount = (dictionary["favourites_count"] as? Int) ?? 0
        let timestampstring = dictionary["created_at"] as? String

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
