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

    
    
    func currentAccount(){
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            print("account:\(response)")
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            //
        })
    }
    
    func getHomeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (NSError) -> ()){
         TwitterClient.sharedInstance?.get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            for tweet in tweets{
                print("\(tweet.text!)")
            }
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error as NSError)
        })

    }
    
    func handleOpenUrl(url: NSURL){
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            self.loginSuccess?()
        }, failure: { (error: Error?) in
            self.loginFailure?(error as! NSError)
        })
    }
    
}
