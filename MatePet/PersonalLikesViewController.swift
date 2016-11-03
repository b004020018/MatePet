//
//  PersonalLikesViewController.swift
//  MatePet
//
//  Created by RosalieRabbit on 2016/10/17.
//  Copyright © 2016年 RosalieRabbit. All rights reserved.
//

import UIKit
import Firebase
import MediaPlayer
import AVKit
import SwiftGifOrigin

class PersonalLikesTableCell: UITableViewCell {
    
    @IBOutlet weak var catAge: UILabel!
    @IBOutlet weak var catSex: UILabel!
    @IBOutlet weak var catColour: UILabel!
    @IBOutlet weak var catDistrict: UILabel!
    @IBOutlet weak var catView: UIView!
    @IBOutlet weak var imageIndicator: UIActivityIndicatorView!
    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var catLikesCountLabel: UILabel!
}


class PersonalLikesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var personalLikesTableView: UITableView!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var receiveCats = [Cat]()
    var likesCats = [Cat]()
    var postsID = [String]()
    var passCat: Cat!
    
    override func viewDidAppear(animated: Bool) {
        if appDelegate.isLogin == false {
            let alertController = UIAlertController(title: "使用者未登入", message: "要先登入才能管理最愛唷！", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                guard let vc = self.storyboard!.instantiateViewControllerWithIdentifier("FBLoginView") as?FBLoginViewController else {fatalError()}
                self.presentViewController(vc, animated: true, completion: nil)
            }
            alertController.view.tintColor = UIColor.init(red: 138.0/255.0, green: 14.0/255.0, blue: 77.0/255.0, alpha: 1.0)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        self.receiveCats = LocalDataModel.shared.cats
        let databaseRef = FIRDatabase.database().reference().child("Likes")
        let user = (FIRAuth.auth()?.currentUser?.uid)!
        databaseRef.queryOrderedByChild("likePersonID").queryEqualToValue(user).observeEventType(.Value , withBlock: { snapshot in
            self.postsID = []
            if snapshot.exists() {
                for item in [snapshot.value] {
                    guard let itemDictionary = item as? NSDictionary else {
                        fatalError()
                    }
                    
                    guard let firebaseItemValue = itemDictionary.allValues as? [NSDictionary] else {
                        fatalError()
                    }
                    for item in firebaseItemValue {
                        let postID = item["postID"] as! String
                        self.postsID.append(postID)
                    }
                }
            }
            self.likesCats = []
            for catItem in self.receiveCats {
                for postItem in self.postsID{
                    if catItem.catID == postItem {
                        self.likesCats.append(catItem)
                    }
                }
            }
            self.personalLikesTableView.reloadData()
        })
    }
    

    

    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return likesCats.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.personalLikesTableView.dequeueReusableCellWithIdentifier("personalLikesTableCell",forIndexPath: indexPath) as! PersonalLikesTableCell
        cell.imageIndicator.startAnimating()
        cell.catDistrict.text = likesCats[indexPath.row].district
        cell.catSex.text = likesCats[indexPath.row].sex
        cell.catColour.text = likesCats[indexPath.row].colour
        cell.catAge.text = likesCats[indexPath.row].age
        cell.catLikesCountLabel.text = String(likesCats[indexPath.row].likesCount)
        let catID = likesCats[indexPath.row].catID
        if likesCats[indexPath.row].selected == "image" {
            let storageRef = FIRStorage.storage().referenceWithPath("Cats/\(catID).jpg")
            storageRef.downloadURLWithCompletion { (url, error) -> Void in
                if (error != nil) {
                    print("error")
                } else {
                    cell.catImageView.hnk_setImageFromURL(url!)
                }
            cell.imageIndicator.stopAnimating()
            }
        }else if likesCats[indexPath.row].selected == "video" {
            let storageRef = FIRStorage.storage().referenceWithPath("Cats/\(catID).gif")
            storageRef.downloadURLWithCompletion{ (url, error) -> Void in
                if error != nil {
                    print("error")
                } else {
                    guard let gifUrl = url else {
                        print("can't get gif url from firebase")
                        return
                    }
                    cell.catImageView.image = UIImage.gifWithURL("\(gifUrl)")
                }
            cell.imageIndicator.stopAnimating()
            }
        }

        
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        passCat = likesCats[indexPath.row]
        self.performSegueWithIdentifier("LikesToSingleCatView", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let segueIdentifier = segue.identifier else { fatalError() }
        
        if segueIdentifier == "LikesToSingleCatView" {
            
            guard let destViewController = segue.destinationViewController as? SingleCatDetailViewController else
            {
                fatalError()
            }
            
            destViewController.cat = passCat
            destViewController.buttonHidden = true
            
        }
        
    }
    
    
    
}