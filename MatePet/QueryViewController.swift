//
//  QueryViewController.swift
//  MatePet
//
//  Created by RosalieRabbit on 2016/10/7.
//  Copyright © 2016年 RosalieRabbit. All rights reserved.
//

import UIKit
import Firebase
import MediaPlayer
import AVKit
import SwiftGifOrigin

class FilterCell: UICollectionViewCell {
    @IBOutlet weak var districtLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var catView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var imageIndicator: UIActivityIndicatorView!
    
}

protocol PassFileterDataDelegate: class {
    func acceptData(age: String, sex: String, colour: String, district: String)
}

protocol PassSortDataDelegate: class {
    func acceptSortData(order: Int)
}

class QueryViewController: UIViewController, UIPopoverPresentationControllerDelegate, PassSortDataDelegate, PassFileterDataDelegate{

    @IBOutlet weak var searchColloectionView: UICollectionView!
    // present popover View
    @IBAction func sortButton(sender: UIButton) {
        let popoverContent = self.storyboard!.instantiateViewControllerWithIdentifier("SortTableView") as! SortTableViewController
        popoverContent.delegate = self
        
        popoverContent.modalPresentationStyle = .Popover
        
        if let popover = popoverContent.popoverPresentationController {
            let viewForSource = sender as UIButton
            popover.sourceView = viewForSource
            popover.sourceRect = viewForSource.bounds
            
            // the size you want to display
            popoverContent.preferredContentSize = CGSizeMake(160,180)
            popover.delegate = self
        }
        self.presentViewController(popoverContent, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    
    var receiveCats = [Cat]()
    var searchCats = [Cat]()
    var passCat: Cat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchCats = receiveCats
        self.searchColloectionView.reloadData()
        }
    
    func acceptLikesCount(catID: String, likesCount: Int) {
        for (index,cat) in searchCats.enumerate() {
            if cat.catID == catID {
                searchCats[index].likesCount = likesCount
            }
        }
        self.searchColloectionView.reloadData()
    }
    
    
    func acceptData(age: String, sex: String, colour: String, district: String){
        searchCats = []
        for cat in receiveCats {
            if cat.age == age && cat.sex == sex && cat.colour == colour && cat.district == district {
            searchCats.append(cat)
            }
        }
        dispatch_async(dispatch_get_main_queue(),{
            self.searchColloectionView.reloadData()
        })
    }
    
    enum SortType: Int {
    case fromNew = 0
    case fromBack = 1
    case fromMostLike = 2
    case fromLeastLike = 3
    
    }
    
    
    func acceptSortData(order: Int) {
        let sortEnum = SortType(rawValue: order)!
        switch sortEnum {
        case .fromNew:
            let result = searchCats.sort({$0.catCreatedAt < $1.catCreatedAt})
            searchCats = result
            dispatch_async(dispatch_get_main_queue(),{
                self.searchColloectionView.reloadData()
            })
        case .fromBack:
            let result = searchCats.sort({$0.catCreatedAt > $1.catCreatedAt})
            searchCats = result
            dispatch_async(dispatch_get_main_queue(),{
                self.searchColloectionView.reloadData()
            })
        case .fromMostLike:
            let result = searchCats.sort({ $0.likesCount > $1.likesCount })
            searchCats = result
            dispatch_async(dispatch_get_main_queue(),{
                self.searchColloectionView.reloadData()
            })
        case .fromLeastLike:
            let result = searchCats.sort({ $0.likesCount < $1.likesCount })
            searchCats = result
            dispatch_async(dispatch_get_main_queue(),{
                self.searchColloectionView.reloadData()
            })
        }
    }
    
    
     func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    
     func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchCats.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let cellWidth = (self.view.frame.width-30)/2
        let cellHeight = cellWidth + 60
        return CGSize(width:cellWidth, height: cellHeight)
    }    
    
     func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath)
        -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FilterCell", forIndexPath: indexPath) as! FilterCell
            cell.imageIndicator.startAnimating()
            cell.districtLabel.text = searchCats[indexPath.row].district
            cell.sexLabel.text = searchCats[indexPath.row].sex
            cell.likesCountLabel.text = String(searchCats[indexPath.row].likesCount)
            let catID = searchCats[indexPath.row].catID
            if searchCats[indexPath.row].selected == "image" {
                let storageRef = FIRStorage.storage().referenceWithPath("Cats/\(catID).jpg")
                storageRef.downloadURLWithCompletion { (url, error) -> Void in
                    if (error != nil) {
                        print("error")
                    } else {
                        cell.imageView.hnk_setImageFromURL(url!)
                    }
                cell.imageIndicator.stopAnimating()
                }
            }else if searchCats[indexPath.row].selected == "video" {
                let storageRef = FIRStorage.storage().referenceWithPath("Cats/\(catID).gif")
                storageRef.downloadURLWithCompletion{ (url, error) -> Void in
                    if error != nil {
                        print("error")
                    } else {
                        guard let gifUrl = url else {
                            print("can't get gif url from firebase")
                            return
                        }
                        cell.imageView.image = UIImage.gifWithURL("\(gifUrl)")
                    }
                cell.imageIndicator.stopAnimating()
                }
            }
            
            
            return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        passCat = searchCats[indexPath.row]
        self.performSegueWithIdentifier("SearchToSingleCatView", sender: self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let segueIdentifier = segue.identifier else { fatalError() }
        
        switch segueIdentifier {
            case "ToFilterMainView":
            guard let destViewController = segue.destinationViewController as? FilterMainViewController else
            {
                fatalError()
            }
            destViewController.delegate = self
            
            case "SearchToSingleCatView":
            
            guard let destViewController = segue.destinationViewController as? SingleCatDetailViewController else
            {
                fatalError()
            }
            
            destViewController.cat = passCat
            destViewController.buttonHidden = true
            
            default: break
            
        }
        
    }
    
}

public func <(a: NSDate, b: NSDate) -> Bool {
    return a.compare(b) == NSComparisonResult.OrderedAscending
}

public func >(a: NSDate, b: NSDate) -> Bool {
    return a.compare(b) == NSComparisonResult.OrderedDescending
}

extension NSDate: Comparable { }



