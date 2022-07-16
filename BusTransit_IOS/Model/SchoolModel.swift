//
//  SchoolModel.swift
//  BusTransit_IOS
//
//  Created by Dishant Desai on 2022-07-16.
//

import Foundation
struct School{
    var school_id: String
    let address: String
    let email_id: String
    let name: String
    var phone_no: String
    var lat: String
    var long: String
}

class SchoolList{
    static var SchoolListCollection:[School] = [
        School(school_id: "1", address: "Montreal", email_id: "abc", name: "Concordia", phone_no: "423-233-2333", lat: "202.222", long:"202.22"),
        School(school_id: "1", address: "Montreal", email_id: "abc", name: "Concordia", phone_no: "423-233-2333", lat: "202.222", long:"202.22"),
        School(school_id: "1", address: "Montreal", email_id: "abc", name: "Concordia", phone_no: "423-233-2333", lat: "202.222", long:"202.22"),
        School(school_id: "1", address: "Montreal", email_id: "abc", name: "Concordia", phone_no: "423-233-2333", lat: "202.222", long:"202.22"),
        School(school_id: "1", address: "Montreal", email_id: "abc", name: "Concordia", phone_no: "423-233-2333", lat: "202.222", long:"202.22"),
        School(school_id: "1", address: "Montreal", email_id: "abc", name: "Concordia", phone_no: "423-233-2333", lat: "202.222", long:"202.22"),
        School(school_id: "1", address: "Montreal", email_id: "abc", name: "Concordia", phone_no: "423-233-2333", lat: "202.222", long:"202.22"),
        School(school_id: "1", address: "Montreal", email_id: "abc", name: "Concordia", phone_no: "423-233-2333", lat: "202.222", long:"202.22"),
        School(school_id: "1", address: "Montreal", email_id: "abc", name: "Concordia", phone_no: "423-233-2333", lat: "202.222", long:"202.22"),
        School(school_id: "1", address: "Montreal", email_id: "abc", name: "Concordia", phone_no: "423-233-2333", lat: "202.222", long:"202.22")
    
    ]
}


