//
//  ToAddViewController.swift
//  MatePet
//
//  Created by RosalieRabbit on 2016/10/21.
//  Copyright © 2016年 RosalieRabbit. All rights reserved.
//
import UIKit
import FirebaseAuth


class ToAddViewController: UIViewController {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidAppear(animated: Bool) {
        if appDelegate.isLogin == false {
            let alertController = UIAlertController(title: "使用者未登入", message: "要先登入才能刊登貓咪唷！", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                guard let vc = self.storyboard!.instantiateViewControllerWithIdentifier("FBLoginView") as?FBLoginViewController else {fatalError()}
                self.presentViewController(vc, animated: true, completion: nil)
            }
            alertController.view.tintColor = UIColor.init(red: 138.0/255.0, green: 14.0/255.0, blue: 77.0/255.0, alpha: 1.0)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        guard let vc = self.storyboard?.instantiateViewControllerWithIdentifier("AddNewDataView") as? AddNewDataViewController else {fatalError()}
        self.presentViewController(vc, animated: true, completion: nil)
    }
}
