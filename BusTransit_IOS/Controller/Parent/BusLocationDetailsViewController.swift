//
//  BusLocationDetailsViewController.swift
//  BusTransit_IOS
//
//  Created by Dishant Desai on 2022-08-08.
//

import UIKit

class BusLocationDetailsViewController: UIViewController {
    var busDetails:BusToDriverModel?
    @IBOutlet weak var driverName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDriverProfile"{
            let destinationVC = segue.destination as! DriverProfileViewController
            destinationVC.busDetails = busDetails
        }
    }
    @IBAction func driverProfileHandler(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToDriverProfile",sender: self)
    }
    @IBAction func backHandler(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    func setUp(){
        driverName.text = busDetails?.fullName
    }
}
