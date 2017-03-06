//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Pratyush Thapa on 2/22/17.
//  Copyright © 2017 Pratyush Thapa. All rights reserved.
//

import UIKit
import RevealingSplashView
import Lottie

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    @IBOutlet weak var tableView: UITableView!

    var count = 25
    var tweets: [Tweet]?
    private var revealingLoaded = false
    var loadingMoreView:InfiniteScrollActivityView?
    var isMoreDataLoading = false
    
    override var shouldAutorotate: Bool {
        return revealingLoaded
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        TwitterClient.sharedInstance?.getHomeTimeline(count: count, success: {(tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()

        }, failure: { (error: NSError) in
            print("\(error.localizedDescription)")
        })
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
        TwitterClient.sharedInstance?.getHomeTimeline(count: count, success: { (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error: Error) -> () in
            print(error.localizedDescription)
        })
        
        let backgroundColour = UIColor.init(red: 29, green: 143, blue: 241, alpha: 1)
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "TwitterLogo")!,iconInitialSize: CGSize(width: 70, height: 70), backgroundColor: backgroundColour)
        
        
        self.view.addSubview(revealingSplashView)
        
        revealingSplashView.duration = 0.9
        
        revealingSplashView.iconColor = UIColor.red
        revealingSplashView.useCustomIconColor = false
        
        revealingSplashView.animationType = SplashAnimationType.swingAndZoomOut
        
        revealingSplashView.startAnimation(){
            self.revealingLoaded = true
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return !UIApplication.shared.isStatusBarHidden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.fade
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StatusTableViewCell", for: indexPath) as! StatusTableViewCell
        let tweet = tweets?[indexPath.row]
        if let imageUrlString = tweet?.authorProfilePicURL {
            let imageURL = imageUrlString as URL
            cell.profileURL.layer.cornerRadius = 5
            cell.profileURL.clipsToBounds = true
            cell.profileURL.setImageWith(imageURL)
        }
        cell.profileName.text = tweet?.username
        cell.userHandle.text = "@" + (tweet?.userHandle)!
        cell.timestampLabel.text = timeAgoSince((tweet?.timestamp)!)
        if(!((tweet?.favorited)!)){
            cell.numberFavs.text = String(describing: (tweet?.favoriteCount)!)
            cell.favoriteButton.setImage(UIImage(named: "favor-icon.png"), for: UIControlState.normal)
        }
        if((tweet?.favorited)!){
            cell.numberFavs.text = String(describing: (tweet?.favoriteCount)!)
            cell.numberFavs.textColor = UIColor.red
            cell.favoriteButton.setImage(UIImage(named: "favor-icon-red.png"), for: UIControlState.normal)
        }
        cell.numberRetweet.text = String(describing: (tweet?.retweetCount)!)
        cell.tweetText.text = tweet?.text
        return cell
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

    @IBAction func favorite(_ sender: UITapGestureRecognizer) {
        let buttonPosition:CGPoint = (sender as AnyObject).convert(CGPoint.zero, to: self.tableView)
        let indexPath = tableView.indexPathForRow(at: buttonPosition)
        let tweet = tweets?[(indexPath?.row)!]
        if (tweet?.favorited!)! {
            TwitterClient.sharedInstance?.unfavorite(tweet: tweet!, success: { (tweet: Tweet) -> () in
                TwitterClient.sharedInstance?.getHomeTimeline(count: self.count, success: { (tweets: [Tweet]) -> () in
                    self.tweets = tweets
                    self.tableView.reloadData()
                }, failure: { (error: Error) -> () in
                    print(error.localizedDescription)
                })
                print("unfavorited")
            }, failure: { (error: Error) -> () in
                print(error.localizedDescription)
            })
        } else {
            TwitterClient.sharedInstance?.favorite(tweet: tweet!, success: { (tweet: Tweet) -> () in
                TwitterClient.sharedInstance?.getHomeTimeline(count: self.count, success: { (tweets: [Tweet]) -> () in
                    self.tweets = tweets
                    self.tableView.reloadData()
                }, failure: { (error: Error) -> () in
                    print(error.localizedDescription)
                })
                print("favorited")
            }, failure: { (error: Error) -> () in
                print(error.localizedDescription)
            })
        }
    }
    
    
    @IBAction func Retweet(_ sender: Any) {
        let buttonPosition:CGPoint = (sender as AnyObject).convert(CGPoint.zero, to: self.tableView)
        let indexPath = tableView.indexPathForRow(at: buttonPosition)
        let tweet = tweets?[(indexPath?.row)!]
        if (tweet?.retweeted!)! {
            TwitterClient.sharedInstance?.unretweet(tweet: tweet!, success: { (tweet: Tweet) -> () in
                TwitterClient.sharedInstance?.getHomeTimeline(count: self.count, success: { (tweets: [Tweet]) -> () in
                    self.tweets = tweets
                    self.tableView.reloadData()
                    
                }, failure: { (error: Error) -> () in
                    print(error.localizedDescription)
                })
                print("unretweeted")
            }, failure: { (error: Error) -> () in
                print(error.localizedDescription)
            })
        } else {
            TwitterClient.sharedInstance?.retweet(tweet: tweet!, success: { (tweet: Tweet) -> () in
                TwitterClient.sharedInstance?.getHomeTimeline(count: self.count, success: { (tweets: [Tweet]) -> () in
                    self.tweets = tweets
                    self.tableView.reloadData()
                }, failure: { (error: Error) -> () in
                    print(error.localizedDescription)
                })
                print("retweeted")
            }, failure: { (error: Error) -> () in
                print(error.localizedDescription)
            })
        }
        
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance?.getHomeTimeline(count: count, success: { (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        }, failure: { (error: Error) -> () in
            print(error.localizedDescription)
        })
    }
    
    
    func loadMoreData() {
        TwitterClient.sharedInstance?.getHomeTimeline(count: count, success: { (tweets: [Tweet]) -> () in
            self.isMoreDataLoading = false
            self.loadingMoreView!.stopAnimating()
            self.tweets = tweets
            self.count += 20
            self.tableView.reloadData()
        }, failure: { (error: Error) -> () in
            print(error.localizedDescription)
        })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                loadMoreData()
            }
        }
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
