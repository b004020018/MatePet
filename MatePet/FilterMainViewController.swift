//
//  FilterMainViewController.swift
//  MatePet
//
//  Created by RosalieRabbit on 2016/10/7.
//  Copyright © 2016年 RosalieRabbit. All rights reserved.
//

import UIKit

class FilterMainViewController: UIViewController {
    
    weak var delegate : PassFileterDataDelegate?
    
    
    @IBAction func closeButton(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func DoneButton(sender: UIButton) {
        let filterData = childVC.filterParameters
        self.delegate?.acceptData(filterData.age, sex: filterData.sex, colour: filterData.colour, district: filterData.district)
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    
    var childVC: FilterDataTableViewController!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ToFilterTableView"{
            
            guard let destViewController = segue.destinationViewController as? FilterDataTableViewController else
            {
                fatalError()
            }
            
            childVC = destViewController
            
        }
        
    }
    

}