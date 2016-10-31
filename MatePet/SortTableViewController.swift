//
//  SortTableViewController.swift
//  MatePet
//
//  Created by RosalieRabbit on 2016/10/7.
//  Copyright © 2016年 RosalieRabbit. All rights reserved.
//

import UIKit

class sortCell:UITableViewCell {
    @IBOutlet weak var sortLabel: UILabel!
}

class SortTableViewController: UITableViewController {
    
    let sortArray = ["時間前至後", "時間後至前", "Likes 多到少", "Likes 少到多"]
    weak var delegate : PassSortDataDelegate?
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier( "sortCell", forIndexPath: indexPath) as! sortCell
        cell.sortLabel.text = sortArray[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.acceptSortData(indexPath.row)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}