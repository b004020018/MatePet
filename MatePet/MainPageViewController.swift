//
//  MainPageViewController.swift
//  MatePet
//
//  Created by RosalieRabbit on 2016/9/30.
//  Copyright © 2016年 RosalieRabbit. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class catcell: UICollectionViewCell {
    @IBOutlet weak var districtLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
}


struct cat {
    let owner: String!
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
            
            let owner = snapshot.value!["owner"] as! String
            let districtNumber = snapshot.value!["district"] as! Int
            let district = District(rawValue: districtNumber)!.title
            
            self.cats.insert(cat(owner: owner,district: district), atIndex: 0)
            self.catsCollectionView.reloadData()
        })
        self.catsCollectionView.reloadData()
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

            return cell
            
    }
    


}