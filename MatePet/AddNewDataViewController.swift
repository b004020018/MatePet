//
//  ViewController.swift
//  MatePet
//
//  Created by RosalieRabbit on 2016/9/26.
//  Copyright © 2016年 RosalieRabbit. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth


class AddNewDataViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var addDataTextView: UITextView!
    @IBAction func saveNewDataButton(sender: UIButton) {
        
        
        let cat: [String : AnyObject] = [
        "owner" : (FIRAuth.auth()?.currentUser?.uid)!,
        "vedio" : "12",
        "district" : selectedDataDetail.district,
        "created_at" : FIRServerValue.timestamp(),
        "sex" : selectedDataDetail.sex,
        "age" : selectedDataDetail.age,
        "colour" : selectedDataDetail.colour,
        "description" : selectedDataDetail.description]
        let rootRef = FIRDatabase.database().reference()
        rootRef.child("Cats").childByAutoId().setValue(cat)
        
        
        
//        let storage = FIRStorage.storage()
//        let storageRef = storage.referenceForURL("gs://matepet-eb8e1.appspot.com")
        
    }
    
    
    enum DataPickerType: Int {
        case sexual = 0
        case age = 1
        case colour = 2
        case district = 3
    }
    
    let sexualPicker : [Sexual] = [ .male, .female, .unknown ]
    let agePicker : [Age] = [.child, .adult ]
    let colourPicker : [Colour] = [.white, .black, .brown, .yellow, .tabby, .mix, .other]
    let districtPicker: [District] = [.tw_tpe, .tw_nwt, .tw_kee, .tw_ila, .tw_tao, .tw_hsq, .tw_hsz, .tw_mia, .tw_txg, .tw_cha, .tw_nan, .tw_yun, .tw_cyq, .tw_cyi, .tw_tnn, .tw_khh, .tw_pif, .tw_hua, .tw_ttt, .tw_pen, .tw_kin, .tw_lie]
    
    
    
    
    
    struct SelectedDataDetail {
        var sex: String!
        var age: String!
        var colour: String!
        var district: Int!
        var description: String!
    }
    var selectedDataDetail = SelectedDataDetail()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        selectedDataDetail.description = addDataTextView.text
       
        
    
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        let pickerType = DataPickerType(rawValue: component)!
        
        switch pickerType {
        case .sexual : return sexualPicker.count
        case .age : return agePicker.count
        case .colour : return colourPicker.count
        case .district : return districtPicker.count
        
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let pickerType = DataPickerType(rawValue: component)!
        switch pickerType {
        case .sexual:
            let sex = sexualPicker[row]
            return sex.title
            
        case .age :
            let age = agePicker[row]
            return age.title
            
        case .colour :
            let colour = colourPicker[row]
            return colour.rawValue
        
        case .district :
            let district = districtPicker[row]
            return district.title
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let pickerType = DataPickerType(rawValue: component)!
        switch pickerType {
        case .sexual :
            let sex = sexualPicker[row]
            selectedDataDetail.sex = sex.rawValue // server
            
        case .age :
            let age = agePicker[row]
            selectedDataDetail.age = age.rawValue
        
        case .colour :
            let colour = colourPicker[row]
            selectedDataDetail.colour = colour.rawValue
        
        case .district :
            let district = districtPicker[row]
            selectedDataDetail.district = district.rawValue
            
        }
    }
    

}

