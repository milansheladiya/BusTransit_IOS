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
    @IBOutlet weak var navigationBarTitle: UINavigationItem!
    
    @IBOutlet weak var txtTitle: UILabel!
    
    
    var sourcePlacemark:MKPlacemark = Constants.SourceMaker
    var destinationPlacemark:MKPlacemark = Constants.DestinationMaker
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        initSetup()
        getBusDetails()
        mapView.delegate = self
        navigationBarTitle.title = UserList.GlobleUser.fullName
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
    
    func getBusDetails()
    {
        fb._readSingleDocument(_collection: "Bus", _document: UserList.GlobleUser.bus_id) { docs in
            guard let data = docs.data() else {
              print("Document data was empty.")
              return
            }
            BusList.CurrentBus = BusList.ObjectConvert(data: data)
            self.checkPermission()
            self.locationSetup()
            
            
            if !(BusList.CurrentBus.active_sharing)
            {
                
            }
            
            //set marker
            self.CurrentLocation = CLLocationCoordinate2D(
                latitude: (BusList.CurrentBus.source_lat as NSString).doubleValue,
                longitude: (BusList.CurrentBus.source_long as NSString).doubleValue)
            
            self.setMarkerLocation(LiveLocation: self.CurrentLocation, Title: "School", Subtitle: BusList.CurrentBus.source )

            
            self.CurrentLocation = CLLocationCoordinate2D(
                latitude: (BusList.CurrentBus.destination_lat as NSString).doubleValue,
                longitude: (BusList.CurrentBus.destination_long as NSString).doubleValue)
            self.setMarkerLocation(LiveLocation: self.CurrentLocation, Title: "Destination", Subtitle: BusList.CurrentBus.destination )
//            print("-----------------------------------------------------")
//            print(BusList.CurrentBus.current_lat)
//            print(BusList.CurrentBus.current_long)
//            print("-----------------------------------------------------")
            self.CurrentLocation = CLLocationCoordinate2D(latitude: (BusList.CurrentBus.source_lat as NSString).doubleValue, longitude: (BusList.CurrentBus.source_long as NSString).doubleValue)
            
            self.setMarkerOnCurrentLocation(LiveLocation: self.CurrentLocation)
            
        }
    }
    
    
    @IBAction func TripFromSchool(_ sender: UIButton)
    {
        btnTripToSchool.isEnabled = false
        btnTripFromSchool.isEnabled = false
        btnTripFromSchool.setTitleColor(.red, for: .normal)
        btnTripToSchool.setTitleColor(.black, for: .normal)
        btnTripStop.isEnabled = true
        FirebaseUtil._updateExistingFieldInDocumentWithId(_collection: "Bus", _docId: UserList.GlobleUser.bus_id, _data: ["active_sharing":true,"going_to_school":false])
        
        self.destinationPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(
            latitude: (BusList.CurrentBus.destination_lat as NSString).doubleValue,
            longitude: (BusList.CurrentBus.destination_long as NSString).doubleValue))
        self.txtTitle.text = "Your are on trip to Home"
        
        setDirectionLine()
        
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
        
        self.destinationPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(
            latitude: (BusList.CurrentBus.source_lat as NSString).doubleValue,
            longitude: (BusList.CurrentBus.source_long as NSString).doubleValue))
        self.txtTitle.text = "Your are on trip to School"
        
        setDirectionLine()
        
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
        
        self.txtTitle.text = "Your Trip is offline!"
        
        self.mapView.removeOverlays(self.mapView.overlays)
        
        locationManager.stopUpdatingLocation()
        
    }
    
    @IBAction func pressedLogout(_ sender: UIButton) {
        FirebaseUtil.logout()
        self.dismiss(animated: true)
        
    }
    
    
    func setMarkerLocation(LiveLocation: CLLocationCoordinate2D,Title:String,Subtitle:String)
    {
        let artwork = Artwork(
          title: Title,
          locationName: Subtitle,
          coordinate: LiveLocation)
        mapView.addAnnotation(artwork)
        
        if BusList.CurrentBus.going_to_school && Title == "School"
        {
           destinationPlacemark = MKPlacemark(coordinate: LiveLocation)
        }
        else if !(BusList.CurrentBus.going_to_school) && Title == "Destination"
        {
            destinationPlacemark = MKPlacemark(coordinate: LiveLocation)
        }
        
    }
    
    
    func setMarkerOnCurrentLocation(LiveLocation: CLLocationCoordinate2D)
    {
        sourcePlacemark = MKPlacemark(coordinate: LiveLocation)
        
        let artwork = Artwork(
          title: "School Bus",
          locationName: BusList.CurrentBus.going_to_school ? "Going to School" : "Coming to School",
          coordinate: LiveLocation)
        mapView.addAnnotation(artwork)
        
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.centerCoordinate = CurrentLocation
        
        // set range to view
        mapView.setRegion(MKCoordinateRegion(center: mapView.centerCoordinate, latitudinalMeters: 4000, longitudinalMeters: 4000), animated: true)
        
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 20000) // 999 is best
        mapView.setCameraZoomRange(zoomRange, animated: true)
        
    }
    
    
    func setDirectionLine()
    {
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)

        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
//        directionRequest.requestsAlternateRoutes = true
        directionRequest.transportType = .automobile
       
        let directions = MKDirections(request: directionRequest)
       
        directions.calculate {
            (response, error) -> Void in
           
            guard let response = response else {
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
               
                return
            }
            
        
            self.mapView.removeOverlays(self.mapView.overlays)
            
            var route = response.routes[0]
            for tmpRoute in response.routes
            {
                if tmpRoute.distance < route.distance
                {
                    route = tmpRoute
                }
                    
            }
            
           
            self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
           
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            

//            print("-------Advisory notice---------")
//            print(route.advisoryNotices)
            
            
        }
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
            
            FirebaseUtil._updateExistingFieldInDocumentWithId(_collection: "Bus", _docId: UserList.GlobleUser.bus_id, _data: ["current_lat" : String(latitude) ,"current_long":String(longitude)])
            
            
            self.CurrentLocation = CLLocationCoordinate2D(latitude: latitude , longitude: longitude)
            
            self.setMarkerOnCurrentLocation(LiveLocation: self.CurrentLocation)
            
            print("Current data: \(latitude) \(longitude)")
            
            self.setDirectionLine()
            
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


extension DriverHomeViewController : MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
        
        if annotationView == nil {
            //Create View
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
        } else {
            //Assign annotation
            annotationView?.annotation = annotation
        }
        
 print("-------------==")
        
        let image = UIImage(named: "bus")
            let resizedSize = CGSize(width: 35, height: 35)

            UIGraphicsBeginImageContext(resizedSize)
            image?.draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
           UIGraphicsEndImageContext()
        
        //Set image
        switch annotation.title {
        case "School Bus":
            annotationView?.image = UIImage(named: "bus")
            break
        case "Destination":
            annotationView?.image = UIImage(named: "Home")
            break
        case "School":
            annotationView?.image = UIImage(named: "School")
            break
        default:
            annotationView?.image = UIImage(named: "Destination_")
            break
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
         let renderer = MKPolylineRenderer(overlay: overlay)
         renderer.strokeColor = UIColor.blue
         renderer.lineWidth = 5.0
         return renderer
    }
    
}
