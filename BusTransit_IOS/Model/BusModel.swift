//
//  BusModel.swift
//  BusTransit_IOS
//
//  Created by Dishant Desai on 2022-07-18.
//

import Foundation

struct Bus{
    var bus_id: String
    let bus_number: Int
    let active_sharing: Bool
    let current_lat: String
    var current_long: String
    var destination_lat: String
    var destination_long: String
    var destination: String
    var going_to_school: Bool
    var school_id: String
    var source_lat: String
    var source_long: String
    var source: String
}

class BusList{
    static var BusListCollection:[Bus] = []
    
    static var CurrentBus:Bus = Bus(bus_id: "", bus_number: 1, active_sharing: false, current_lat: "", current_long: "", destination_lat: "", destination_long: "", destination: "", going_to_school: false, school_id: "", source_lat: "", source_long: "", source: "")
    
    static func ObjectConvert(data: [String : Any])-> Bus
    {
        return Bus(bus_id: data["bus_id"] as? String ?? "bus_id",
                   bus_number: data["bus_number"] as? Int ?? 110,
                   active_sharing: data["active_sharing"] as? Bool ?? false,
                   current_lat: data["current_lat"] as? String ?? "",
                   current_long: data["current_long"] as? String ?? "",
                   destination_lat: data["destination_lat"] as? String ?? "",
                   destination_long: data["destination_long"] as? String ?? "",
                   destination: data["destination"] as? String ?? "",
                   going_to_school: data["going_to_school"] as? Bool ?? false,
                   school_id: data["school_id"] as? String ?? "",
                   source_lat: data["source_lat"] as? String ?? "",
                   source_long: data["source_long"] as? String ?? "",
                   source: data["source"] as? String ?? "")
    }
    
}
