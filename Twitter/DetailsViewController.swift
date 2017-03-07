//
//  DetialsViewController.swift
//  Twitter
//
//  Created by Pratyush Thapa on 3/7/17.
//  Copyright © 2017 Pratyush Thapa. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var profilepicView: UIImageView!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var userNameLabel: UIButton!
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilepicView.layer.cornerRadius = 5
        profilepicView.clipsToBounds = true
        userNameLabel.setTitle(tweet.username , for: .normal)
        handleLabel.text = "@" + (tweet.userHandle )!
        
        tweetTextLabel.text = tweet.text!
        profilepicView.setImageWith(tweet.authorProfilePicURL! as URL)
        if let timestamp = tweet.timestamp {
            timestampLabel.text = timeAgoSince(timestamp)
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func timeAgoSince(_ date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now, options: [])
        if let year = components.year, year >= 2 {
            return "\(year) years ago"
        }
        
        if let year = components.year, year >= 1 {
            return "Last year"
        }
        
        if let month = components.month, month >= 2 {
            return "\(month) months ago"
        }
        
        if let month = components.month, month >= 1 {
            return "Last month"
        }
        
        if let week = components.weekOfYear, week >= 2 {
            return "\(week) weeks ago"
        }
        
        if let week = components.weekOfYear, week >= 1 {
            return "Last week"
        }
        
        if let day = components.day, day >= 2 {
            return "\(day) days ago"
        }
        
        if let day = components.day, day >= 1 {
            return "Yesterday"
        }
        
        if let hour = components.hour, hour >= 2 {
            return "\(hour) hours ago"
        }
        
        if let hour = components.hour, hour >= 1 {
            return "An hour ago"
        }
        
        if let minute = components.minute, minute >= 2 {
            return "\(minute) minutes ago"
        }
        
        if let minute = components.minute, minute >= 1 {
            return "A minute ago"
        }
        
        if let second = components.second, second >= 3 {
            return "\(second) seconds ago"
        }
        return "Just now"
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*if segue.identifier == "tweetIdentifier"{
            let vc = segue.destination as! TweetUserViewController
            vc.tweet = tweet
            // Get the new view controller using segue.destinationViewController.
            // Pass the selected object to the new view controller.
        }*/
    }
}
