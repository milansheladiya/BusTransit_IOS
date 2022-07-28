//
//  DriverTableViewCell.swift
//  BusTransit_IOS
//
//  Created by Dishant Desai on 2022-07-26.
//

import UIKit
import Kingfisher

protocol DriverTableViewCellDelegate:AnyObject {
    func allocateDriver(driver:User,busId:String)
    
}
class DriverTableViewCell: UITableViewCell {
    weak var delegate: DriverTableViewCellDelegate?
    static let identifier = String(describing: DriverTableViewCell  .self )
    
    @IBOutlet weak var driverProfileImage: UIImageView!
    @IBOutlet weak var driverNameLbl: UILabel!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var allocateBtn: UIButton!
    
    var bus_id:String?
    var currentDriver:User?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setup(driver:User,busId:String){
        bus_id = busId
        currentDriver = driver
        driverNameLbl.text = driver.fullName
        driverProfileImage.kf.setImage(with: driver.photo_url.asUrl)
        allocateBtn.layer.cornerRadius = 15
        callBtn.layer.cornerRadius = 15
        self.selectionStyle = UITableViewCell.SelectionStyle.none
    }
    @IBAction func allocateDriverHandler(_ sender: UIButton) {
        
        delegate?.allocateDriver(driver: currentDriver!, busId: bus_id!)
        print(":Call")
    }
    @IBAction func callHandler(_ sender: UIButton) {
    }
}
