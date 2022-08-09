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
    
    // map area
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var CurrentLocation = CLLocationCoordinate2D()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setUp()
        
        CurrentLocation = CLLocationCoordinate2D(
            latitude: (busDetails!.current_lat as NSString).doubleValue,
            longitude: (busDetails!.current_long as NSString).doubleValue)
        
        
//        setMarker()
        
//        setMarkerOnCurrentLocation(LiveLocation: CLLocationCoordinate2D(latitude: 45.49383382980044, longitude: -73.57925496874121))
        
        mapView.delegate = self
        
    }
    
    
    func setMarkerOnCurrentLocation(LiveLocation: CLLocationCoordinate2D)
    {
        let myloc = Artwork(title: "School Bus", locationName: busDetails?.going_to_school ?? false ? "Going to School" : "Coming to School", coordinate: LiveLocation)
        
        mapView.addAnnotation(myloc)

        
        
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.centerCoordinate = CurrentLocation
        
        // set range to view
        mapView.setRegion(MKCoordinateRegion(center: mapView.centerCoordinate, latitudinalMeters: 300, longitudinalMeters: 300), animated: true)
        
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
            let resizedSize = CGSize(width: 50, height: 50)

            UIGraphicsBeginImageContext(resizedSize)
            image?.draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        
        //Set image
        switch annotation.title {
        case "chool Bus":
            annotationView?.image = UIImage(named: "bus")
            break
        case "Parking_":
            annotationView?.image = UIImage(named: "bus")
            break
        default:
            annotationView?.image = image
            break
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
         let renderer = MKPolylineRenderer(overlay: overlay)
         renderer.strokeColor = UIColor.red
         renderer.lineWidth = 5.0
         return renderer
    }
    
    
}
