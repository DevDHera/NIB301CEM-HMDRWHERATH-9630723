//
//  MapViewController.swift
//  HMDRWHERATH_9630723_COBSCCOMP191P-008
//
//  Created by user180410 on 9/18/20.
//  Copyright © 2020 Devin Herath. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class MapViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    let db = Firestore.firestore()
    
    var userDocRefId = ""
    
    var geoPoints: [GeoPoint] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Danger Areas"
        
        fetchUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationManager.stopUpdatingLocation()
            
            render(location)
            updateLocations(location)
        }
    }
    
    func render(_ location: CLLocation) {
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
    }
    
    func updateLocations(_ location: CLLocation) {
        if let uid = Auth.auth().currentUser?.uid {
            db.collection(Constants.UserStore.collectionName).whereField(Constants.UserStore.uidField, isEqualTo: uid).getDocuments { (querySnapshot, error) in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        self.userDocRefId = snapshotDocuments[0].documentID
                        
                        self.db.collection(Constants.UserStore.collectionName).document(self.userDocRefId).updateData([
                            Constants.UserStore.location: GeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                        ]) { error in
                            if let e = error {
                                print(e)
                                return
                            }
                        }
                    }
                }
            }
        }
    }
    
    func fetchUsers() {
        geoPoints = []
        db.collection(Constants.UserStore.collectionName).addSnapshotListener { (querySnapshot, error) in
            if let e = error {
                print(e.localizedDescription)
            } else {
                
                if let snapshotDocuemnts = querySnapshot?.documents {
                    for doc in snapshotDocuemnts {
                        let data = doc.data()
                        if let geopoint = data[Constants.UserStore.location] as? GeoPoint {
                            self.geoPoints.append(geopoint)
                        }
                    }
                    DispatchQueue.main.async {
                        for i in self.geoPoints{
                            if let latitude = i.value(forKey: "latitude"), let longitude = i.value(forKey: "longitude") {
                                let point = MKPointAnnotation()
//                                let annotationView = MKMarkerAnnotationView()
//                                annotationView.markerTintColor = .black
//                                let point = ColorPointAnnotation(pinColor: .black)
                                point.coordinate = CLLocationCoordinate2D(latitude: latitude as! CLLocationDegrees, longitude: longitude as! CLLocationDegrees)
                                self.mapView.addAnnotation(point)
                            }
  
                        }
                    }
                }
            }
        }
    }
    
    
}
