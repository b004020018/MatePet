//
//  PersonalViewController.swift
//  MatePet
//
//  Created by RosalieRabbit on 2016/10/17.
//  Copyright © 2016年 RosalieRabbit. All rights reserved.
//

import UIKit

class  PersonalViewController: UIViewController {

    @IBOutlet weak var personalLikesView: UIView!
    @IBOutlet weak var personalOwnedView: UIView!

    
    @IBAction func personalViewSegmentedControl(sender: UISegmentedControl) {
        let isTableSelected = (sender.selectedSegmentIndex == 0)
        personalLikesView.hidden = !isTableSelected
        personalOwnedView.hidden = isTableSelected
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        personalLikesView.hidden = false
        personalOwnedView.hidden = true
    }

}
