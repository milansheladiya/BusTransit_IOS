//
//  DriverDetailsViewController.swift
//  BusTransit_IOS
//
//  Created by Dishant Desai on 2022-07-27.
//

import UIKit

class DriverDetailsViewController: UIViewController {
    var schoolName = ""
    var address = ""
    var destinationAddress = ""
    var busId = ""
    var busNumber:Int = 0
    var driver:User?
    var busDetails:Bus?
    
    let fb = FirebaseUtil()
    
    @IBOutlet weak var busNumberLbl: UILabel!
    @IBOutlet weak var schoolAddressLbl: UILabel!
    @IBOutlet weak var schoolNameLbl: UILabel!
    @IBOutlet weak var terminalAddressLbl: UILabel!
    @IBOutlet weak var driverProfileImage: UIImageView!
    @IBOutlet weak var driverNameLbl: UILabel!
    @IBOutlet weak var tripStatusLbl: UILabel!
    @IBOutlet weak var tripDirectionLbl: UILabel!
    @IBOutlet weak var releaseBtn: UIButton!
    @IBOutlet weak var schoolNameView: UIView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var driverDetailVIew: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        UISetup()
        dataSetup()
//        liveData()
    }
    override func viewDidAppear(_ animated: Bool) {
       scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    @IBAction func backHandler(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    @IBAction func releaseDriverHandler(_ sender: UIButton) {
        let uialert = UIAlertController(title: "Confirm?", message: "Are you sure you want to release driver?", preferredStyle: UIAlertController.Style.alert)
        let nestedAlert = UIAlertController(title: "Success?", message: "Driver released successfully", preferredStyle: UIAlertController.Style.alert)
        uialert.addAction(
            UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive, handler: { action in
                FirebaseUtil._updateExistingFieldInDocumentWithId(_collection: "User", _docId: self.driver!.user_id, _data: [
                    "bus_id":""
                ])
                self.dismiss(animated: true)
                self.present(nestedAlert, animated: true)
                
            })
        )
        uialert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        nestedAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default))
        self.present(uialert, animated: true, completion: nil)
    }
    
    func UISetup(){
        schoolNameView.layer.cornerRadius = 20
        detailView.layer.cornerRadius = 15
        driverDetailVIew.layer.cornerRadius = 15
        releaseBtn.layer.cornerRadius = 20
        tripStatusLbl.textColor = busDetails!.active_sharing ? UtilClass.getUIColor(hex: "#29941F") :UtilClass.getUIColor(hex: "#FD5A33")
        tripDirectionLbl.textColor = busDetails!.going_to_school ? UtilClass.getUIColor(hex: "#29941F") : UtilClass.getUIColor(hex: "#FD5A33")
    }
    
    func dataSetup(){
        busNumberLbl.text = "Bus Number : " + String(busNumber)
        schoolNameLbl.text = schoolName
        schoolAddressLbl.text = address
        terminalAddressLbl.text = destinationAddress
        driverProfileImage.kf.setImage(with: driver!.photo_url.asUrl)
        driverNameLbl.text = driver?.fullName
        tripStatusLbl.text = busDetails!.active_sharing ? "On" : "Off"
        tripDirectionLbl.text = busDetails!.going_to_school ? "Going to school" : "Returning from school"
    }
    
    func liveData(){
        print("------------------------------")
        print(busDetails!.bus_id)
        fb._readLiveDocumentsWithField(_collection: "Bus", _doc_id: busDetails!.bus_id) { DocumentSnapshot in
            
            let _doc = DocumentSnapshot.data()
            
            self.driverNameLbl.text =  _doc?["fullName"] as? String
            self.tripStatusLbl.text = _doc?["active_sharing"] as? Bool ?? false ? "On" : "Off"
            self.tripDirectionLbl.text = _doc?["going_to_school"] as? Bool ?? false ? "Going to school" : "Returning from school"
            
            self.tripStatusLbl.textColor = _doc?["active_sharing"] as? Bool ?? false ? UtilClass.getUIColor(hex: "#29941F") :UtilClass.getUIColor(hex: "#FD5A33")
            self.tripDirectionLbl.textColor = _doc?["going_to_school"] as? Bool ?? false ? UtilClass.getUIColor(hex: "#29941F") : UtilClass.getUIColor(hex: "#FD5A33")
        }
    }
    
}
