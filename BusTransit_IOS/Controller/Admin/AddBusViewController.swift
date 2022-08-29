//
//  AddBusViewController.swift
//  BusTransit_IOS
//
//  Created by Dishant Desai on 2022-07-18.
//

import UIKit
import GooglePlaces
class AddBusViewController: UIViewController {
    let ADDRESS_PLACEHOLDER = "Select Address"
    let ERROR = "Add Bus Error"
    @IBOutlet weak var addressTxtLabel: UILabel!
    @IBOutlet weak var busNumber: UITextField!
    @IBOutlet weak var addBusBtn: UIButton!
    @IBOutlet weak var clearAddressBtn: UIButton!
    let fb = FirebaseUtil()
    var destLat="",destLong="",busNumberVal = 0;
    var source = "", source_lat="", source_long = "", school_id = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        addBusBtn.layer.cornerRadius = 20
        // Do any additional setup after loading the view.
        fb._readAllDocuments(_collection: "Bus"){
            QueryDocumentSnapshot in
            self.busNumber.text = String(QueryDocumentSnapshot.documents.count + Int.random(in: 2..<9))
            self.busNumberVal = QueryDocumentSnapshot.documents.count + Int.random(in: 2..<9)
        }
        busNumber.isUserInteractionEnabled = false
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
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    @IBAction func clearAddressHandler(_ sender: UIButton) {
        resetAddressField()
    }
    
    @IBAction func addBusHandler(_ sender: UIButton) {
        if(addressTxtLabel.text == ADDRESS_PLACEHOLDER){
            UtilClass._Alert(self,ERROR, "Please select address!")
            return
        }
        let busObj = Bus(
            bus_id: "",
            bus_number: busNumberVal,
            active_sharing: false,
            current_lat: "",
            current_long: "",
            destination_lat: destLat,
            destination_long: destLong,
            destination: addressTxtLabel.text ?? "",
            going_to_school: false,
            school_id: school_id,
            source_lat: source_lat,
            source_long: source_long,
            source: source
        )
        let docId = FirebaseUtil._insertDocument(_collection: "Bus", _data: UtilClass.BusToFirebaseMap(obj: busObj)){
            String in
            if(String != "success")
            {
                UtilClass._Alert(self, "Error!", String)
                return
            }
            else
            {
                let uialert = UIAlertController(title: "Success", message: "Bus Added Successfully!", preferredStyle: UIAlertController.Style.alert)
                uialert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { action in
                    self.cleanForm()
                    self.redirectToPrevious()
                }
                                               ))
                self.present(uialert, animated: true, completion: nil)
            }
            
        }
        FirebaseUtil._updateExistingFieldInDocumentWithId(_collection: "Bus", _docId: docId, _data: [
            "bus_id":docId
        ])
        print("busObj",busObj)
    }
    func redirectToPrevious(){
        self.dismiss(animated: true,completion: nil)
    }
    func resetAddressField(){
        addressTxtLabel.text = ADDRESS_PLACEHOLDER
        addressTxtLabel.textColor = UtilClass.getUIColor(hex: "#D1D1D6")
        clearAddressBtn.isHidden = true
    }
    
    func cleanForm(){
        resetAddressField()
    }
    
}
extension AddBusViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        addressTxtLabel.textColor = UtilClass.getUIColor(hex: "#000")
        addressTxtLabel.text = place.name;
        destLat = String(place.coordinate.latitude)
        destLong = String(place.coordinate.longitude)
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
