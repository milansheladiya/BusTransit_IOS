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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func setup(bus:Bus){
        cellView.layer.cornerRadius = 10
        callView.layer.cornerRadius = 10
        driverProfileImage.layer.cornerRadius = 50
    }
    
}
