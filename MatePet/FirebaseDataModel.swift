//
//  FirebaseDataModel.swift
//  MatePet
//
//  Created by RosalieRabbit on 2016/10/12.
//  Copyright © 2016年 RosalieRabbit. All rights reserved.
//

import UIKit
import Firebase

class FirebaseDataModel {
    static let database = FirebaseDataModel()
    
    var cats = [Cat]()
    weak var delegate : PassCatDataDelegate?
    func getCats() {
        let databaseRef = FIRDatabase.database().reference()
        databaseRef.child("Cats").queryOrderedByKey().observeEventType(.Value , withBlock: { snapshot in
            if snapshot.exists() {
                for item in [snapshot.value] {
                    // item = 第一隻貓
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
                        let catID = firebaseItemKey[index]
                        
                        let catOwner = item["owner"] as! String
                        
                        let catDistrictCode = item["district"] as! Int
                        let catDistrict = District(rawValue: catDistrictCode)!.title
                        
                        let catCreatedAtCode = item["created_at"] as! NSTimeInterval
                        let catCreatedAt = NSDate(timeIntervalSince1970: catCreatedAtCode/1000)
                        
                        let catSexCode = item["sex"] as! String
                        let catSex = Sexual(rawValue: catSexCode)!.title
                        
                        let catAgeCode = item["age"] as! String
                        let catAge = Age(rawValue: catAgeCode)!.title
                        
                        let catColour = item["colour"] as! String
                        
                        let catDescription = item["description"] as! String
                        
                        let catSelected = item["selected"] as! String
                        
                        self.cats.append(Cat(catID: catID, owner: catOwner, district: catDistrict, catCreatedAt:catCreatedAt, sex: catSex, age: catAge, colour: catColour, description: catDescription, selected: catSelected))
                        self.delegate?.acceptCatData(self.cats)
                        
                    }
                }
            }
        })
        
    }


}