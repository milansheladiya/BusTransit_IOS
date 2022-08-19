//
//  DriverProfileViewController.swift
//  BusTransit_IOS
//
//  Created by Dishant Desai on 2022-08-08.
//

import UIKit

class DriverProfileViewController: UIViewController {
    var busDetails:BusToDriverModel?
    @IBOutlet weak var driverEmailLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var phoneNoLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var driverProfileImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    @IBAction func backHandler(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    func setup(){
        driverEmailLbl.text = busDetails?.email_id
        nameLbl.text = busDetails?.fullName
        phoneNoLbl.text = busDetails?.phone_no
        addressLbl.text = busDetails?.address
        genderLbl.text = busDetails?.gender
        driverProfileImage.kf.setImage(with: busDetails?.photo_url.asUrl)
    }
}
