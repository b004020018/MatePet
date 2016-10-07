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
        var district: Int!
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
            filterParameters.age = "CHILD"
        case .adult:
            filterParameters.age = "ADULT"
        }
    }
    
    @IBOutlet weak var sexSegment: UISegmentedControl!
    @IBAction func sexSegmentControl(sender: UISegmentedControl) {
        let sexEnum = SexEnum(rawValue: ageSegment.selectedSegmentIndex)!
        switch sexEnum {
        case .male:
            filterParameters.sex = "M"
        case .female:
            filterParameters.sex = "F"
        case .unknow:
            filterParameters.sex = "U"
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
        
        let colourPickerView = UIPickerView()
        let districtPickerView = UIPickerView()
        colourPickerView.backgroundColor = UIColor.whiteColor()
        districtPickerView.backgroundColor = UIColor.whiteColor()
        colourPickerView.showsSelectionIndicator = true
       
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor.darkTextColor()
        toolBar.sizeToFit()
        
        
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(self.done))
    
        
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
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            let colour = colourPicker[row]
            return colour.rawValue
        } else if pickerView.tag == 1 {
            let district = districtPicker[row]
            return district.title
        }
        return ""
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            let colour = colourPicker[row]
            colourTextField.text = colour.rawValue
            filterParameters.colour = colour.rawValue
        } else if pickerView.tag == 1 {
            let district = districtPicker[row]
            districtTextField.text = district.title
            filterParameters.district = district.rawValue
        }
    }


}