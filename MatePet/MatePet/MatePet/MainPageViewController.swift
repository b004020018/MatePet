//
//  MainPageViewController.swift
//  MatePet
//
//  Created by RosalieRabbit on 2016/9/30.
//  Copyright © 2016年 RosalieRabbit. All rights reserved.
//

import UIKit

import Firebase
import Haneke
import MediaPlayer
import AVKit

class catcell: UICollectionViewCell {
    @IBOutlet weak var districtLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var catView: UIView!
    @IBOutlet weak var imageVIew: UIImageView!
    
}


struct cat {
    let catID: String!
    let owner: String!
    let selected : String!
    let district: String!
}

class MainPageViewController: UICollectionViewController{
   
    @IBOutlet weak var catsCollectionView: UICollectionView!
    
    var cats = [cat]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let databaseRef = FIRDatabase.database().reference()
        databaseRef.child("Cats").queryOrderedByKey().observeEventType(.ChildAdded , withBlock: {
            snapshot in
            let catID = snapshot.key
            let owner = snapshot.value!["owner"] as! String
            let selected = snapshot.value!["selected"] as! String
            let districtNumber = snapshot.value!["district"] as! Int
            let district = District(rawValue: districtNumber)!.title
            
            self.cats.insert(cat(catID: catID, owner: owner, selected: selected, district: district), atIndex: 0)
            self.catsCollectionView.reloadData()
        })
        
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cats.count
    }

    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath)
        -> UICollectionViewCell {
            
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! catcell
            cell.districtLabel.text = cats[indexPath.row].district
            cell.ownerLabel.text = cats[indexPath.row].owner
            let catID = cats[indexPath.row].catID
            if cats[indexPath.row].selected == "image" {
                let storageRef = FIRStorage.storage().referenceWithPath("Cats/\(catID).jpg")
                storageRef.downloadURLWithCompletion { (url, error) -> Void in
                    if (error != nil) {
                        print("error")
                    } else {
                        cell.imageVIew.hnk_setImageFromURL(url!)
                    }
                }
            }else if cats[indexPath.row].selected == "video" {
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
    


}