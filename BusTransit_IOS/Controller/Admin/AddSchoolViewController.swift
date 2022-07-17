//
//  AddSchoolViewController.swift
//  BusTransit_IOS
//
//  Created by Dishant Desai on 2022-07-16.
//

import UIKit
import GooglePlaces

class AddSchoolViewController: UIViewController {
    let ADDRESS_PLACEHOLDER = "Select Address"
    let ERROR = "Add School Error"
    
    @IBOutlet weak var addressTxtLabel: UILabel!
    @IBOutlet weak var clearAddressBtn: UIButton!
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var phoneNoTxtField: UITextField!
    @IBOutlet weak var addBtn: UIButton!
    
    let fb = FirebaseUtil()
    
    
    var schoolLat="",schoolLong="";
    override func viewDidLoad() {
        super.viewDidLoad()
        addBtn.layer.cornerRadius = 20
        // Do any additional setup after loading the view.
        setupAddressBox()
    }
    func setupAddressBox(){
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.addressSelector))
        addressTxtLabel.isUserInteractionEnabled = true
        addressTxtLabel.layer.cornerRadius = 5
        addressTxtLabel.layer.cornerRadius = 5
        addressTxtLabel.layer.borderWidth = 1.0
        addressTxtLabel.layer.borderColor = UtilClass.getUIColor(hex: "#D1D1D6")?.cgColor
        self.addressTxtLabel.addGestureRecognizer(gesture)
        clearAddressBtn.isHidden = true
    }
    @objc func addressSelector(sender : UITapGestureRecognizer) {
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
    func resetAddressField(){
        addressTxtLabel.text = ADDRESS_PLACEHOLDER
        addressTxtLabel.textColor = UtilClass.getUIColor(hex: "#D1D1D6")
        clearAddressBtn.isHidden = true
    }
    @IBAction func backHandler(_ sender: UIBarButtonItem) {
        redirectToHome()
    }
    @IBAction func clearAddress(_ sender: UIButton) {
        resetAddressField()
    }
    @IBAction func addSchollHandler(_ sender: UIButton) {
        let allTextField = UtilClass.getTextfield(view: self.view)
        for txtField in allTextField
        {
            if txtField.text!.isEmpty{
                UtilClass._Alert(self,ERROR, "All fields are mandatory!")
                return
            }
        }
        if(addressTxtLabel.text == ADDRESS_PLACEHOLDER){
            UtilClass._Alert(self,ERROR, "Please select address!")
            return
        }
        if !UtilClass.isValidEmail(emailTxtField.text!) {
            UtilClass._Alert(self,ERROR, Constants.INVALID_EMAIL_MSG)
            return
        }
        
        if !UtilClass.isValidNumber(phoneNoTxtField.text!){
            UtilClass._Alert(self,ERROR, Constants.INVALID_PHONE_NO)
            return
        }
        let schoolObj = School(school_id: Constants.DEFAULT_SCHOOL_ID, address: addressTxtLabel.text!, email_id: emailTxtField.text!, name: nameTxtField.text!, phone_no: phoneNoTxtField.text!, lat: schoolLat, long: schoolLong)
        let docId = FirebaseUtil._insertDocument(_collection: "School", _data: UtilClass.SchoolToFirebaseMap(obj: schoolObj)){
            String in
            if(String != "success")
            {
                UtilClass._Alert(self, "Error!", String)
                return
            }
            else
            {

                let uialert = UIAlertController(title: "Success", message: "Scholl Added Successfully!", preferredStyle: UIAlertController.Style.alert)
                uialert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { action in
                        
                    self.cleanForm()
                    self.redirectToHome()

                    }
                ))
                self.present(uialert, animated: true, completion: nil)
                
            }
            
        }
        FirebaseUtil._updateExistingFieldInDocumentWithId(_collection: "School", _docId: docId, _data: [
            "school_id":docId
        ])
            }
    func redirectToHome(){
        self.dismiss(animated: true,completion: nil)
    }
    func cleanForm(){
        emailTxtField.text = ""
        nameTxtField.text = ""
        phoneNoTxtField.text = ""
        resetAddressField()
    }
    
    
}
extension AddSchoolViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        addressTxtLabel.textColor = UtilClass.getUIColor(hex: "#000")
        addressTxtLabel.text = place.name;
        schoolLat = String(place.coordinate.latitude)
        schoolLong = String(place.coordinate.longitude)
        clearAddressBtn.isHidden = false
        
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
