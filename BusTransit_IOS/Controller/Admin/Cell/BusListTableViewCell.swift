//
//  BusListTableViewCell.swift
//  BusTransit_IOS
//
//  Created by Dishant Desai on 2022-07-17.
//

import UIKit

class BusListTableViewCell: UITableViewCell {
    static let identifier = String(describing: BusListTableViewCell  .self )
    @IBOutlet weak var busNumberLbl: UILabel!
    @IBOutlet weak var tripStatusLbl: UILabel!
    @IBOutlet weak var destAddressLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func setUp(bus: Bus){
        busNumberLbl.text = String(bus.bus_number)
        tripStatusLbl.text = bus.active_sharing ? "On" : "Off"
        destAddressLbl.text = bus.destination
        tripStatusLbl.textColor = bus.active_sharing ? UtilClass.getUIColor(hex: "#29941F") : UtilClass.getUIColor(hex: "#FD5A33")
        destAddressLbl.textColor = bus.active_sharing ? UtilClass.getUIColor(hex: "#29941F") : UtilClass.getUIColor(hex: "#FD5A33")
        self.selectionStyle = UITableViewCell.SelectionStyle.none
    }
}
