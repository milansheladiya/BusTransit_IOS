//
//  ParentProfileViewController.swift
//  BusTransit_IOS
//
//  Created by Nency Patel on 2022-08-16.
//

import UIKit
import DropDown
import GooglePlaces
import FirebaseStorage

class ParentProfileViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    let fb = FirebaseUtil()
    
    
    let dropDown = DropDown()
    let dropDownGender = DropDown()
    
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var imgPerson: UIImageView!
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtContactNo: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var btnAddress: UIButton!
    @IBOutlet weak var btnGender: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    
    var imgURL:String = "https://firebasestorage.googleapis.com/v0/b/kitchenanywhere-84ad5.appspot.com/o/splashMainLogo.png?alt=media&token=693ad5fe-45d4-4db4-975e-40026a249530"
    
    var isPhotoChanged:Bool = false
    
    let Schools = ["Gajera Schools", "Maria International","Bitter Success school","Mtl school"];
     
    //api address
    
    private var placeClient: GMSPlacesClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBorder()
        imgPerson.layer.cornerRadius = imgPerson.frame.size.width/2
        imgPerson.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imgPerson.isUserInteractionEnabled = true
        imgPerson.addGestureRecognizer(tapGestureRecognizer)
                
                placeClient = GMSPlacesClient.shared()
                
                txtEmail.isEnabled = false
        
        // Do any additional setup after loading the view.
        loadParentDetails()
    }
    
   
    
    func setBorder(){
        
        txtEmail.layer.cornerRadius = 10.0
        txtEmail.layer.borderWidth = 1.0
        
        txtFullName.layer.cornerRadius = 10.0
        txtFullName.layer.borderWidth = 1.0
         
        txtContactNo.layer.cornerRadius = 10.0
        txtContactNo.layer.borderWidth = 1.0
        
        btnAddress.layer.cornerRadius = 10.0
        btnAddress.layer.borderWidth = 1.0
        
    }
    
    func loadParentDetails()
    {
               self.txtEmail.text = UserList.GlobleUser.email_id
               self.txtFullName.text = UserList.GlobleUser.fullName
               self.txtContactNo.text = UserList.GlobleUser.phone_no
               self.txtAddress.text = UserList.GlobleUser.address
               self.btnGender.titleLabel?.text = UserList.GlobleUser.gender
               self.imgURL = UserList.GlobleUser.photo_url
               self.imgPerson.loadFromDB(URLAddress: self.imgURL)
    }

    
     @IBAction func tapSelectedGender(_ sender: UIButton){
         dropDownGender.dataSource = ["male","female"]
         dropDownGender.anchorView = sender
         dropDownGender.bottomOffset = CGPoint(x: 0,y: sender.frame.size.height)
         dropDownGender.show()
         dropDownGender.selectionAction = {[weak self](index: Int, item: String) in
             guard let _ = self else { return }
             sender.setTitle(item, for: .normal)
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
        
        UploadImage(fileUrl: imageURL)
        self.dismiss(animated: true,completion: nil)
    }
 
    //================================ upload Image ================================
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
   
    
    @IBAction func SavePressed(_ sender: UIButton){
        
        let allTextField = UtilClass.getTextfield(view: self.view)
        
        for txtField in allTextField{
            
            if(txtField.text!.isEmpty){
                UtilClass._Alert(self, "error in saving data", "All fields are mandatory")
                return
            }
            
            if !UtilClass.isValidEmail(txtEmail.text!){
                UtilClass._Alert(self, "Error in saving data", "wrong email formate")
                return
            }
            
            if !UtilClass.isValidNumber(txtContactNo.text!){
                UtilClass._Alert(self, "error in saving data", "wrong contact number formate")
                return
            }
            
            if(txtAddress.text == ""){
                           UtilClass._Alert(self,"Error in saving data", "please find the valid address")
                           return
                       }
            
                UserList.GlobleUser.fullName = txtFullName.text!
                UserList.GlobleUser.phone_no = txtContactNo.text!
                UserList.GlobleUser.address = txtAddress.text!
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
                                                UInt(GMSPlaceField.placeID.rawValue))
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
        func loadFromDB(URLAddress: String) {
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
        
extension ParentProfileViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.txtAddress.text = place.name

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
        
    
    

    


