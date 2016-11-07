//
//  SingleCatDetailViewController.swift
//  MatePet
//
//  Created by RosalieRabbit on 2016/10/14.
//  Copyright © 2016年 RosalieRabbit. All rights reserved.
//

import UIKit
import Firebase
import SafariServices
import MediaPlayer
import AVKit
import FaveButton
import SwiftGifOrigin
import FBSDKShareKit

class SingleCatDetailViewController: UIViewController {
    
    var cat: Cat!
    var buttonHidden: Bool!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var catView: UIView!
   
    @IBOutlet weak var catAgeLabel: UILabel!
    @IBOutlet weak var catSexLabel: UILabel!
    @IBOutlet weak var catColourLabel: UILabel!
    @IBOutlet weak var catDistrictLabel: UILabel!
    @IBOutlet weak var catDescription: UILabel!
    
    @IBOutlet weak var catImageView: UIImageView!
    
    @IBOutlet weak var loveButton: FaveButton!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBAction func closeButton(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func ownerMessengerLinkButton(sender: UIButton) {
        let userFacebookID = cat.userFacebookID
        let FBmessengerLink = "https://www.facebook.com/\(userFacebookID)"
        
        guard let fbURL = NSURL(string: FBmessengerLink) else {
        print("can't get link")
        return
        }
            
        let safariVC = SFSafariViewController(URL: fbURL)
        presentViewController(safariVC, animated: true, completion: nil)
        
    }
    
    @IBAction func ShareButton(sender: UIButton) {
        if appDelegate.isLogin == false {
            let alertController = UIAlertController(title: "使用者未登入", message: "要先登入才能分享到FB唷！", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                guard let vc = self.storyboard!.instantiateViewControllerWithIdentifier("FBLoginView") as?FBLoginViewController else {fatalError()}
                self.presentViewController(vc, animated: true, completion: nil)
            }
            alertController.view.tintColor = UIColor.init(red: 138.0/255.0, green: 14.0/255.0, blue: 77.0/255.0, alpha: 1.0)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        let content = FBSDKShareLinkContent()
        guard let shareImageLink = self.catImageLink else {
            print("can't get ImageURL")
            return
        }
        content.contentURL = shareImageLink
        FBSDKShareDialog.showFromViewController(self, withContent: content, delegate: nil)
    }
    
    
    
    let facebookData = NSUserDefaults.standardUserDefaults()
    var userFirebaseID: String?

    
    @IBAction func loveButton(sender: FaveButton) {
        
        if appDelegate.isLogin == false {
            self.loveButton.selected = false
            let alertController = UIAlertController(title: "使用者未登入", message: "要先登入才能收藏到最愛唷！", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                guard let vc = self.storyboard!.instantiateViewControllerWithIdentifier("FBLoginView") as?FBLoginViewController else {fatalError()}
                self.presentViewController(vc, animated: true, completion: nil)
            }
            alertController.view.tintColor = UIColor.init(red: 138.0/255.0, green: 14.0/255.0, blue: 77.0/255.0, alpha: 1.0)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        let rootRef = FIRDatabase.database().reference()
        if self.snapshotExist == false {
            let like: [String : AnyObject] = [
                "postID" : self.cat.catID,
                "likePersonID" : self.userFirebaseID!]
            let autoID = rootRef.child("Likes").childByAutoId().key
            rootRef.child("Likes").child(autoID).setValue(like)
            
            let childUpdates = ["/\(self.cat.catID)/likesCount": self.cat.likesCount + 1]
            rootRef.child("Cats").updateChildValues(childUpdates)
            
            guard let n: Int = (self.navigationController?.viewControllers.count) else {
                print("can't get navigationController?.viewControllers.count")
                return
            }
            if let presentVC = self.navigationController?.viewControllers[n-2] as? QueryViewController {
                presentVC.acceptLikesCount(self.cat.catID, likesCount: self.cat.likesCount + 1)
            }
        }else {
            
            let likeID = self.likeKey
            
            rootRef.child("Likes").child(likeID).removeValue()
            
            let childUpdates = ["/\(self.cat.catID)/likesCount": self.cat.likesCount - 1]
            rootRef.child("Cats").updateChildValues(childUpdates)
            
            guard let n: Int = (self.navigationController?.viewControllers.count) else {
                print("can't get navigationController?.viewControllers.count")
                return
            }
            if let presentVC = self.navigationController?.viewControllers[n-2] as? QueryViewController {
                presentVC.acceptLikesCount(self.cat.catID, likesCount: self.cat.likesCount - 1)
            }}
    }
    
    
    var snapshotExist = false
    var likeKey = ""
    var catImageLink: NSURL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if buttonHidden == true {
            self.closeButton.hidden = true
        }else {
            self.closeButton.hidden = false
            self.closeButton.layer.cornerRadius = 0.5 * closeButton.bounds.size.width
        }

        imageIndicator.startAnimating()
        catAgeLabel.text = cat.age
        catColourLabel.text = cat.colour
        catSexLabel.text = cat.sex
        catDistrictLabel.text = cat.district
        catDescription.text = cat.description
        userFirebaseID = FIRAuth.auth()?.currentUser?.uid
        if cat.selected == "image" {
            let storageRef = FIRStorage.storage().referenceWithPath("Cats/\(cat.catID).jpg")
            storageRef.downloadURLWithCompletion { (url, error) -> Void in
                if (error != nil) {
                    print("error")
                } else {
                    self.catImageLink = url
                    self.catImageView.hnk_setImageFromURL(url!)
                }
            self.imageIndicator.stopAnimating()
            }
        }else if cat.selected == "video" {
            let storageRef = FIRStorage.storage().referenceWithPath("Cats/\(cat.catID).gif")
            storageRef.downloadURLWithCompletion{ (url, error) -> Void in
                if error != nil {
                    print("error")
                } else {
                    if error != nil {
                        print("error")
                    } else {
                        guard let gifUrl = url else {
                            print("can't get gif url from firebase")
                            return
                        }
                        self.catImageLink = url
                        self.catImageView.image = UIImage.gifWithURL("\(gifUrl)")
                    }
                }
            self.imageIndicator.stopAnimating()
            }
        }
        
        
        
        let databaseRef = FIRDatabase.database().reference().child("Likes")
        databaseRef.queryOrderedByChild("postID").queryEqualToValue(cat.catID).observeEventType(.Value , withBlock: { snapshot in
            if snapshot.exists() {
                for item in [snapshot.value] {
                    guard let itemDictionary = item as? NSDictionary else {
                        fatalError()
                    }
                    guard let firebaseItemKey = itemDictionary.allKeys as? [String] else {
                        fatalError()
                    }
                    
                    guard let firebaseItemValue = itemDictionary.allValues as? [NSDictionary] else {
                        fatalError()
                    }
                    
                    for (index,item) in firebaseItemValue.enumerate() {
                        let likePersonID = item["likePersonID"] as! String
                        
                        if likePersonID  == self.userFirebaseID {
                            self.likeKey = firebaseItemKey[index]
                            self.loveButton.selected = true
                            self.snapshotExist = true
                            return
                        } else {
                            self.loveButton.selected = false
                            self.snapshotExist = false
                        }
                    }
                }
            } else {
            self.loveButton.selected = false
            self.snapshotExist = false
            }
        })
    }
}
