//
//  SignupViewController.swift
//  BusTransit_IOS
//
//  Created by Milan Sheladiya on 2022-07-08.
//

import UIKit
import DropDown
import GooglePlaces
import FirebaseFirestore
import FirebaseStorage

class SignupViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    let dropDown = DropDown()
    
    let dropDownSchool = DropDown()
    
    let dropDownGender = DropDown()
    
    @IBOutlet weak var imgPerson: UIImageView!
    
    
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtFullname: UITextField!
    @IBOutlet weak var txtContact: UITextField!
    @IBOutlet weak var btnAddress: UIButton!
    @IBOutlet weak var btnSelectUser: UIButton!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtRePassword: UITextField!
    @IBOutlet weak var btnSchool: UIButton!
    
    @IBOutlet weak var btnGender: UIButton!
    
    var imgURL:String = "https://firebasestorage.googleapis.com/v0/b/kitchenanywhere-84ad5.appspot.com/o/splashMainLogo.png?alt=media&token=693ad5fe-45d4-4db4-975e-40026a249530"
    
    let Schools = [
        "Gajera School",
        "Maria Internation",
        "Bitter success school",
        "Canada school",
        "Mtl school"
    ];
    
    
    //address place api
    
    private var placesClient: GMSPlacesClient!
    var latitude = ""
    var longitude = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBorder()
        fillName()
        imgPerson.layer.cornerRadius = imgPerson.frame.size.width/2
        imgPerson.clipsToBounds = true
        
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imgPerson.isUserInteractionEnabled = true
        imgPerson.addGestureRecognizer(tapGestureRecognizer)
        
        
        placesClient = GMSPlacesClient.shared()
        
        // Do any additional setup after loading the view.
    }
    
    
    func setBorder(){
        
        txtEmail.layer.cornerRadius = 10
        txtEmail.layer.borderWidth = 1.0
        
        txtFullname.layer.cornerRadius = 10
        txtFullname.layer.borderWidth = 1.0
        
        txtContact.layer.cornerRadius = 10
        txtContact.layer.borderWidth = 1.0
        
        
        btnAddress.layer.cornerRadius = 10
        btnGender.layer.cornerRadius = 10
        btnSelectUser.layer.cornerRadius = 10
        
        
        txtPassword.layer.cornerRadius = 10
        txtPassword.layer.borderWidth = 1.0
        
        
        txtRePassword.layer.cornerRadius = 10
        txtRePassword.layer.borderWidth = 1.0
        
        btnSchool.layer.cornerRadius = 10
        
    }
    
    
    @IBAction func tapSelectGender(_ sender: UIButton) {
        
        dropDownGender.dataSource = ["Male", "Female"]//4
        dropDownGender.anchorView = sender //5
        dropDownGender.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
        dropDownGender.show() //7
        dropDownGender.selectionAction = { [weak self] (index: Int, item: String) in //8
            guard let _ = self else { return }
            sender.setTitle(item, for: .normal) //9
        }
        
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img = info[.originalImage] as! UIImage
        
        self.imgPerson.image = img
        let imageURL = info[UIImagePickerController.InfoKey.imageURL] as! URL
        // Handle your logic here, e.g. uploading file to Cloud Storage for Firebase
        UploadImage(fileUrl: imageURL)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // ---------------- upload images ---------------
    
    func UploadImage(fileUrl: URL)
    {
        do{
            let fileExtension = fileUrl.pathExtension
            let storageref = Storage.storage().reference()
            let imagenode = storageref.child("\(UUID().uuidString).\(fileExtension)")
            
            imagenode.putFile(from: fileUrl, metadata: nil){(storageMetaData, error) in
                
                if let error = error {
                    print("Upload error: \(error.localizedDescription)")
                    return
                }
                // Show UIAlertController here
                
                imagenode.downloadURL { (url, error) in
                    if let error = error  {
                        print("Error on getting download url: \(error.localizedDescription)")
                        return
                    }
                    self.imgURL = url!.absoluteString
                }
            }
        }
        
    }
    
    
    @IBAction func tapSelectUser(_ sender: UIButton) {
        
        dropDown.dataSource = ["DRIVER", "PARENT"]//4
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
    
    
    
    
    @IBAction func SignupPressed(_ sender: UIButton) {
        
        let allTextField = UtilClass.getTextfield(view: self.view)
        for txtField in allTextField
        {
            if txtField.text!.isEmpty{
                UtilClass._Alert(self,"Signup Error", "All fields are mandatory!")
                return
            }
        }
        
        
        if !UtilClass.isValidEmail(txtEmail.text!) {
            UtilClass._Alert(self,"Signup Error", "wrong email format!")
            return
        }
        
        if !UtilClass.isValidNumber(txtContact.text!){
            UtilClass._Alert(self,"Signup Error", "wrong phone number format! (514-134-1128)")
            return
        }
        
        if txtPassword.text!.count < 8  {
            UtilClass._Alert(self,"Password Weak", "The password must be min 8 characters.")
            return
        }
        if !UtilClass.isValidPassword(txtPassword.text!)  {
            UtilClass._Alert(self,"Password Weak", "must contain  at least 1 Alphabet, 1 Number and 1 Special Character")
            return
        }
        if txtPassword.text != txtRePassword.text{
            UtilClass._Alert(self,"Signup Error", "Re-Password does not match with password")
            return
        }
        
        
        if(btnAddress.currentTitle == "Search here")
        {
            UtilClass._Alert(self,"Signup Error", "Please find the address")
            return
        }
        
        if(imgURL == "")
        {
            UtilClass._Alert(self,"Signup Error", "Please select image by tap on image")
            return
        }
        
        // collect information
        
        UserList.GlobleUser = User(user_id: "", bus_id: "", email_id: txtEmail.text!, fullName: txtFullname.text!, gender: btnGender.titleLabel!.text!, phone_no: txtContact.text!, address: btnAddress.currentTitle ?? "Search here", user_lat: latitude, user_long: longitude, photo_url: imgURL, user_type: btnSelectUser.titleLabel!.text!, school_id: [])
        
        FirebaseUtil.createUser(newUser: UserList.GlobleUser, password: txtPassword.text!) { (uid) in
            if (uid == "") {
                UtilClass._Alert(self, "Error!", Constants.RecentError)
                
                print("Error-> creating new user")
                return
            }
            
            // if successfully created
            
            FirebaseUtil._insertDocumentWithId(_collection: "User",_docId: uid, _data : UtilClass.UserToFirebaseMap(obj: UserList.GlobleUser)){
                String in
                
                if(String != "success")
                {
                    UtilClass._Alert(self, "Error!", String)
                    return
                }
                else
                {
                    UtilClass._Alert(self, "Success", "Now, you are regiested!")
                }
                self.CleanForm()
            }
            
        }
        

    }
    
    
    
    func CleanForm(){
        print("Form clearing ---------------")
        txtEmail.text = ""
        btnAddress.setTitle("Search here", for: .normal)
        txtFullname.text = ""
        txtContact.text = ""
        txtPassword.text = ""
        txtRePassword.text = ""
    }
    
    func fillName(){
        
        txtEmail.text = "milan@gmail.com"
        txtFullname.text = "Milan Sheladiya"
        txtContact.text = "514-661-9876"
        txtPassword.text = "123456"
        txtRePassword.text = "123456"
        
        btnGender.setTitle("Male", for: .normal)
        btnSelectUser.setTitle("DRIVER", for: .normal)
        btnSchool.setTitle("School", for: .normal)
        
    }
    
    
    @IBAction func tabSignIn(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "goToLogin", sender: self)
        
    }
    
    
    @IBAction func getCurrentPlace(_ sender: UIButton) {
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                                                  UInt(GMSPlaceField.placeID.rawValue) |
                                                  UInt(GMSPlaceField.coordinate.rawValue) |
                                                              GMSPlaceField.addressComponents.rawValue |
                                                              GMSPlaceField.formattedAddress.rawValue)
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
        
    }
    
    
}

extension SignupViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        btnAddress.setTitle(place.name, for: .normal)
        latitude = String(format: "%f", place.coordinate.latitude)
        longitude = String(format: "%f", place.coordinate.longitude)
        print("Place lat: \(place.coordinate.latitude)")
        print("Place long: \(place.coordinate.longitude)")
        print("Place name: \(place.name)")
        print("Place ID: \(place.placeID)")
        print("Place attributions: \(place.attributions)")
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

/*
 
 tapped event from image view
 //https://www.codegrepper.com/code-examples/swift/uiimageview+add+tap+gesture+swift
 
 
 image choose from photos
 // help from https://www.youtube.com/watch?v=mx7oL5CP5AQ
 
 
 image crop to round in UIimageview
 https://www.youtube.com/watch?v=XReZoS32dy8
 
 */
