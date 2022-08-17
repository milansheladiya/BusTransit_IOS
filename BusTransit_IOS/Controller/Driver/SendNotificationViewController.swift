//
//  SendNotificationViewController.swift
//  BusTransit_IOS
//
//  Created by Milan Sheladiya on 2022-08-17.
//

import UIKit
import SwiftUI
import Firebase

class SendNotificationViewController: UIViewController {
    
    @IBOutlet weak var txtTitle: UITextView!
    @IBOutlet weak var txtDescription: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        clear()
    }

    @IBAction func sendNotification(_ sender: UIButton) {
        
        if txtTitle.text.count <= 3 || txtDescription.text.count <= 3
        {
            UtilClass._Alert(self,"Error", "length of Title and Description must br greater than 3!")
        }
        
        FirebaseUtil._insertDocument(_collection: "Notification",
                                     _data: ["bus_id" : UserList.GlobleUser.bus_id,
                                             "driver_id" : UserList.GlobleUser.user_id,
                                             "message" : txtDescription.text!,
                                             "notification_id": "notification_id",
                                             "school_id": UserList.GlobleUser.school_id,
                                             "timestamp": Data(),
                                             "title": txtTitle.text!]) { success in
            if success == "success"{
                UtilClass._Alert(self,"Success", "Notification has been sent successfully!")
                self.clear()
            }
            else
            {
                UtilClass._Alert(self,"Error", success)
            }
        }
        
        
    }
    
    func clear(){
        txtTitle.text = ""
        txtDescription.text = ""
    }
    
}
