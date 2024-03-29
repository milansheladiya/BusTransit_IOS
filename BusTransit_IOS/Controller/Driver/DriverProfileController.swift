//
//  DriverProfileController.swift
//  BusTransit_IOS
//
//  Created by Nency Patel on 2022-07-30.
//

import UIKit
import DropDown
import GooglePlaces
import FirebaseStorage

class  DriverProfileController:UIViewController,
                               UIImagePickerControllerDelegate,UINavigationControllerDelegate

{
   let dropDown = DropDown()
    
   let dropDownSchool = DropDown()
    
   let dropDownGender = DropDown()
    let fb = FirebaseUtil()
   
    @IBOutlet weak var imgPerson: UIImageView!
    
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtContact: UITextField!
    @IBOutlet weak var btnAddress:UIButton!
    @IBOutlet weak var btnGender:UIButton!
    @IBOutlet weak var lblAddress: UILabel!
    
    
    var imgURL:String = "https://firebasestorage.googleapis.com/v0/b/kitchenanywhere-84ad5.appspot.com/o/splashMainLogo.png?alt=media&token=693ad5fe-45d4-4db4-975e-40026a249530"
    
    
    var isPhotoChanged:Bool = false
    
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
        
        txtEmail.isEnabled = false
        
        //Do any additional setup after loading the view
        loadDriverDetails()
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
        
        
    }
    
    func loadDriverDetails()
    {
        
        self.txtEmail.text = UserList.GlobleUser.email_id
        self.txtFullName.text = UserList.GlobleUser.fullName
        self.txtContact.text = UserList.GlobleUser.phone_no
        self.lblAddress.text = UserList.GlobleUser.address
        self.btnGender.titleLabel?.text = UserList.GlobleUser.gender
        self.imgURL = UserList.GlobleUser.photo_url
        self.imgPerson.loadFrom(URLAddress: self.imgURL)
        
//        fb._readSingleDocument(_collection: "User", _document: UserList.GlobleUser.user_id) { DocumentSnapshot in
//            
//            if let doc = DocumentSnapshot.data() {
//                self.txtEmail.text = doc["email_id"] as? String
//                self.txtFullName.text = doc["fullName"] as? String
//                self.txtContact.text = doc["phone_no"] as? String
//                self.lblAddress.text = doc["address"] as? String
//                self.btnGender.titleLabel?.text = doc["gender"] as? String
//                self.imgURL = doc["photo_url"] as? String ?? self.imgURL
//                self.imgPerson.loadFrom(URLAddress: self.imgURL)
//            }
//            else
//            {
//                UtilClass._Alert(self, "Error", "Something wrong in fetching Driver Data")
//            }
//            
//               
//            
//        }
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
        let imageURL = info[UIImagePickerController.InfoKey.imageURL] as! URL
        //
        
        UploadImage(fileUrl: imageURL)
        self.dismiss(animated: true, completion: nil)
    }
    
    //--------------------upload images---------------------
    
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
                    self.isPhotoChanged = true
                }
            }
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
            if(lblAddress.text == ""){
                UtilClass._Alert(self,"Error in saving data", "please find the valid address")
                return
            }
            
            UserList.GlobleUser.fullName = txtFullName.text!
            UserList.GlobleUser.phone_no = txtContact.text!
            UserList.GlobleUser.address = lblAddress.text!
            UserList.GlobleUser.gender = btnGender.currentTitle ?? "Male"
            UserList.GlobleUser.photo_url = self.imgURL
            
            
            FirebaseUtil._updateExistingFieldInDocumentWithId(_collection: "User", _docId: UserList.GlobleUser.user_id, _data:
                ["fullName":UserList.GlobleUser.fullName,
                 "phone_no":UserList.GlobleUser.phone_no,
                 "address":UserList.GlobleUser.address,
                 "gender":UserList.GlobleUser.gender,
                 "photo_url":UserList.GlobleUser.photo_url])
            
            UtilClass._Alert(self,"Success", "Data saved")
            
        }
        
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



extension UIImageView
{
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                        self?.image = loadedImage
                }
            }
        }
    }
}


extension DriverProfileController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.lblAddress.text = place.name
//        self.btnAddress.setTitle(place.name, for: .normal)
        
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




    
   
    

