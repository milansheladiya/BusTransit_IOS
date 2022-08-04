//
//  NotificationModel.swift
//  BusTransit_IOS
//
//  Created by Namra on 2022-08-02.
//

import Foundation

struct Notification{
    var bus_id : String
    var driver_id : String
    var message : String
    var notification_id: String
    var school_id: String
    var timestamp: Date
    var title: String
}

class NotificationList {
    static var NotificationListCollection:[Notification] =
    [
        Notification(bus_id: "24", driver_id: "2",  message: "Due to engine issues, we need to stop or bus at sicard rue. All students are safe. There will be 5 minutes to solve problem. We will solve it and we will move soon. Don't worry about your childrens.",notification_id:"20",school_id:"144",timestamp:Date()
 , title: "Issue in the bus engine"),
        Notification(bus_id: "22",driver_id: "1",  message: "Due to engine issues, we need to stop or bus at sicard rue. All students are safe. There will be 5 minutes to solve problem. We will solve it and we will move soon. Don't worry about your childrens.",notification_id:"19",school_id:"14",timestamp:Date()
 , title: "Issue in the bus engine"),
        Notification(bus_id: "20",driver_id: "3",  message: "Due to engine issues, we need to stop or bus at sicard rue. All students are safe. There will be 5 minutes to solve problem. We will solve it and we will move soon. Don't worry about your childrens.",notification_id:"18",school_id:"44",timestamp:Date()
 , title: "Issue in the bus engine"),
        Notification(bus_id: "4",driver_id: "5",  message: "Due to engine issues, we need to stop or bus at sicard rue. All students are safe. There will be 5 minutes to solve problem. We will solve it and we will move soon. Don't worry about your childrens.",notification_id:"17",school_id:"144",timestamp:Date()
 , title: "Issue in the bus engine"),
        
        ]
    }
