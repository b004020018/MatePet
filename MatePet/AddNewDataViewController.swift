//
//  ViewController.swift
//  MatePet
//
//  Created by RosalieRabbit on 2016/9/26.
//  Copyright © 2016年 RosalieRabbit. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices
import MediaPlayer
import AVKit
import Fusuma
import CoreText
import NotificationCenter
import Regift
import SwiftGifOrigin


class AddNewDataViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, FusumaDelegate, UITextViewDelegate {

    var imagedata: NSData?
    var localGifPath: NSURL?
    var selected: String!
    
    @IBOutlet weak var dataUpdateProgressView: UIProgressView!
    @IBOutlet weak var addVideoView: UIView!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var addDataTextView: UITextView!
    @IBOutlet weak var closeButton: UIButton!
    //TASK: close AddNewDataViewController
    @IBAction func closeButton(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
        let parent = self.presentingViewController as? UITabBarController
        parent?.selectedIndex = 0
    }
    
    @IBOutlet weak var saveNewDataButton: UIButton!
    @IBAction func saveNewDataButton(sender: UIButton) {
        selectedDataDetail.description = addDataTextView.text
        
        guard let selectedDataDetailSex = selectedDataDetail.sex,
              let selectedDataDetailAge = selectedDataDetail.age,
              let selectedDataDetailColour = selectedDataDetail.colour,
              let selectedDataDetailDistrict = selectedDataDetail.district,
              let selectedDataDetailDescription = selectedDataDetail.description
        else{
            let alertController = UIAlertController(title: "資料未完成", message: "把選取資料完成更容易把貓咪送養唷！", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                return
            }
            alertController.view.tintColor = UIColor.init(red: 138.0/255.0, green: 14.0/255.0, blue: 77.0/255.0, alpha: 1.0)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        FIRAnalytics.logEventWithName("add_new_cat", parameters: nil)
        self.dataUpdateProgressView.hidden = false
        let facebookData = NSUserDefaults.standardUserDefaults()
        guard let userFacebookID = facebookData.stringForKey("userFacebookID") else {
        print("can't get userFacebookID")
        return
        }
        //TASK: store in database
        let cat: [String : AnyObject] = [
        "owner" : (FIRAuth.auth()?.currentUser?.uid)!,
        "district" : selectedDataDetailDistrict,
        "created_at" : FIRServerValue.timestamp(),
        "sex" : selectedDataDetailSex,
        "age" : selectedDataDetailAge,
        "colour" : selectedDataDetailColour,
        "description" : selectedDataDetailDescription,
        "selected" : selected,
        "userFacebookID": userFacebookID,
        "likesCount": 0 ]
        let rootRef = FIRDatabase.database().reference()
        let autoID = rootRef.child("Cats").childByAutoId().key
        rootRef.child("Cats").child(autoID).setValue(cat)
        
        //TASK: store in storage
        
        if let localGifPath = localGifPath {
            let storageRef = FIRStorage.storage().reference().child("Cats/\(autoID).gif")
            let uploadMetadata = FIRStorageMetadata()
            uploadMetadata.contentType = "image/gif"
            let uploadTask = storageRef.putFile(localGifPath, metadata: uploadMetadata) { (metadata, error) in
                if (error != nil) {
                    print("upload gif Got error")
                } else {
                    self.dismissViewControllerAnimated(true, completion: nil)
                    let parent = self.presentingViewController as? UITabBarController
                    parent?.selectedIndex = 0
                }
            }
            uploadTask.observeStatus(.Progress){(snapshop) in
                guard let progress = snapshop.progress else {
                    print("prgress bar error")
                    return
                }
            self.dataUpdateProgressView.progress = Float(progress.fractionCompleted)
            }
            
        } else if let imagedata = imagedata {
            let storageRef = FIRStorage.storage().reference().child("Cats/\(autoID).jpg")
            let uploadMetadata = FIRStorageMetadata()
            uploadMetadata.contentType = "image/jpeg"
            let uploadTask = storageRef.putData(imagedata, metadata: uploadMetadata) { (metadata, error) in
                if (error != nil) {
                    print("upload image Got error")
                } else {
                    self.dismissViewControllerAnimated(true, completion: nil)
                    let parent = self.presentingViewController as? UITabBarController
                    parent?.selectedIndex = 0
                }
            }
            uploadTask.observeStatus(.Progress){(snapshop) in
                guard let progress = snapshop.progress else {
                    print("prgress bar error")
                    return
                }
            self.dataUpdateProgressView.progress = Float(progress.fractionCompleted)
            }
        }
    }
    
    func addImageVideoViewTapped(sender: AnyObject)
    {
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        fusuma.hasVideo = true // If you want to let the users allow to use video.
        self.presentViewController(fusuma, animated: true, completion: nil)
    
    }
    
    func fusumaImageSelected(image: UIImage) {
        selected = "image"
        self.selectedImageView.image = image
        imagedata = UIImagePNGRepresentation(image)
        print("Image selected")
    }
    
    // Return the image but called after is dismissed.
    func fusumaDismissedWithImage(image: UIImage) {
        print("Called just after FusumaViewController is dismissed.")
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: NSURL) {
        selected = "video"
        print("Called just after a video has been selected.")
        let videoURL   = fileURL
        let frameCount = 20
        let delayTime  = Float(0.2)
        
        Regift.createGIFFromSource(videoURL, frameCount: frameCount, delayTime: delayTime) { (result) in
            guard let  localGifPath = result else {
                print("didn't get gif")
                return
            }
            print("Gif saved to \(localGifPath)")
            let gifNSData = NSData(contentsOfURL: localGifPath)
            self.selectedImageView.image = UIImage.gifWithData(gifNSData!)
            self.localGifPath = localGifPath
        }
    }
    
    // When camera roll is not authorized, this method is called.
    func fusumaCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
    }
    
    
    
