//
//  TabBarviewController.swift
//  Twitter
//
//  Created by Pratyush Thapa on 3/7/17.
//  Copyright © 2017 Pratyush Thapa. All rights reserved.


import UIKit

final class TabBarViewController: UITabBarController {
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        NotificationCenter.default
            .addObserver(forName: NSNotification.Name(rawValue: AppInfo.notifications.UserDidLogout), object: nil, queue: OperationQueue.main) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        
        AppInfo.tabBarController = self
    }
    
}
