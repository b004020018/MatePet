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
import SwiftGifOrigin

class Catcell: UICollectionViewCell {
    @IBOutlet weak var districtLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var catView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var imageIndicator: UIActivityIndicatorView!
    
}

protocol CatManagerDelegate: class {
    
    func manager(manager: LocalDataModel, didGetCats cats: [Cat])
    
}

class MainPageViewController: UICollectionViewController, CatManagerDelegate {
    
    @IBOutlet weak var catsCollectionView: UICollectionView!
    

    
    var mainCats = [Cat]()
    var passCat: Cat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = LocalDataModel.shared
        vc.delegate = self
        vc.fetchCats()
    }
    
    func manager(manager: LocalDataModel, didGetCats cats: [Cat]){
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
            cell.imageIndicator.startAnimating()
            cell.districtLabel.text = mainCats[indexPath.row].district
            cell.sexLabel.text = mainCats[indexPath.row].sex
            cell.likesCountLabel.text = String(mainCats[indexPath.row].likesCount)
            let catID = mainCats[indexPath.row].catID
            if mainCats[indexPath.row].selected == "image" {
                let storageRef = FIRStorage.storage().referenceWithPath("Cats/\(catID).jpg")
                storageRef.downloadURLWithCompletion { (url, error) -> Void in
                    if (error != nil) {
                        print("error")
                    } else {
                        cell.imageView.hnk_setImageFromURL(url!)
                    }
                cell.imageIndicator.stopAnimating()
                }
            }else if mainCats[indexPath.row].selected == "video" {
                let storageRef = FIRStorage.storage().referenceWithPath("Cats/\(catID).gif")
                storageRef.downloadURLWithCompletion{ (url, error) -> Void in
                    if error != nil {
                        print("error")
                    } else {
                        guard let gifUrl = url else {
                        print("can't get gif url from firebase")
                        return
                        }
                        dispatch_async(dispatch_get_main_queue(),{
                            cell.imageView.image = UIImage.gifWithURL("\(gifUrl)")
                        })
                    }
                cell.imageIndicator.stopAnimating()
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
        case "ToSingleCatView":
            guard let destViewController = segue.destinationViewController as? SingleCatDetailViewController else
            {
                fatalError()
            }
            
            destViewController.cat = passCat
            destViewController.buttonHidden = true

        case "ToSearchView":
            
                guard let destViewController = segue.destinationViewController as? QueryViewController else
                {
                    fatalError()
                }
            
                destViewController.receiveCats = mainCats
            
        default:break
        }
    
    }
    



}