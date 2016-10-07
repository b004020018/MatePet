//
//  QueryViewController.swift
//  MatePet
//
//  Created by RosalieRabbit on 2016/10/7.
//  Copyright © 2016年 RosalieRabbit. All rights reserved.
//

import UIKit

protocol PassFileterDataDelegate {
    func acceptData(age: String, sex: String, colour: String, district: Int)
}

class QueryViewController: UIViewController, PassFileterDataDelegate {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ToFilterMainView"{
            
            guard let destViewController = segue.destinationViewController as? FilterMainViewController else
            {
                fatalError()
            }
            destViewController.delegate = self
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func acceptData(age: String, sex: String, colour: String, district: Int){
        
    print(age)
    print(sex)
    print(colour)
    print(district)
    
    }
    
//     func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    
//    
//     func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 5
//    }
//    
//    
//     func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath)
//        -> UICollectionViewCell {
//            
//            
//            
//            return cell }
//    
}
    


