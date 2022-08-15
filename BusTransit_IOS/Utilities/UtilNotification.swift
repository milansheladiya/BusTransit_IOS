//
//  UtilNotification.swift
//  BusTransit_IOS
//
//  Created by Milan Sheladiya on 2022-08-15.
//

import Foundation
import UserNotifications

class UtilNotification
{
    static let center = UNUserNotificationCenter.current()
    static let content = UNMutableNotificationContent()
    
    static func TriggerNewNotification(_title:String, _body:String)
    {
        
        content.title = _title
        content.body = _body
        content.sound = .default
        
        // next part is trigger
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request) { (error) in
            if error != nil
            {
                print("Notification Error : \(error?.localizedDescription ?? "-")")
            }
        }
        
    }
}
