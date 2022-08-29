//
//  UtilClass.swift
//  BusTransit_IOS
//
//  Created by Milan Sheladiya on 2022-07-08.
//

import Foundation
import UIKit
import Firebase
class UtilClass
{
    
    static func getUIColor(hex: String, alpha: Double = 1.0) -> UIColor? {
        var cleanString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cleanString.hasPrefix("#")) {
            cleanString.remove(at: cleanString.startIndex)
        }
        
        if ((cleanString.count) != 6) {
            return nil
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: cleanString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    static func getDate(date:Date) -> String{
        return date.toString(dateFormat: "dd-MM")
    }

    
    // return all list textfield that have in passed view
    static func getTextfield(view: UIView) -> [UITextField] {
        var results = [UITextField]()
        for subview in view.subviews as [UIView] {
            if let textField = subview as? UITextField {
                results += [textField]
            } else {
                results += getTextfield(view: subview)
            }
        }
        return results
    }
    
    // show simple alert view
    static func _Alert(_ uiView: UIViewController,_ title:String,_ msg:String)
    {
        let uialert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        uialert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        uiView.present(uialert, animated: true, completion: nil)
    }
    
    
    // show alert view with dismiss function
    static func _AlertWithDismiss(_ uiView: UIViewController,_ title:String,_ msg:String)
    {
        let uialert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        uialert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        uiView.present(uialert, animated: true, completion: {
            uiView.dismiss(animated: true, completion: nil)
        })
    }
    
    
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    static func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
        
        let passPred = NSPredicate(format:"SELF MATCHES %@", passwordRegex)
        return passPred.evaluate(with: password)
    }
    static func isValidNumber(_ phone: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result = phoneTest.evaluate(with: phone)
        return result
    }
    
    
    
    static func UserToFirebaseMap(obj: User) -> [String:Any]
    {
        let newUser = ["user_id":obj.user_id,
                       "bus_id":obj.bus_id,
                       "email_id":obj.email_id,
                       "fullName":obj.fullName,
                       "gender":obj.gender,
                       "phone_no":obj.phone_no,
                       "address":obj.address,
                       "user_lat":obj.user_lat,
                       "user_long":obj.user_long,
                       "photo_url":obj.photo_url,
                       "user_type":obj.user_type,
                       "school_id":obj.school_id
        ] as [String : Any]
        
        
        return newUser
    }
    static func FirebaseToUserMap(doc: QueryDocumentSnapshot) -> User{
        let user:User = User(
                    user_id: doc.data()["user_id"] as! String,
                    bus_id: doc.data()["bus_id"] as! String,
                    email_id: doc.data()["email_id"] as! String,
                    fullName: doc.data()["fullName"] as! String,
                    gender: doc.data()["gender"] as! String,
                    phone_no: doc.data()["phone_no"] as! String,
                    address: doc.data()["address"] as! String,
                    user_lat: doc.data()["user_lat"] as! String,
                    user_long: doc.data()["user_long"] as! String,
                    photo_url: doc.data()["photo_url"] as! String,
                    user_type: doc.data()["user_type"] as! String,
                    school_id: doc.data()["school_id"] as! [String]
                )
        return user
    }
    static func SchoolToFirebaseMap(obj: School) -> [String:Any]
    {
        let newUser = ["school_id":obj.school_id,
                       "address":obj.address,
                       "name":obj.name,
                       "email_id":obj.email_id,
                       "lat":obj.lat,
                       "long":obj.long,
                       "phone_no":obj.phone_no,
        ] as [String : Any]
        
        
        return newUser
    }
    static func BusToFirebaseMap(obj: Bus) -> [String:Any]
    {
        
        let newBus = [
                        "bus_id":obj.bus_id,
                       "bus_number":obj.bus_number,
                       "active_sharing":obj.active_sharing,
                       "school_id":obj.school_id,
                       "source":obj.source,
                       "source_lat":obj.source_lat,
                       "source_long":obj.source_long,
                       "destination":obj.destination,
                       "destination_lat":obj.destination_lat,
                       "destination_long":obj.destination_long,
                       "current_lat":obj.current_lat,
                       "current_long":obj.current_long,
                       "going_to_school":obj.going_to_school
        ] as [String : Any]
        
        
        return newBus
    }

}
