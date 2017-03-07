//
//  AppInfo.swift
//  Twitter
//
//  Created by Pratyush Thapa on 3/7/17.
//  Copyright © 2017 Pratyush Thapa. All rights reserved.
//

import UIKit



import UIKit
import Foundation

struct AppInfo {
    static var tabBarController: UITabBarController?
    
    // MARK: - Constants
    static let storyboard = UIStoryboard(name: "Main", bundle:nil)
    struct notifications {
        //TODO: implement alternatives to NSNotificationCenter
        static let ReturnToSplash = "ReturnToSplash"
        static let DetailsTweetChainReady = "DetailsTweetChainReady"
        static let ProfileConfigureSubviews = "ProfileConfigureSubviews"
        static let ProfileConfigureRightSubviews = "ProfileConfigureRightSubviews"
        static let ProfileConfigureView = "ProfileConfigureView"
        static let UserDidLogout = "UserDidLogout"
    }
    
    // MARK: - Public Helper Functions
    static func switchToProfileTab(reloadUserProfile: Bool = false) {
        if reloadUserProfile {
            let pnVc = tabBarController?.childViewControllers.last as! UINavigationController
            let pVc = pnVc.viewControllers.first as! DetailsViewController
        }
        
        tabBarController?.selectedIndex = 3
    }
    
    func openTweetDetails(tweet: Tweet) {
        let vc = AppInfo.storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        vc.tweet = tweet
        UIApplication.shared.delegate?.window??.rootViewController!.presentedViewController!.present(vc, animated: true, completion: nil)
    }
}



// MARK: - String
public extension String {
    
    func replace(target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString, options: .literal, range: nil)
    }
    
}
