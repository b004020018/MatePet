//
//  LocalDataModel.swift
//  MatePet
//
//  Created by RosalieRabbit on 2016/10/17.
//  Copyright © 2016年 RosalieRabbit. All rights reserved.
//

import UIKit

protocol PassCatDataDelegate: class {
    func acceptCatData(cats: [Cat])
}

class  LocalDataModel: PassCatDataDelegate {
    
    static let shared = LocalDataModel()
    
    weak var delegate: CatManagerDelegate?

    
     var cats: [Cat] = []
    
    
    func acceptCatData(cats: [Cat]){
        self.delegate?.manager(self, didGetCats: cats)
        self.cats = cats
    }
    
    func fetchCats() {
        FirebaseDataModel.database.delegate = self
        FirebaseDataModel.database.getCats()
    }
    
    

}
