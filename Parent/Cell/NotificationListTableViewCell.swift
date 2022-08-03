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
    static let identifier = String(describing: NotificationListTableViewCell .self )

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp(description: Notification){
        descriptionLbl.text = description.notification_description
        self.selectionStyle = UITableViewCell.SelectionStyle.none
    }
    
}
