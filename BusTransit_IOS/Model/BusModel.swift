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
}
