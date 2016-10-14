//
//  SingleCatDetailViewController.swift
//  MatePet
//
//  Created by RosalieRabbit on 2016/10/14.
//  Copyright © 2016年 RosalieRabbit. All rights reserved.
//

import UIKit
import SafariServices

class SingleCatDetailViewController: UIViewController {
    
    var cat: Cat!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var catView: UIView!
    @IBOutlet weak var likesQuantity: UILabel!
    @IBOutlet weak var catAgeLabel: UILabel!
    @IBOutlet weak var catSexLabel: UILabel!
    @IBOutlet weak var catColourLabel: UILabel!
    @IBOutlet weak var catDistrictLabel: UILabel!
    @IBOutlet weak var catDescription: UILabel!
    
    @IBAction func ownerMessengerLinkButton(sender: UIButton) {
        let FBmessengerLink = "http://m.me/\(cat.userFacebookID)"
        
        let FBURL = NSURL(string: FBmessengerLink)!
        
        if UIApplication.sharedApplication().canOpenURL(FBURL) {
            
            UIApplication.sharedApplication().openURL(FBURL)
            
        } else {
            
            let safariVC = SFSafariViewController(URL: FBURL)
            
            presentViewController(safariVC, animated: true, completion: nil)
        }
        
    }
    
    
//    fb-messenger://user-thread/USER_ID
    
    override func viewDidLoad() {
        super.viewDidLoad()
        catAgeLabel.text = cat.age
        catColourLabel.text = cat.colour
        catSexLabel.text = cat.sex
        catDistrictLabel.text = cat.district
        catDescription.text = cat.description
        
        
    }

}
