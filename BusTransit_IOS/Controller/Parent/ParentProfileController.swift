//
//  ParentProfileController.swift
//  BusTransit_IOS
//
//  Created by Nency Patel on 2022-07-31.
//

import UIKit
import DropDown
import GooglePlaces

class ParentProfileController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    let dropDown = DropDown()
     
    let dropDownSchool = DropDown()
     
    let dropDownGender = DropDown()
    
     @IBOutlet weak var imgPerson: UIImageView!
     
     var imagePicker = UIImagePickerController()
     
     @IBOutlet weak var txtEmail: UITextField!
     @IBOutlet weak var txtFullName: UITextField!
     @IBOutlet weak var txtContact: UITextField!
     @IBOutlet weak var btnAddress:UIButton!
     @IBOutlet weak var btnGender:UIButton!
     @IBOutlet weak var btnSelectUser: UIButton!
     @IBOutlet weak var btnSchool: UIButton!
    
    let Schools = ["Gajera School","MAria International","Bitter Success school","Mtl school"];
    
    //api address
    
    private var placeClient: GMSPlacesClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBorder()
        imgPerson.layer.cornerRadius = imgPerson.frame.size.width/2
        imgPerson.clipsToBounds = true
    
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer: )))
        imgPerson.isUserInteractionEnabled = true
        imgPerson.addGestureRecognizer(tapGestureRecognizer)
        
        placeClient = GMSPlacesClient.shared()
        
        //Do any additional setup after loading the view
    
    }
    func setBorder(){
        
        txtEmail.layer.cornerRadius = 10
        txtEmail.layer.borderWidth = 1.0
        
        txtFullName.layer.cornerRadius = 10
        txtFullName.layer.borderWidth = 1.0
        
        txtContact.layer.cornerRadius = 10
        txtContact.layer.borderWidth = 1.0
         
        btnAddress.layer.cornerRadius = 10
        btnGender.layer.cornerRadius = 10
        btnSelectUser.layer.cornerRadius = 10
        
        btnSchool.layer.cornerRadius = 10
    }
    
    @IBAction func tapSelectedGender(_ sender: UIButton) {
        
        dropDownGender.dataSource = ["Male","Female"]//4
        dropDownGender.anchorView = sender //5
        dropDownGender.bottomOffset = CGPoint(x: 0,y: sender.frame.size.height)//6
        dropDownGender.show()//7
        dropDownGender.selectionAction = { [weak self] (index: Int, item: String) in //8
            guard let _ = self else { return }
            sender.setTitle(item, for: .normal) //9
            
        }
        }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(imagePicker,animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img = info[.originalImage] as! UIImage
        
        self.imgPerson.image = img
        _ = info[UIImagePickerController.InfoKey.imageURL] as! URL
        //
        
      //  UploadImage(fileUrl: imageURL)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapSelectUser(_ sender: UIButton) {
        
        dropDown.dataSource = ["Driver", "Parent"]//4
        dropDown.anchorView = sender //5
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
        dropDown.show() //7
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
            guard let _ = self else { return }
            sender.setTitle(item, for: .normal) //9
        }
        
        
    }
    @IBAction func schoolSelection(_ sender: UIButton) {
        
        dropDown.dataSource = Schools//4
        dropDown.anchorView = sender //5
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
        dropDown.show() //7
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
            guard let _ = self else { return }
            sender.setTitle(item, for: .normal) //9
        }
        
    }
    
    
    @IBAction func SavePressed(_ sender: UIButton) {
        
        let allTextField = UtilClass.getTextfield(view: self.view)
        for txtField in allTextField{
            if txtField.text!.isEmpty
            {
                UtilClass._Alert(self,"Error in saving data" ,"All fields are mandatory!" )
                return
            }
            
            if !UtilClass.isValidEmail(txtEmail.text!){
                UtilClass._Alert(self,"Error in saving data", "wrong email formate!")
                return
            }
            
            if !UtilClass.isValidNumber(txtContact.text!){
                UtilClass._Alert(self, "Error in saving data", "Wrong phone number formate! (514-xxx-xxxx)")
                return
            }
            if(btnAddress.currentTitle == "search here"){
                UtilClass._Alert(self,"Error in saving data", "please find the valid address")
                return
            }
           /* if(imgURL == "")
            {
                UtilClass._Alert(self, "Error in saving data", "Please select image by tap on image")
                return
            }*/
        }
        
    }
    
    
    

    
}
