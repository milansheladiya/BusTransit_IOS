//
//  UserModel.swift
//  BusTransit_IOS
//
//  Created by Milan Sheladiya on 2022-07-09.
//

import Foundation

struct User{
    var user_id: String
    let bus_id: String
    let email_id: String
    var fullName: String
    var gender: String
    var phone_no: String
    var address: String
    var user_lat: String
    var user_long: String
    var photo_url: String
    let user_type: String
    var school_id: [String]
}

class UserList{
    static var UserListCollection:[User] = [
        User(user_id: "1", bus_id: "5055 roslyn", email_id: "abc", fullName: "bus@gmail.com", gender: "bus bus", phone_no: "Male", address: "514-879-9876", user_lat:"202.222", user_long:"202.22" , photo_url: "https:urs/", user_type: "Driver", school_id: [])
    
    ]
    
    
    static var GlobleUser:User = UserListCollection[0]
    
    static var schoolId:[String] = []
}


