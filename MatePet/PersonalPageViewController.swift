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
    @IBOutlet weak var userImageBack: UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var FBLogotButton: UIButton!
    @IBAction func FBLogotButton(sender: UIButton) {
        try! FIRAuth.auth()!.signOut()
        appDelegate.isLogin = false
        guard let vc = self.storyboard!.instantiateViewControllerWithIdentifier("FBLoginView") as? FBLoginViewController else {fatalError()}
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        FIRAuth.auth()?.addAuthStateDidChangeListener { (auth, user) in
            if user == nil {
                let alertController = UIAlertController(title: "使用者未登入", message: "要先登入才能查看個人資料唷！", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                    guard let vc = self.storyboard!.instantiateViewControllerWithIdentifier("FBLoginView") as?FBLoginViewController else {fatalError()}
                    self.presentViewController(vc, animated: true, completion: nil)
                }
                alertController.view.tintColor = UIColor.init(red: 138.0/255.0, green: 14.0/255.0, blue: 77.0/255.0, alpha: 1.0)
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            let facebookData = NSUserDefaults.standardUserDefaults()
            self.userNameLabel.text = facebookData.stringForKey("userName")
            if let photoUrl = facebookData.URLForKey("userPhoto"),
                let photoData = NSData(contentsOfURL: photoUrl) {
                self.userImageView.image = UIImage(data: photoData)
            }
        }
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, 20)
        userImageBack.layer.cornerRadius = self.userImageBack.frame.size.width / 2
        userImageBack.clipsToBounds = true
        userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2
        userImageView.clipsToBounds = true
        self.FBLogotButton.layer.cornerRadius = 5
        }
}