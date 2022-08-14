//
//  Constants.swift
//  BusTransit_IOS
//
//  Created by Milan Sheladiya on 2022-07-09.
//

import Foundation
import MapKit

class Constants{
    
    static var RecentError : String = "";
    
    static var PlaceAPI : String = "AIzaSyAgpLONoQLPhvXWh05qs8cCBdmZS9NDolw";
    
    static let DRIVER = "DRIVER"
    static let PARENT = "PARENT"
    static let DEFAULT_SCHOOL_ID = "no_school_id"
    static let INVALID_EMAIL_MSG = "wrong email format!"
    static let INVALID_PHONE_NO = "wrong phone number format! (514-134-1128)"
    
    static let tmpSource = CLLocationCoordinate2D(latitude: 45.49383382980044, longitude: -73.57925496874121)
    static let tmpDestination = CLLocationCoordinate2D(latitude: 45.49383382980044, longitude: -73.57925496874121)
    
    static let SourceMaker:MKPlacemark = MKPlacemark(coordinate: tmpSource)
    static let DestinationMaker:MKPlacemark = MKPlacemark(coordinate: tmpDestination)
    
}

