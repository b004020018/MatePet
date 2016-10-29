//
//  ToAddViewController.swift
//  MatePet
//
//  Created by RosalieRabbit on 2016/10/21.
//  Copyright © 2016年 RosalieRabbit. All rights reserved.
//
import UIKit


class ToAddViewController: UIViewController {
    
    
    override func viewDidAppear(animated: Bool) {
    UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.redColor()], forState:.Normal)
        guard let vc = self.storyboard?.instantiateViewControllerWithIdentifier("AddNewDataView") as? AddNewDataViewController else {fatalError()}
        self.presentViewController(vc, animated: true, completion: nil)
    }
}
