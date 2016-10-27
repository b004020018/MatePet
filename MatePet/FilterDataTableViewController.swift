//
//  FilterDataTableViewController.swift
//  MatePet
//
//  Created by RosalieRabbit on 2016/10/6.
//  Copyright © 2016年 RosalieRabbit. All rights reserved.
//

import UIKit


class FilterDataTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    struct FilterParameters {
        var age: String!
        var sex: String!
        var colour: String!
        var district: String!
    }
 
    enum AgeEnum: Int {
        case child = 0
        case adult = 1
    
    }
    
    enum SexEnum: Int {
        case male = 0
        case female = 1
        case unknow = 2
    }
    
    var filterParameters = FilterParameters()
    
    @IBOutlet weak var colourTextField: UITextField!
    @IBOutlet weak var districtTextField: UITextField!
    
    @IBOutlet weak var ageSegment: UISegmentedControl!

    @IBAction func ageSegmentControl(sender: UISegmentedControl) {
        let ageEnum = AgeEnum(rawValue: ageSegment.selectedSegmentIndex)!
        switch ageEnum {
        case .child:
            filterParameters.age = "幼年"
        case .adult:
            filterParameters.age = "成年"
        }
    }
    
    @IBOutlet weak var sexSegment: UISegmentedControl!
    @IBAction func sexSegmentControl(sender: UISegmentedControl) {
        let sexEnum = SexEnum(rawValue: ageSegment.selectedSegmentIndex)!
        switch sexEnum {
        case .male:
            filterParameters.sex = "公"
        case .female:
            filterParameters.sex = "母"
        case .unknow:
            filterParameters.sex = "未知"
        }
        
    }
 
    

    enum DataPickerType: Int {
        case colour = 0
        case district = 1
    }
    
    let colourPicker : [Colour] = [.white, .black, .brown, .yellow, .tabby, .mix, .other]
    let districtPicker: [District] = [.tw_tpe, .tw_nwt, .tw_kee, .tw_ila, .tw_tao, .tw_hsq, .tw_hsz, .tw_mia, .tw_txg, .tw_cha, .tw_nan, .tw_yun, .tw_cyq, .tw_cyi, .tw_tnn, .tw_khh, .tw_pif, .tw_hua, .tw_ttt, .tw_pen, .tw_kin, .tw_lie]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0)
        
        //TASK: setting segment font
        ageSegment.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir-Black", size: 14.0)! ], forState: .Normal)
        sexSegment.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir-Black", size: 16.0)! ], forState: .Normal)
        
        //TASK: setting pickerView
        let colourPickerView = UIPickerView()
        let districtPickerView = UIPickerView()
        colourPickerView.backgroundColor = UIColor.whiteColor()
        districtPickerView.backgroundColor = UIColor.whiteColor()
        colourPickerView.showsSelectionIndicator = true
       
        let toolBar = UIToolbar()
        toolBar.barTintColor = UIColor.init(red: 138.0/255.0, green: 14.0/255.0, blue: 77.0/255.0, alpha: 1.0)
        toolBar.translucent = false
        toolBar.tintColor = UIColor.whiteColor()
        toolBar.sizeToFit()
        
        
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(self.done))
        doneButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Avenir-Black", size: 16.0)!], forState: UIControlState.Normal)
    
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        

        colourTextField.inputAccessoryView = toolBar
        districtTextField.inputAccessoryView = toolBar
        
        
        colourPickerView.delegate = self
        districtPickerView.delegate = self
       
        colourTextField.inputView = colourPickerView
        districtTextField.inputView = districtPickerView
        
        //choose which pickerview is used
        colourPickerView.tag = 0
        districtPickerView.tag = 1

    }
    
    
    func done() {
        colourTextField.endEditing(true)
        districtTextField.endEditing(true)
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return colourPicker.count
        } else if pickerView.tag == 1 {
            return districtPicker.count
        }
        return 1
    }
    
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.init(red: 100.0/255.0, green: 109.0/255.0, blue: 120.0/255.0, alpha: 1.0)
        pickerLabel.font = UIFont(name: "Avenir-Black", size: 18)
        pickerLabel.textAlignment = NSTextAlignment.Center
        
        if pickerView.tag == 0 {
            let colour = colourPicker[row]
            pickerLabel.text = colour.rawValue
        } else if pickerView.tag == 1 {
            let district = districtPicker[row]
            pickerLabel.text = district.title
        }
        
        return pickerLabel
    }

    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            let colour = colourPicker[row]
            colourTextField.text = colour.rawValue
            filterParameters.colour = colour.rawValue
        } else if pickerView.tag == 1 {
            let district = districtPicker[row]
            districtTextField.text = district.title
            filterParameters.district = district.title
        }
    }


}