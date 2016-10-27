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
    
    
    @IBOutlet weak var closeButton: UIButton!
    @IBAction func closeButton(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBOutlet weak var DoneButton: UIButton!
    @IBAction func DoneButton(sender: UIButton) {
        let filterData = childVC.filterParameters
        guard let filterDataAge = filterData.age,
              let filterDataSex = filterData.sex,
              let filterDataColour = filterData.colour,
              let filterDataDistrict = filterData.district else {
                let alertController = UIAlertController(title: "選取未完成", message: "把選取資料完成\n更容易找到適合你的貓咪唷！", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                    return
                }
                alertController.view.tintColor = UIColor.init(red: 138.0/255.0, green: 14.0/255.0, blue: 77.0/255.0, alpha: 1.0)
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
                return
        }
        
        
        
        self.delegate?.acceptData(filterDataAge, sex: filterDataSex, colour: filterDataColour, district: filterDataDistrict)
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.DoneButton.layer.cornerRadius = 5
        self.closeButton.layer.cornerRadius = 0.5 * closeButton.bounds.size.width
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