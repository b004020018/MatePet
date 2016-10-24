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

class AddNewDataViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, FusumaDelegate {
    
    var imagedata: NSData?
    var localVideoPath: NSURL?
    var selected: String!
    
    @IBOutlet weak var dataUpdateProgressView: UIProgressView!
    @IBOutlet weak var addVideoView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var addDataTextView: UITextView!
    @IBAction func closeButton(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
        let parent = self.presentingViewController as? UITabBarController
        parent?.selectedIndex = 0
    }
    
    
    @IBAction func saveNewDataButton(sender: UIButton) {
        
        self.dataUpdateProgressView.hidden = false
        let facebookData = NSUserDefaults.standardUserDefaults()
        guard let userFacebookID = facebookData.stringForKey("userFacebookID") else { fatalError() }
        //store in database
        let cat: [String : AnyObject] = [
        "owner" : (FIRAuth.auth()?.currentUser?.uid)!,
        "district" : selectedDataDetail.district,
        "created_at" : FIRServerValue.timestamp(),
        "sex" : selectedDataDetail.sex,
        "age" : selectedDataDetail.age,
        "colour" : selectedDataDetail.colour,
        "description" : selectedDataDetail.description,
        "selected" : selected,
        "userFacebookID": userFacebookID,
        "likesCount": 0 ]
        let rootRef = FIRDatabase.database().reference()
        let autoID = rootRef.child("Cats").childByAutoId().key
        rootRef.child("Cats").child(autoID).setValue(cat)
        
        //store in firebase
        
        if let localVideoPath = localVideoPath {
            let storageRef = FIRStorage.storage().reference().child("Cats/\(autoID).mov")
            let uploadMetadata = FIRStorageMetadata()
            uploadMetadata.contentType = "video/quicktime"
            let uploadTask = storageRef.putFile(localVideoPath, metadata: uploadMetadata) { (metadata, error) in
                if (error != nil) {
                    print("Got error")
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
                    print("Got error")
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
    func addVideoViewTapped(sender: AnyObject)
    {
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        fusuma.hasVideo = true // If you want to let the users allow to use video.
        self.presentViewController(fusuma, animated: true, completion: nil)
    
    }
    
    func fusumaImageSelected(image: UIImage) {
        selected = "image"
        let imageView = UIImageView(image: image)
        imageView.frame = self.addVideoView.frame
        view.addSubview(imageView)
        imagedata = UIImagePNGRepresentation(image)
        print("Image selected")
    }
    
    // Return the image but called after is dismissed.
    func fusumaDismissedWithImage(image: UIImage) {
        print("Called just after FusumaViewController is dismissed.")
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: NSURL) {
        selected = "video"
        localVideoPath = fileURL
        let url = localVideoPath
                let player = AVPlayer(URL: url!)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
        
                playerViewController.view.frame = self.addVideoView.frame
                self.addVideoView = playerViewController.view
                self.view.addSubview(playerViewController.view)
                self.addChildViewController(playerViewController)
                
                player.play()

        print("Called just after a video has been selected.")
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
        var sex: String!
        var age: String!
        var colour: String!
        var district: Int!
        var description: String!
    }
    
    
    
    var selectedDataDetail = SelectedDataDetail()
    
    let sexualPicker : [Sexual] = [ .male, .female, .unknown ]
    let agePicker : [Age] = [.child, .adult ]
    let colourPicker : [Colour] = [.white, .black, .brown, .yellow, .tabby, .mix, .other]
    let districtPicker: [District] = [.tw_tpe, .tw_nwt, .tw_kee, .tw_ila, .tw_tao, .tw_hsq, .tw_hsz, .tw_mia, .tw_txg, .tw_cha, .tw_nan, .tw_yun, .tw_cyq, .tw_cyi, .tw_tnn, .tw_khh, .tw_pif, .tw_hua, .tw_ttt, .tw_pen, .tw_kin, .tw_lie]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataUpdateProgressView.hidden = true
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        selectedDataDetail.description = addDataTextView.text
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(AddNewDataViewController.addVideoViewTapped(_:)))
        addVideoView.userInteractionEnabled = true
        addVideoView.addGestureRecognizer(tapGestureRecognizer)
       
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

