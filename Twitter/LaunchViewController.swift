//
//  LaunchViewController.swift
//  Twitter
//
//  Created by Pratyush Thapa on 2/24/17.
//  Copyright © 2017 Pratyush Thapa. All rights reserved.
//

import UIKit
import CBZSplashView

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        CBZSplashView.init(icon: #imageLiteral(resourceName: "Twitter_Logo_Blue.png"), backgroundColor: nil)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