    enum DataPickerType: Int {
        case sexual = 0
        case age = 1
        case colour = 2
        case district = 3
    }
    
    struct SelectedDataDetail {
        var sex: String?
        var age: String?
        var colour: String?
        var district: Int?
        var description: String?
    }
    
    
    
    var selectedDataDetail = SelectedDataDetail()
    
    let sexualPicker : [Sexual] = [ .male, .female, .unknown ]
    let agePicker : [Age] = [.child, .adult ]
    let colourPicker : [Colour] = [.white, .black, .brown, .yellow, .tabby, .mix, .other]
    let districtPicker: [District] = [.tw_tpe, .tw_nwt, .tw_kee, .tw_ila, .tw_tao, .tw_hsq, .tw_hsz, .tw_mia, .tw_txg, .tw_cha, .tw_nan, .tw_yun, .tw_cyq, .tw_cyi, .tw_tnn, .tw_khh, .tw_pif, .tw_hua, .tw_ttt, .tw_pen, .tw_kin, .tw_lie]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting save button
        self.saveNewDataButton.layer.cornerRadius = 5
        self.closeButton.layer.cornerRadius = 0.5 * closeButton.bounds.size.width
        
        //setting keyboard observe and disappear
        setUpKeyboardObserver()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        self.descriptionTextView.delegate = self
        
        //setting updateprogress and picker view
        self.dataUpdateProgressView.hidden = true
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(AddNewDataViewController.addImageVideoViewTapped(_:)))
        addVideoView.userInteractionEnabled = true
        addVideoView.addGestureRecognizer(tapGestureRecognizer)
       
    }
    
    //TASK: pickerView
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
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.init(red: 138.0/255.0, green: 151.0/255.0, blue: 166.0/255.0, alpha: 1.0)
        pickerLabel.font = UIFont(name: "Avenir-Black", size: 16)
        pickerLabel.textAlignment = NSTextAlignment.Center
        
        let pickerType = DataPickerType(rawValue: component)!
        switch pickerType {
        case .sexual:
            let sex = sexualPicker[row]
            pickerLabel.text = sex.title
        case .age :
            let age = agePicker[row]
            pickerLabel.text = age.title
            
        case .colour :
            let colour = colourPicker[row]
            pickerLabel.text = colour.rawValue
            
        case .district :
            let district = districtPicker[row]
            pickerLabel.text = district.title
            
        }
        
        return pickerLabel
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
    //TASK: observe UIKeyboard Height
    var keyboardHeight: CGFloat!
    private func setUpKeyboardObserver() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            keyboardHeight = keyboardSize.height
        }
    }
    
    func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    //TASK: textView move up
    func textViewDidBeginEditing(textView: UITextView) {
        
        self.animatetextView(textView, up: true)
    }
    
    
    func textViewDidEndEditing(textView: UITextView) {
        
        self.animatetextView(textView, up: false)
    }
    
    func animatetextView(textView: UITextView, up: Bool) {
        
        let movementDistance = -keyboardHeight + 50
        let movementDuration: Double = 0.3
        
        var movement:CGFloat = 0
        
        if up {
            movement = movementDistance
        } else {
            movement = -movementDistance
        }
        
        UIView.beginAnimations("animatetextView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = CGRectOffset(self.view.frame, 0, movement)
        UIView.commitAnimations()
    }

}

