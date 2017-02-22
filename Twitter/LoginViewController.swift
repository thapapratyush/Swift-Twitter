//
//  LoginViewController.swift
//  Twitter
//
//  Created by Pratyush Thapa on 2/21/17.
//  Copyright © 2017 Pratyush Thapa. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginTapped(_ sender: Any) {
         let twitterClient = BDBOAuth1SessionManager.init(baseURL: NSURL(string:"https://api.twitter.com")! as URL!, consumerKey: "xUgm852TuX3mcJG7Nfhyw0poo", consumerSecret: "UF9V6RImOjAXUTjJVWWEAcFkieHjO4Rv7wncuKPeMBDOG0A0wJ")
        
        twitterClient?.deauthorize()
        twitterClient?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: NSURL(string: "demotwitter://oauth") as URL!, scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            print ("I got a callback")
            
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\((requestToken?.token)!)")
            //UIApplication.shared.openURL(url as URL)
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: { (true) in
                print("Sucess")
            })
            
        }, failure: { (Error) in
            print ("error:\(Error?.localizedDescription)")
        })
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
