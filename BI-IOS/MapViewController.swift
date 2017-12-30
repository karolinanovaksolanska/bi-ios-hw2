//
//  MapViewController.swift
//  BI-IOS
//
//  Created by Jan Misar on 14.11.17.
//  Copyright © 2017 ČVUT. All rights reserved.
//

import UIKit
import MapKit
import SnapKit
import CoreLocation
import MagicalRecord
import Firebase

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var dataManager = DataManager()
    var data = [AnyObject]()
    var ref: DatabaseReference!
    var pointAnnotation:CustomPointAnnotation!
    
    override func loadView() {
        super.loadView()
        
        ref = Database.database().reference()
        let mapView = MKMapView()
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.mapView = mapView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Weird foursquare"
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() // nice pod for requesting permissions - https://github.com/nickoneill/PermissionScope
        
        mapView.delegate = self
        
        mapView.removeAnnotations(mapView.annotations)
        
        let locations = self.data
        // let predicate = NSPredicate(format: "date > %@ AND title == 'ahoj'", Date()) // just example
        // let filteredLocations = FavoriteLocation.mr_findAllSorted(by: "title", ascending: true, with: predicate)
        
        locations.forEach { location in
            let annotation = MKPointAnnotation()
            if let lat = location["lat"] as? Double, let lon = location["lon"] as? Double{
                annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                mapView.addAnnotation(annotation)
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dataManager.getPins { [weak self] pins in
            self?.data = pins
            self?.locationManager = CLLocationManager()
            self?.locationManager.delegate = self
            self?.locationManager.requestWhenInUseAuthorization() // nice pod for requesting permissions - https://github.com/nickoneill/PermissionScope
            
            self?.mapView.delegate = self
            
            self?.mapView.removeAnnotations((self?.mapView.annotations)!)
            
            let locations = self?.data
            // let predicate = NSPredicate(format: "date > %@ AND title == 'ahoj'", Date()) // just example
            // let filteredLocations = FavoriteLocation.mr_findAllSorted(by: "title", ascending: true, with: predicate)
            
            for location in locations! {
                let annotation = CustomPointAnnotation()
                if let lat = location["lat"] as? Double, let lon = location["lon"] as? Double, let time = location["time"] as? Double, let username = location["username"] as? String, let gender = location["gender"] as? String {
                    if gender != "male" && gender != "female" && gender != "unknown" {
                        continue
                    }
                    let formatter = DateFormatter()
                    // initially set the format based on your datepicker date
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let myString = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(time / 1000)))
                    annotation.title = username
                    annotation.subtitle = myString
                    
                    annotation.gender = gender
                    annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                    self?.mapView.addAnnotation(annotation)
                }
            }
        }
    }
    
    let reuseIdentifier = "reuseIdentifier"
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
    
        let customPointAnnotation = annotation as! CustomPointAnnotation
        
        if customPointAnnotation.gender == "male" {
            annotationView.image = #imageLiteral(resourceName: "male")
        } else if customPointAnnotation.gender == "female" {
            annotationView.image = #imageLiteral(resourceName: "female")
        } else {
            annotationView.image = #imageLiteral(resourceName: "unknown")
        }
        annotationView.canShowCallout = true
        
        let button = UIButton(type: .detailDisclosure)
        annotationView.rightCalloutAccessoryView = button
        
        //annotationView.detailCalloutAccessoryView = UIImageView(image: #imageLiteral(resourceName: "pin"))
        
        annotationView.isDraggable = true // that's nonsense here of course 😏 - just for example
        
        return annotationView
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .follow
            
            locationManager.startUpdatingLocation() // we should also stop it somewhere!
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! // we are sure we have at least one location there
        print(location)
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            guard let placemark = placemarks?.last, let street = placemark.thoroughfare, let city = placemark.locality else {
                self?.navigationItem.title = "Address not found"
                return
            }
            
            self?.navigationItem.title = "\(city), \(street)"
        }
        
    }
    

//    let locations = [
//        ["lat": 50.10155117, "lon": 14.50131164],
//        ["lat": 50.04845155, "lon": 14.40643163],
//        ["lat": 50.01436603, "lon": 14.48202576],
//        ["lat": 50.09773545, "lon": 14.42862526],
//        ["lat": 50.02386574, "lon": 14.418157],
//        ["lat": 50.10891206, "lon": 14.50023615],
//        ["lat": 50.13137991, "lon": 14.43188124],
//        ["lat": 50.03085971, "lon": 14.43437316],
//        ["lat": 50.05523586, "lon": 14.36531867],
//        ["lat": 50.12467219, "lon": 14.39459484],
//        ["lat": 50.00616185, "lon": 14.41959398],
//        ["lat": 50.06693629, "lon": 14.43925259],
//        ["lat": 50.08936261, "lon": 14.53516745],
//        ["lat": 50.03396537, "lon": 14.48803967],
//        ["lat": 50.06252636, "lon": 14.49942098],
//        ["lat": 50.01692711, "lon": 14.37874073],
//        ["lat": 50.07238541, "lon": 14.37937722],
//        ["lat": 50.02807288, "lon": 14.51289626],
//        ["lat": 50.0276592, "lon": 14.48751812],
//        ["lat": 50.1340302, "lon": 14.45877785]
//    ]
    
}






