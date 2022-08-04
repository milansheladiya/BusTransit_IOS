//
//  DriverInfoViewController.swift
//  BusTransit_IOS
//
//  Created by Namra on 2022-08-02.
//

import UIKit
import Firebase

class NotificationListViewController: UIViewController, UITableViewDataSource,UITableViewDelegate
{
    
    let fb = FirebaseUtil()
    
    @IBOutlet weak var notificationListView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationListView.register(UINib(nibName: NotificationListTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: NotificationListTableViewCell.identifier)
        notificationListView.dataSource = self
        notificationListView.delegate = self
        loadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NotificationList.NotificationListCollection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationListTableViewCell.identifier, for: indexPath) as! NotificationListTableViewCell
        cell.setUp(description: NotificationList.NotificationListCollection[indexPath.row])
        return cell
    }
    func loadData(){
        NotificationList.NotificationListCollection.removeAll()
        fb._readAllDocuments(_collection: "Notification"){
            QueryDocumentSnapshot in
            for document in QueryDocumentSnapshot.documents{
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
            self.notificationListView.reloadData()
        }
    }
}
