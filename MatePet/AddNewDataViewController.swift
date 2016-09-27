//
//  ViewController.swift
//  MatePet
//
//  Created by RosalieRabbit on 2016/9/26.
//  Copyright © 2016年 RosalieRabbit. All rights reserved.
//

import UIKit

class AddNewDataViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var addDataTextView: UITextView!
    @IBAction func saveNewDataButton(sender: UIButton) {
    }
    
    
//    enum DataPickerType: Int {
//        case sexual = 0
//        case age = 1
//        case color = 2
//    }
    
    let sexualPicker = ["公", "母", "未知"]
    let agePicker = ["幼年", "成年"]
    let colorPicker = ["白色", "黑色", "棕色", "黃色", "虎斑", "花色", "其他"]
    
    
    struct SelectedDataDetail {
        var sex = ""
        var age = ""
        var color = ""
    }
    var selectedDataDetail = SelectedDataDetail()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0 : return sexualPicker.count
        case 1 : return agePicker.count
        default : return colorPicker.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component{
        case 0 : return sexualPicker[row]
        case 1 : return agePicker[row]
        default : return colorPicker[row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        var selectedDataDetail = SelectedDataDetail()
        switch component{
        case 0 : selectedDataDetail.sex = sexualPicker[row]
        case 1 : selectedDataDetail.age = agePicker[row]
        default : selectedDataDetail.color = colorPicker[row]
        }
        print(selectedDataDetail)
    }

 

}

