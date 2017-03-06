//
//  TwitterClient.swift
//  Twitter
//
//  Created by Pratyush Thapa on 2/22/17.
//  Copyright © 2017 Pratyush Thapa. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    static let sharedInstance = TwitterClient(baseURL: NSURL(string:"https://api.twitter.com")! as URL!, consumerKey: "xUgm852TuX3mcJG7Nfhyw0poo", consumerSecret: "UF9V6RImOjAXUTjJVWWEAcFkieHjO4Rv7wncuKPeMBDOG0A0wJ")
    
    var loginSuccess: (()->())?
    var loginFailure:((NSError)->())?
    
    
    func login(success:@escaping ()->() , failure:@escaping (NSError)->()){
        loginSuccess = success
        loginFailure = failure
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: NSURL(string: "demotwitter://oauth") as URL!, scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            print ("I got a callback")
            
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\((requestToken?.token)!)")
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: { (true) in
                print("Sucess")
            })
            
        }, failure: { (Error) in
            print ("error:\(Error?.localizedDescription)")
            self.loginFailure?(Error as! NSError)
        })
    }

    
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error)-> ()){
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            print("account:\(response)")
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            success(user)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error as NSError)
        })
    }
    
    func getHomeTimeline(count: Int, success: @escaping ([Tweet]) -> (), failure: @escaping (NSError) -> ()){
         TwitterClient.sharedInstance?.get("1.1/statuses/home_timeline.json", parameters: ["count": count], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            success(tweets)
            
        }, failure: { (task: ExpressibleByNilLiteral, error: Error) in
            failure(error as NSError)
        })

    }
    
    func handleOpenUrl(url: NSURL){
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            self.currentAccount(success: { (user) in
                User.currentUser = user 
                self.loginSuccess?()
            }, failure: { (error: Error?) in
                self.loginFailure?(error as! NSError)
            })
        }, failure: { (error: Error?) in
            self.loginFailure?(error as! NSError)
        })
    }
    
    
    
    func retweet(tweet: Tweet, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        post("1.1/statuses/retweet/" + tweet.id_str! + ".json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let dictionary = response as? NSDictionary
            let tweet = Tweet(dictionary: dictionary!)
            success(tweet)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func favorite(tweet: Tweet, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        post("1.1/favorites/create.json", parameters: ["id": tweet.id_str!], progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let dictionary = response as? NSDictionary
            let tweet = Tweet(dictionary: dictionary!)
            success(tweet)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
            
        })
    }
    
    func unretweet(tweet: Tweet, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        if !tweet.retweeted! {
        } else {
            var original_tweet_id: String?
            
            if tweet.retweeted_status == nil {
                original_tweet_id = tweet.id_str
            } else {
                original_tweet_id = tweet.retweeted_status?.id_str
            }
            get("1.1/statuses/show.json", parameters: ["id": original_tweet_id!, "include_my_retweet": true], progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
                let dictionary = response as? NSDictionary
                let full_tweet = Tweet(dictionary: dictionary!)
                let retweet_id = full_tweet.current_user_retweet?.id_str
                // step 3
                self.post("1.1/statuses/unretweet/" + retweet_id! + ".json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
                    let dictionary = response as? NSDictionary
                    let tweet = Tweet(dictionary: dictionary!)
                    success(tweet)
                }, failure: { (task: URLSessionDataTask?, error: Error) in
                    failure(error)
                })
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                print(error.localizedDescription)
            })
        }
    }
    
    func unfavorite(tweet: Tweet, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        post("1.1/favorites/destroy.json", parameters: ["id": tweet.id_str!], progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let dictionary = response as? NSDictionary
            let tweet = Tweet(dictionary: dictionary!)
            success(tweet)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
            
        })
    }
}
