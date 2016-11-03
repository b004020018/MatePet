//
//  PersonalOwnedViewController.swift
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

class PersonalOwnsTableCell: UITableViewCell {
    
    @IBOutlet weak var catAge: UILabel!
    @IBOutlet weak var catSex: UILabel!
    @IBOutlet weak var catColour: UILabel!
    @IBOutlet weak var catDistrict: UILabel!
    @IBOutlet weak var catView: UIView!
    @IBOutlet weak var imageIndicator: UIActivityIndicatorView!
    @IBOutlet weak var catImageView: UIImageView!
    
    @IBOutlet weak var deleteButton: UIButton!
}

protocol OwnsManagerDelegate: class {
    
    func manager(manager: LocalDataModel, didGetCats cats: [Cat])
    
}


class PersonalOwnsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, OwnsManagerDelegate {

    @IBOutlet weak var personalOwnsTableView: UITableView!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var receiveCats = [Cat]()
    var OwnsCats = [Cat]()
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
        let vc = LocalDataModel.shared
        vc.ownsdelegate = self
        vc.fetchCats()
    }
    
    func manager(manager: LocalDataModel, didGetCats cats: [Cat]){
        self.receiveCats = cats
        let user = (FIRAuth.auth()?.currentUser?.uid)!
        self.OwnsCats = []
        for catItem in self.receiveCats {
            if catItem.owner == user {
                self.OwnsCats.append(catItem)
            }
        }
        self.personalOwnsTableView.reloadData()
    
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return OwnsCats.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.personalOwnsTableView.dequeueReusableCellWithIdentifier("personalOwnsTableCell",forIndexPath: indexPath) as! PersonalOwnsTableCell
        cell.imageIndicator.startAnimating()
        cell.catDistrict.text = OwnsCats[indexPath.row].district
        cell.catSex.text = OwnsCats[indexPath.row].sex
        cell.catColour.text = OwnsCats[indexPath.row].colour
        cell.catAge.text = OwnsCats[indexPath.row].age
//        cell.deleteButton
        cell.deleteButton.layer.cornerRadius = 0.5 * cell.deleteButton.bounds.size.width
        cell.deleteButton.addTarget(self, action: #selector(self.deletePost(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let catID = OwnsCats[indexPath.row].catID
        if OwnsCats[indexPath.row].selected == "image" {
            let storageRef = FIRStorage.storage().referenceWithPath("Cats/\(catID).jpg")
            storageRef.downloadURLWithCompletion { (url, error) -> Void in
                if (error != nil) {
                    print("error")
                } else {
                    cell.catImageView.hnk_setImageFromURL(url!)
                }
            cell.imageIndicator.stopAnimating()
            }
        }else if OwnsCats[indexPath.row].selected == "video" {
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
        passCat = OwnsCats[indexPath.row]
        self.performSegueWithIdentifier("OwnsToSingleCatView", sender: self)
    }
    
    func deletePost(sender: UIButton!) {
        //delete database
        guard
        let cell = sender.superview?.superview as? PersonalOwnsTableCell,
        let indexPath = personalOwnsTableView.indexPathForCell(cell)
        else {
            fatalError()
            }
        
        let alertController = UIAlertController(title: "刪除資料", message: "確認刪除資料？", preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
            return
        }
        let deleteAction = UIAlertAction(title: "刪除", style: UIAlertActionStyle.Default){ (result : UIAlertAction) -> Void in
            let deleteCat = self.OwnsCats[indexPath.row]
            let deletePostID = deleteCat.catID
            
            let rootRef = FIRDatabase.database().reference()
            rootRef.child("Cats").child(deletePostID).removeValue()
            
            //delete storage
            if deleteCat.selected == "image" {
                let storageRef = FIRStorage.storage().reference().child("Cats/\(deletePostID).jpg")
                
                storageRef.deleteWithCompletion { (error) -> Void in
                    if (error != nil) {
                        print("Delete image error")
                    } else {
                        self.personalOwnsTableView.reloadData()
                    }
                    
                }
            } else {
                let storageRef = FIRStorage.storage().reference().child("Cats/\(deletePostID).gif")
                
                storageRef.deleteWithCompletion { (error) -> Void in
                    if (error != nil) {
                        print("Delete Video error")
                    } else {
                        self.personalOwnsTableView.reloadData()
                    }
                }
            }
        }
        alertController.view.tintColor = UIColor.init(red: 138.0/255.0, green: 14.0/255.0, blue: 77.0/255.0, alpha: 1.0)
        alertController.addAction(okAction)
        alertController.addAction(deleteAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let segueIdentifier = segue.identifier else { fatalError() }
        
        if segueIdentifier == "OwnsToSingleCatView" {
            
            guard let destViewController = segue.destinationViewController as? SingleCatDetailViewController else
            {
                fatalError()
            }
            
            destViewController.cat = passCat
            destViewController.buttonHidden = true
            
            
        }
        
    }
    
}