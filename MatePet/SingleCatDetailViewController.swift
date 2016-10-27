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

class SingleCatDetailViewController: UIViewController {
    
    var cat: Cat!
    var buttonHidden: Bool!
    
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
        let userFacebookID = facebookData.stringForKey("userFacebookID")!
        let FBmessengerLink = "http://m.me/\(userFacebookID)"
        
        let FBURL = NSURL(string: FBmessengerLink)!
        
        if UIApplication.sharedApplication().canOpenURL(FBURL) {
            
            UIApplication.sharedApplication().openURL(FBURL)
            
        } else {
            
            let safariVC = SFSafariViewController(URL: FBURL)
            
            presentViewController(safariVC, animated: true, completion: nil)
        }
        
    }
    
    
    let facebookData = NSUserDefaults.standardUserDefaults()
    var userFirebaseID: String!

    
    @IBAction func loveButton(sender: FaveButton) {
        let rootRef = FIRDatabase.database().reference()
        if snapshotExist == false {
            let like: [String : AnyObject] = [
                "postID" : cat.catID,
                "likePersonID" : userFirebaseID]
            let autoID = rootRef.child("Likes").childByAutoId().key
            rootRef.child("Likes").child(autoID).setValue(like)
            
            let childUpdates = ["/\(cat.catID)/likesCount": cat.likesCount + 1]
            rootRef.child("Cats").updateChildValues(childUpdates)
            
            guard let n: Int = (self.navigationController?.viewControllers.count) else {
                print("can't get navigationController?.viewControllers.count")
                return
            }
            if let presentVC = self.navigationController?.viewControllers[n-2] as? QueryViewController {
                presentVC.acceptLikesCount(cat.catID, likesCount: cat.likesCount + 1)
            }
        }else {
            
            let likeID = likeKey
            rootRef.child("Likes").child(likeID).removeValue()
            
            let childUpdates = ["/\(cat.catID)/likesCount": cat.likesCount - 1]
            rootRef.child("Cats").updateChildValues(childUpdates)
            
            guard let n: Int = (self.navigationController?.viewControllers.count) else {
                print("can't get navigationController?.viewControllers.count")
                return
            }
            if let presentVC = self.navigationController?.viewControllers[n-2] as? QueryViewController {
                presentVC.acceptLikesCount(cat.catID, likesCount: cat.likesCount - 1)
                
            }
        }
    }
    
    
    var snapshotExist = false
    var likeKey = ""
    
//    fb-messenger://user-thread/USER_ID
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if buttonHidden == true {
            self.closeButton.hidden = true
        }else {
            self.closeButton.hidden = false
        }
        imageIndicator.startAnimating()
        catAgeLabel.text = cat.age
        catColourLabel.text = cat.colour
        catSexLabel.text = cat.sex
        catDistrictLabel.text = cat.district
        catDescription.text = cat.description
        userFirebaseID = facebookData.stringForKey("userFirebaseID")
        if cat.selected == "image" {
            let storageRef = FIRStorage.storage().referenceWithPath("Cats/\(cat.catID).jpg")
            storageRef.downloadURLWithCompletion { (url, error) -> Void in
                if (error != nil) {
                    print("error")
                } else {
                    self.catImageView.hnk_setImageFromURL(url!)
                }
            self.imageIndicator.stopAnimating()
            }
        }else if cat.selected == "video" {
            let storageRef = FIRStorage.storage().referenceWithPath("Cats/\(cat.catID).mov")
            storageRef.downloadURLWithCompletion{ (url, error) -> Void in
                if error != nil {
                    print("error")
                } else {
                    let player = AVPlayer(URL: url!)
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = player
                    playerViewController.view.frame = self.catView.frame
                    self.catView.addSubview(playerViewController.view)
                    self.addChildViewController(playerViewController)
                    
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
