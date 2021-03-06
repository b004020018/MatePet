//
//  LocalDataModel.swift
//  MatePet
//
//  Created by RosalieRabbit on 2016/10/17.
//  Copyright © 2016年 RosalieRabbit. All rights reserved.
//

import UIKit


class  LocalDataModel: PassCatDataDelegate {
    
    static let shared = LocalDataModel()
    
    weak var delegate: CatManagerDelegate?
    weak var ownsdelegate: OwnsManagerDelegate?

    
     var cats: [Cat] = [] { didSet{ print("Array reload") }}
    
    
    func acceptCatData(cats: [Cat]){
        self.delegate?.manager(self, didGetCats: cats)
        self.ownsdelegate?.manager(self, didGetCats: cats)
        self.cats = cats
    }
    
    func fetchCats() {
        let firebaseDataModel = FirebaseDataModel()
        firebaseDataModel.delegate = self
        firebaseDataModel.getCats()
    }
    
    

}
