//
//  ShakeRandomViewController.swift
//  MatePet
//
//  Created by RosalieRabbit on 2016/10/19.
//  Copyright © 2016年 RosalieRabbit. All rights reserved.
//

import UIKit

class ShakeRandomViewController: UIViewController {
    
    var receiveCats = [Cat]()
    var randomNumber = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.receiveCats = LocalDataModel.shared.cats
        let totalPosts = receiveCats.count
        randomNumber = Int(arc4random_uniform(UInt32(totalPosts) - 1)) + 1
        
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    override func  motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            guard let vc = self.storyboard?.instantiateViewControllerWithIdentifier("SingleCatDetailView") as? SingleCatDetailViewController else {fatalError()}
            vc.cat = receiveCats[randomNumber]
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    
}
