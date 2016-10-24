//
//  FBLoginViewController.swift
//  MatePet
//
//  Created by RosalieRabbit on 2016/9/28.
//  Copyright © 2016年 RosalieRabbit. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import Crashlytics

class FBLoginViewController: UIViewController {
    @IBAction func FBLoginButton(sender: UIButton) {
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logInWithReadPermissions(["public_profile", "email"], fromViewController: self, handler:{(facebookResult, facebookError) -> Void in
            if facebookError != nil { print("Facebook login failed. Error \(facebookError)")
            } else if facebookResult.isCancelled { print("Facebook login was cancelled.")
            } else {
                let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
                FIRAuth.auth()?.signInWithCredential(credential) {(user, error) in
                  //store user Data
                    guard let user = user else { fatalError() }

                    let userDefault = NSUserDefaults.standardUserDefaults()
                    for profile in user.providerData {
                    userDefault.setValue(profile.uid, forKey: "userFacebookID")
                    }
                    
                    userDefault.setValue(user.uid, forKey: "userFirebaseID")
                    userDefault.setValue(user.displayName, forKey: "userName")
                    userDefault.setValue(user.email, forKey: "userName")
                    userDefault.setURL(user.photoURL, forKey: "userPhoto")
                    userDefault.synchronize()
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let ToMainViewController = storyboard.instantiateViewControllerWithIdentifier("ToTabBarController") as! UITabBarController
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.window?.rootViewController = ToMainViewController
                    
                    print("You’re in :)")
                }
            }
        })
    }
    
}


