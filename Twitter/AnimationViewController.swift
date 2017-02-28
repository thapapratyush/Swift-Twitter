//
//  AnimationViewController.swift
//  Twitter
//
//  Created by Pratyush Thapa on 2/27/17.
//  Copyright © 2017 Pratyush Thapa. All rights reserved.
//

import UIKit
import RevealingSplashView

class AnimationViewController: UIViewController {

    
    private var revealingLoaded = false
    
    override var shouldAutorotate: Bool {
        return revealingLoaded
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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
        segtotweets()
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
    
    private func segtotweets() {
        self.performSegue(withIdentifier: "pushtoTweets", sender: self)
    }

}
