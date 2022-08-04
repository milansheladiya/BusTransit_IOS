//
//  NotificationListTableViewCell.swift
//  BusTransit_IOS
//
//  Created by Namra on 2022-08-02.
//

import UIKit

class NotificationListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var notificationLbl : UILabel!
    @IBOutlet weak var timeLbl : UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl : UILabel!
    @IBOutlet weak var cellView: UIView!
    static let identifier = String(describing: NotificationListTableViewCell .self )

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.layer.cornerRadius = 10
        cellView.backgroundColor = UtilClass.getUIColor(hex: "#FC8989")
    }

    
    func setUp(description: Notification){
        notificationLbl.text = "Notification 10"
        timeLbl.text = UtilClass.getDate(date:description.timestamp)
        titleLbl.text = description.title
        descriptionLbl.text = description.message
        self.selectionStyle = UITableViewCell.SelectionStyle.none
    }
    
}
