//
//  PersonalPageViewController.swift
//  MatePet
//
//  Created by RosalieRabbit on 2016/10/13.
//  Copyright © 2016年 RosalieRabbit. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class PersonalPageViewController: UIViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBAction func FBLogotButton(sender: UIButton) {
        try! FIRAuth.auth()!.signOut()
        let ToMainViewController = storyboard!.instantiateViewControllerWithIdentifier("FBLoginView") as! FBLoginViewController
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = ToMainViewController

    }
    

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, 20)
        
        userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2
        userImageView.clipsToBounds = true
        
        let facebookData = NSUserDefaults.standardUserDefaults()
        userNameLabel.text = facebookData.stringForKey("userName")
        if let photoUrl = facebookData.URLForKey("userPhoto"),
            let photoData = NSData(contentsOfURL: photoUrl) {
            userImageView.image = UIImage(data: photoData)
        }
    }


}