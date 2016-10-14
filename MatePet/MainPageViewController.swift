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

class Catcell: UICollectionViewCell {
    @IBOutlet weak var districtLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var catView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
}

protocol PassCatDataDelegate: class {
    func acceptCatData(cats: [Cat])
}

class MainPageViewController: UICollectionViewController, PassCatDataDelegate {
    
    @IBOutlet weak var catsCollectionView: UICollectionView!
    
    var mainCats = [Cat]()
    var passCat:Cat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = FirebaseDataModel.database
        vc.delegate = self
        vc.getCats()
    }
    
    func acceptCatData(cats: [Cat]){
        mainCats = cats
        self.catsCollectionView.reloadData()
    }


    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainCats.count
    }


    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath)
        -> UICollectionViewCell {


            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! Catcell
            cell.districtLabel.text = mainCats[indexPath.row].district
            cell.sexLabel.text = mainCats[indexPath.row].sex
            let catID = mainCats[indexPath.row].catID
            if mainCats[indexPath.row].selected == "image" {
                let storageRef = FIRStorage.storage().referenceWithPath("Cats/\(catID).jpg")
                storageRef.downloadURLWithCompletion { (url, error) -> Void in
                    if (error != nil) {
                        print("error")
                    } else {
                        cell.imageView.hnk_setImageFromURL(url!)
                    }
                }
            }else if mainCats[indexPath.row].selected == "video" {
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
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        passCat = mainCats[indexPath.row]
        self.performSegueWithIdentifier("ToSingleCatView", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let segueIdentifier = segue.identifier else { fatalError() }
        
        switch segueIdentifier {
            
            case "ToSearchView":
            
            guard let destViewController = segue.destinationViewController as? QueryViewController else
            {
                fatalError()
            }
            destViewController.receiveCats = mainCats
            
            case "ToSingleCatView":
            
                guard let destViewController = segue.destinationViewController as? SingleCatDetailViewController else
                {
                    fatalError()
                }
            
                destViewController.cat = passCat

            default: break
        }
    
    }
    



}