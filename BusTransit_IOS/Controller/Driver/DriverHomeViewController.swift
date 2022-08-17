//
//  DriverHomeViewController.swift
//  BusTransit_IOS
//
//  Created by Milan Sheladiya on 2022-08-16.
//

import UIKit
import MapKit
import CoreLocation

class DriverHomeViewController: UIViewController {
    
    let fb = FirebaseUtil()
    
    let locationManager = CLLocationManager()
    
    var CurrentLocation = CLLocationCoordinate2D()
    
    @IBOutlet weak var btnTripFromSchool: UIButton!
    @IBOutlet weak var btnTripToSchool: UIButton!
    @IBOutlet weak var btnTripStop: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        initSetup()
        checkPermission()
        locationSetup()
    }
    
    func initSetup()
    {
        btnTripStop.isEnabled = false
    }
    
    func locationSetup()
    {
        
        locationManager.delegate = self
        // Request a user’s location once
        locationManager.requestLocation()
    }
    
    func checkPermission(){
        // Get the current location permissions
        let status = CLLocationManager.authorizationStatus()

        // Handle each case of location permissions
        switch status {
        case .authorizedAlways:
            locationManager.requestAlwaysAuthorization()
            break
                // Handle case
        case .authorizedWhenInUse:
            locationManager.requestWhenInUseAuthorization()
            break
                // Handle case
        case .denied,.notDetermined,.restricted:
            print("denied / notDetermined / restricted")
            break
                // Handle case
        }
    }
    
    
    @IBAction func TripFromSchool(_ sender: UIButton)
    {
        btnTripToSchool.isEnabled = false
        btnTripFromSchool.isEnabled = false
        btnTripFromSchool.setTitleColor(.red, for: .normal)
        btnTripToSchool.setTitleColor(.black, for: .normal)
        btnTripStop.isEnabled = true
        FirebaseUtil._updateExistingFieldInDocumentWithId(_collection: "Bus", _docId: UserList.GlobleUser.bus_id, _data: ["active_sharing":true])
        
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func TripToSchool(_ sender: UIButton)
    {
        btnTripFromSchool.isEnabled = false
        btnTripToSchool.isEnabled = false
        btnTripFromSchool.setTitleColor(.black, for: .normal)
        btnTripToSchool.setTitleColor(.red, for: .normal)
        btnTripStop.isEnabled = true
        
        FirebaseUtil._updateExistingFieldInDocumentWithId(_collection: "Bus", _docId: UserList.GlobleUser.bus_id, _data: ["active_sharing":true,"going_to_school":true])
        
        locationManager.startUpdatingLocation()
        
    }
    
    @IBAction func TripStop(_ sender: UIButton)
    {
        btnTripToSchool.isEnabled = true
        btnTripFromSchool.isEnabled = true
        btnTripFromSchool.setTitleColor(.black, for: .normal)
        btnTripToSchool.setTitleColor(.black, for: .normal)
        btnTripStop.isEnabled = false
        
        FirebaseUtil._updateExistingFieldInDocumentWithId(_collection: "Bus", _docId: UserList.GlobleUser.bus_id, _data: ["active_sharing":false,"going_to_school":false])
        
        locationManager.stopUpdatingLocation()
        
    }
    
    @IBAction func pressedLogout(_ sender: UIButton) {
        FirebaseUtil.logout()
        self.dismiss(animated: true)
        
    }
    

}


extension DriverHomeViewController:CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
                let latitude = location.coordinate.latitude
                let longitude = location.coordinate.longitude
                // Handle location update
            CurrentLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            print("Location changed \(latitude) -- \(longitude)")
            
            FirebaseUtil._updateExistingFieldInDocumentWithId(_collection: "Bus", _docId: UserList.GlobleUser.bus_id, _data: ["current_lat" : latitude,"current_long":longitude])
            
            }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while fetching location!------")
        print(error.localizedDescription)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("---------------permission changed -------------")
    }
    
    
}
