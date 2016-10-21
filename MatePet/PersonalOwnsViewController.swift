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

class PersonalOwnsTableCell: UITableViewCell {
    
    @IBOutlet weak var catAge: UILabel!
    @IBOutlet weak var catSex: UILabel!
    @IBOutlet weak var catColour: UILabel!
    @IBOutlet weak var catDistrict: UILabel!
    @IBOutlet weak var catView: UIView!
    @IBOutlet weak var catImageView: UIImageView!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!

}


class PersonalOwnsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var personalOwnsTableView: UITableView!
    
    
    var receiveCats = [Cat]()
    var OwnsCats = [Cat]()
    var postsID = [String]()
    var passCat: Cat!
    
    override func viewWillAppear(animated: Bool) {
        self.receiveCats = LocalDataModel.shared.cats
        let user = (FIRAuth.auth()?.currentUser?.uid)!
        self.OwnsCats = []
        for catItem in self.receiveCats {
            if catItem.owner == user {
                self.OwnsCats.append(catItem)
            }
        }
        self.personalOwnsTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return OwnsCats.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.personalOwnsTableView.dequeueReusableCellWithIdentifier("personalOwnsTableCell",forIndexPath: indexPath) as! PersonalOwnsTableCell
        cell.catDistrict.text = OwnsCats[indexPath.row].district
        cell.catSex.text = OwnsCats[indexPath.row].sex
        cell.catColour.text = OwnsCats[indexPath.row].colour
        cell.catAge.text = OwnsCats[indexPath.row].age
//        cell.deleteButton
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
            }
        }else if OwnsCats[indexPath.row].selected == "video" {
            let storageRef = FIRStorage.storage().referenceWithPath("Cats/\(catID).mov")
            storageRef.downloadURLWithCompletion{ (url, error) -> Void in
                if error != nil {
                    print("error")
                } else {
                    let player = AVPlayer(URL: url!)
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = player
                    playerViewController.view.frame = cell.catView.frame
                    cell.catView.addSubview(playerViewController.view)
                    self.addChildViewController(playerViewController)
                    
                }
            }
        }
        
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        passCat = OwnsCats[indexPath.row]
        self.performSegueWithIdentifier("OwnsToSingleCatView", sender: self)
    }
    
    func deletePost(sender: UIButton!) {
        guard let cell = sender.superview?.superview as? PersonalOwnsTableCell else {
            fatalError()
        }
        let deleteCatPath = self.personalOwnsTableView.indexPathForCell(cell)!.row
        let deletePostID = OwnsCats[deleteCatPath].catID
        
        let rootRef = FIRDatabase.database().reference()
        rootRef.child("Cats").child(deletePostID).removeValue()
        self.personalOwnsTableView.reloadData()
        
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