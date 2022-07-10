//
//  SignupViewController.swift
//  BusTransit_IOS
//
//  Created by Milan Sheladiya on 2022-07-08.
//

import UIKit
import DropDown
import GooglePlaces

class SignupViewController: UIViewController{
    
    let dropDown = DropDown()
    
    let dropDownSchool = DropDown()
    
    let dropDownGender = DropDown()
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtFullname: UITextField!
    @IBOutlet weak var txtContact: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var btnSelectUser: UIButton!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtRePassword: UITextField!
    @IBOutlet weak var btnSchool: UIButton!
    
    @IBOutlet weak var btnGender: UIButton!
    
     let Schools = [
            "Gajera School",
            "Maria Internation",
            "Bitter success school",
            "Canada school",
            "Mtl school"
        ];
    
    
    //address place api
    
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var addressLabel: UILabel!
    
    
    private var placesClient: GMSPlacesClient!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setBorder()
        fillName()
        
        
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
        
        
        txtAddress.layer.cornerRadius = 10
        txtAddress.layer.borderWidth = 1.0
        
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
        
        print(txtPassword.text!.count)
        
        if txtPassword.text!.count < 6  {
            UtilClass._Alert(self,"Signup Error", "The password must be 6 characters long or more.")
            return
        }
        
        if txtPassword.text != txtRePassword.text{
            UtilClass._Alert(self,"Signup Error", "Re-Password does not match with password")
            return
        }
        
        
        // collect information
        
        UserList.GlobleUser = User(user_id: "", bus_id: "", email_id: txtEmail.text!, fullname: txtFullname.text!, gender: btnGender.titleLabel!.text!, phone_no: txtContact.text!, address: txtAddress.text!, user_lat: 2202.22, user_long: 2.2222, photo_url: "https:url/", user_type: btnSelectUser.titleLabel!.text!, school_id: [])

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

            }
                }



        

        
            
    }
    
    
    
    func CleanForm(){
        print("Form clearing ---------------")
        txtEmail.text = ""
        txtAddress.text = ""
        txtFullname.text = ""
        txtContact.text = ""
        txtPassword.text = ""
        txtRePassword.text = ""
    }
    
    func fillName(){
        
        txtEmail.text = "milan@gmail.com"
        txtAddress.text = "5055 rolsyn Ave."
        txtFullname.text = "Milan Sheladiya"
        txtContact.text = "514-661-9876"
        txtPassword.text = "123456"
        txtRePassword.text = "123456"
        
        btnGender.setTitle("Male", for: .normal)
        btnSelectUser.setTitle("Driver", for: .normal)
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

extension SignupViewController: GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
      nameLabel.text = String(place.coordinate.latitude)
      addressLabel.text = place.name
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
