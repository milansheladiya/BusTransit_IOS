//
//  ParentBusTableViewCell.swift
//  BusTransit_IOS
//
//  Created by Namra on 2022-08-04.
//

import UIKit

class ParentBusTableViewCell: UITableViewCell {

    @IBOutlet weak var busNumberLbl: UILabel!
    @IBOutlet weak var busDirectionLbl: UILabel!
    @IBOutlet weak var driverNameLbl: UILabel!
    @IBOutlet weak var driverProfileImage: UIImageView!
    @IBOutlet weak var callView: UIView!
    @IBOutlet weak var cellView: UIView!
    
    static let identifier = String(describing: ParentBusTableViewCell .self )
    var driverPhoneNo:String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.callToDriver))
        self.callView.addGestureRecognizer(gesture)
    }
    @objc func callToDriver(sender : UITapGestureRecognizer) {
        guard let number = URL(string: "tel://" + (driverPhoneNo ?? "")) else { return }
        UIApplication.shared.open(number)
    }

    func setup(bus:BusToDriverModel){
        cellView.layer.cornerRadius = 10
        callView.layer.cornerRadius = 10
        driverProfileImage.layer.cornerRadius = 50
        busNumberLbl.text = String(bus.bus_number)
        busDirectionLbl.text = bus.going_to_school ? "Going to school" : "Coming home"
        driverProfileImage.kf.setImage(with: bus.photo_url.asUrl)
        driverNameLbl.text = bus.fullName
        
        //Removing special character from phone number string
        driverPhoneNo = bus.phone_no.replacingOccurrences(of: "-", with: "")
    }
    
}
