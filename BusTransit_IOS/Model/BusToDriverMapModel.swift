//
//  BusToDriverMapModel.swift
//  BusTransit_IOS
//
//  Created by Dishant Desai on 2022-08-07.
//

import Foundation
struct BusToDriverModel {
    var bus_id: String
    let bus_number: Int
    var active_sharing: Bool
    var current_lat: String
    var current_long: String
    var destination_lat: String
    var destination_long: String
    var destination: String
    var going_to_school: Bool
    var school_id: String
    var source_lat: String
    var source_long: String
    var source: String
    
    var user_id: String
    let email_id: String
    let fullName: String
    let phone_no: String
    let photo_url: String
    let gender: String
    let address: String
    let school_id_list: [String]

}
class ParentBusList{
    static var BusListCollection:[BusToDriverModel] = []
}
