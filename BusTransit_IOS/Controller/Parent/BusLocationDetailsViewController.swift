//
//  BusLocationDetailsViewController.swift
//  BusTransit_IOS
//
//  Created by Dishant Desai on 2022-08-08.
//

import UIKit
import MapKit

class BusLocationDetailsViewController: UIViewController {
    var busDetails:BusToDriverModel?
    @IBOutlet weak var driverName: UILabel!
    @IBOutlet weak var EstimatedTime: UILabel!
    @IBOutlet weak var RemainingDistance: UILabel!
    @IBOutlet weak var RouteName: UILabel!
    
    @IBOutlet weak var titleInfo: UILabel!
    
    
    // map area
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var CurrentLocation = CLLocationCoordinate2D()
    
    //Artwork marker
    
    
    var sourcePlacemark:MKPlacemark = Constants.SourceMaker
    var destinationPlacemark:MKPlacemark = Constants.DestinationMaker
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setUp()
        
        CurrentLocation = CLLocationCoordinate2D(
            latitude: (busDetails!.source_lat as NSString).doubleValue,
            longitude: (busDetails!.source_long as NSString).doubleValue)
        
        setMarkerLocation(LiveLocation: CurrentLocation, Title: "School", Subtitle: busDetails?.source ?? "Null")
        
       
        
        
        CurrentLocation = CLLocationCoordinate2D(
            latitude: (busDetails!.destination_lat as NSString).doubleValue,
            longitude: (busDetails!.destination_long as NSString).doubleValue)
        setMarkerLocation(LiveLocation: CurrentLocation, Title: "Destination", Subtitle: busDetails?.source ?? "Null")
        
        getLiveData()
        
//        setMarker()
//        setMarkerOnCurrentLocation(LiveLocation: CLLocationCoordinate2D(latitude: 45.49383382980044, longitude: -73.57925496874121))
        mapView.delegate = self
        
    }
    
    
    func getLiveData(){
        FirebaseUtil._db.collection("Bus").document(busDetails!.bus_id)
            .addSnapshotListener { documentSnapshot, error in
              guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
              }
              guard let data = document.data() else {
                print("Document data was empty.")
                return
              }
            
                let tmpBus = BusList.ObjectConvert(data: data)
                self.busDetails?.going_to_school = tmpBus.going_to_school
                self.busDetails?.active_sharing = tmpBus.active_sharing
                
                if !(tmpBus.active_sharing)
                {
                    self.mapView.removeOverlays(self.mapView.overlays)
                    self.titleInfo.text = "Driver is Offline"
                    self.EstimatedTime.text = "- Minutes"
                    self.RemainingDistance.text = "- Km"
                    self.RouteName.text = "---"
                    return
                }
                
                if tmpBus.going_to_school {
                    self.destinationPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(
                        latitude: (tmpBus.source_lat as NSString).doubleValue,
                        longitude: (tmpBus.source_long as NSString).doubleValue))
                    self.titleInfo.text = "Your kid is going to school"
                }
                else
                {
                    self.destinationPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(
                        latitude: (tmpBus.destination_lat as NSString).doubleValue,
                        longitude: (tmpBus.destination_long as NSString).doubleValue))
                    self.titleInfo.text = "Your kid is Coming to school"
                }
                
                if let newLat = data["current_lat"] as? String,
                let newLong = data["current_long"] as? String
                {
                    self.CurrentLocation = CLLocationCoordinate2D(latitude: (newLat as NSString).doubleValue, longitude: (newLong as NSString).doubleValue)
                    
                    self.setMarkerOnCurrentLocation(LiveLocation: self.CurrentLocation)
                    
                    print("Current data: \(newLat) \(newLong)")
                    
                    self.setDirectionLine()
                }
                else
                {
                    print("preoblem ---------")
                }
                
                
            }
        
    }
    
    
    func setMarkerOnCurrentLocation(LiveLocation: CLLocationCoordinate2D)
    {
        sourcePlacemark = MKPlacemark(coordinate: LiveLocation)
        
        let artwork = Artwork(
          title: "School Bus",
          locationName: busDetails?.going_to_school ?? false ? "Going to School" : "Coming to School",
          coordinate: LiveLocation)
        mapView.addAnnotation(artwork)
        
//        let myloc = Artwork(title: "School Bus", locationName: busDetails?.going_to_school ?? false ? "Going to School" : "Coming to School", coordinate: LiveLocation)
//
//        mapView.addAnnotation(myloc)

        
        
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.centerCoordinate = CurrentLocation
        
        // set range to view
        mapView.setRegion(MKCoordinateRegion(center: mapView.centerCoordinate, latitudinalMeters: 4000, longitudinalMeters: 4000), animated: true)
        
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 20000) // 999 is best
        mapView.setCameraZoomRange(zoomRange, animated: true)
        
    }
    
    func setMarkerLocation(LiveLocation: CLLocationCoordinate2D,Title:String,Subtitle:String)
    {
        let artwork = Artwork(
          title: Title,
          locationName: Subtitle,
          coordinate: LiveLocation)
        mapView.addAnnotation(artwork)
        
       if busDetails!.going_to_school && Title == "School"
        {
           destinationPlacemark = MKPlacemark(coordinate: LiveLocation)
        }
        else if !(busDetails!.going_to_school) && Title == "Destination"
        {
            destinationPlacemark = MKPlacemark(coordinate: LiveLocation)
        }
        
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
                    print("Error: \(error)")
                }
               
                return
            }
            
        
            self.mapView.removeOverlays(self.mapView.overlays)
            
            let route = response.routes[0]
            self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
           
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            
            self.EstimatedTime.text = String(format: "%.2f Minute", (route.expectedTravelTime/60))
            self.RemainingDistance.text = String(format: "%.2f Km", (route.distance/1000))
            self.RouteName.text = route.name

//            print("-------Advisory notice---------")
//            print(route.advisoryNotices)
            
            
        }
    }
    
    func setMarker()
    {

        if let Source_Lat = busDetails?.source_lat as? String,
        let Source_Long = busDetails?.source_long as? String
        {
            var SourceLocation = CLLocationCoordinate2D(latitude: (Source_Lat as NSString).doubleValue, longitude: (Source_Long as NSString).doubleValue)
            
            let mySchool = Artwork(title: "school", locationName: busDetails?.source, coordinate: SourceLocation)

            mapView.addAnnotation(mySchool)
        }
        else
        {
            print("problem in marker source ----")
        }
                  
        
      if let Destination_Lat = busDetails?.destination_lat as? String,
      let Destination_Long = busDetails?.destination_long as? String
      {
          var DestinationLocation = CLLocationCoordinate2D(latitude: (Destination_Lat as NSString).doubleValue, longitude: (Destination_Long as NSString).doubleValue)
          
          let myDestination = Artwork(title: "Parking", locationName: busDetails?.destination, coordinate: DestinationLocation)

          mapView.addAnnotation(myDestination)
      }
      else
      {
          print("problem in marker Destiantion ----")
      }
        
        

        
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDriverProfile"{
            let destinationVC = segue.destination as! DriverProfileViewController
            destinationVC.busDetails = busDetails
        }
    }
    
    @IBAction func driverProfileHandler(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToDriverProfile",sender: self)
    }
    
    @IBAction func backHandler(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    func setUp(){
        driverName.text = busDetails?.fullName
    }
}



extension BusLocationDetailsViewController : MKMapViewDelegate
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
