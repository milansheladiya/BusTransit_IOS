//
//  DriverInfoViewController.swift
//  BusTransit_IOS
//
//  Created by Namra on 2022-08-02.
//

import UIKit
import Firebase
import UserNotifications // for notification

class NotificationListViewController: UIViewController, UITableViewDataSource,UITableViewDelegate
{
    
    let fb = FirebaseUtil()
    var isFirst:Bool = false
    
    @IBOutlet weak var notificationListView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationListView.register(UINib(nibName: NotificationListTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: NotificationListTableViewCell.identifier)
        notificationListView.dataSource = self
        notificationListView.delegate = self
//        loadData()
        
        StartLiveNotification()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NotificationList.NotificationListCollection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationListTableViewCell.identifier, for: indexPath) as! NotificationListTableViewCell
        cell.setUp(description: NotificationList.NotificationListCollection[indexPath.row],index: indexPath.row)
        return cell
    }
    
    
    func loadData()
    {
        print(UserList.schoolId)
        NotificationList.NotificationListCollection.removeAll()
            self.fb._readDocumentsWithMultipleFieldValues(_collection: "Notification",_field: "school_id", _value: UserList.schoolId){ QuerySnapshot in
            for document in QuerySnapshot.documents{

                    let date = document.data()["timestamp"] as! Timestamp
                
                    let dateTimestamp = NSDate(timeIntervalSince1970: TimeInterval(date.seconds))
                    let notification = Notification(
                        bus_id: document.data()["bus_id"] as! String,
                        driver_id: document.data()["driver_id"] as! String,
                        message: document.data()["message"] as! String,
                        notification_id: document.data()["notification_id"] as! String,
                        school_id: document.data()["school_id"] as! String,
                        timestamp: dateTimestamp as Date,
                        title: document.data()["title"] as! String)
                NotificationList.NotificationListCollection.append(notification)
            }
                NotificationList.NotificationListCollection.sort {
                    $0.timestamp > $1.timestamp
                }
            self.notificationListView.reloadData()
        }
    }
    
    func StartLiveNotification(){
   
        fb._readLiveDocuments(_collection: "Notification",_field: "school_id", _value: UserList.schoolId) { QuerySnapshot in
            NotificationList.NotificationListCollection.removeAll()
            for document in QuerySnapshot.documents{

                    let date = document.data()["timestamp"] as! Timestamp
                
                    let dateTimestamp = NSDate(timeIntervalSince1970: TimeInterval(date.seconds))
                    let notification = Notification(
                        bus_id: document.data()["bus_id"] as! String,
                        driver_id: document.data()["driver_id"] as! String,
                        message: document.data()["message"] as! String,
                        notification_id: document.data()["notification_id"] as! String,
                        school_id: document.data()["school_id"] as! String,
                        timestamp: dateTimestamp as Date,
                        title: document.data()["title"] as! String)
                NotificationList.NotificationListCollection.append(notification)
            }
                NotificationList.NotificationListCollection.sort {
                    $0.timestamp > $1.timestamp
                }
            self.notificationListView.reloadData()
            
            if self.isFirst{
//                self.TriggerNewNotification()
                UtilNotification.TriggerNewNotification(_title: "Alert", _body: "check out the new Alert from bus of the school that you selected!")
            }
            
            self.isFirst = true
        }
    }
    
}
