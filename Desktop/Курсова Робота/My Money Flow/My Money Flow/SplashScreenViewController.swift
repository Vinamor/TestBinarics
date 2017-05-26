//
//  SplashScreenViewController.swift
//  My Money Flow
//
//  Created by Ostap Romaniv on 5/21/17.
//  Copyright © 2017 Ostap Romaniv. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {

    @IBOutlet weak var blurrEffect: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpBlurEffect()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        isUserLogenIn = UserDefaults.standard.bool(forKey: isUserLogenInKey)
        userID = UserDefaults.standard.integer(forKey: userIDKey)
        
        
//        isUserLogenIn ? performSegue(withIdentifier: "ShowAppSegueID", sender: self) :
//            performSegue(withIdentifier: "ShowLoginStoryboardSegueID", sender: self)
        
        performSegue(withIdentifier: "ShowAppSegueID", sender: self)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setUpBlurEffect() {
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = self.blurrEffect.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.blurrEffect.addSubview(blurEffectView)
    }

}
