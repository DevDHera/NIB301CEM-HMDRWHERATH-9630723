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
import SCLAlertView

class MapViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    let db = Firestore.firestore()
    
    var userDocRefId = ""
    
    var geoPoints: [GeoPoint] = []
    var currentUserGeoPoint: GeoPoint?
    
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
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
        currentUserGeoPoint = GeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
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
            var infected = false
            
            if let e = error {
                print(e.localizedDescription)
            } else {
                
                if let snapshotDocuemnts = querySnapshot?.documents {
                    
                    for doc in snapshotDocuemnts {
                        let data = doc.data()
                        if let geopoint = data[Constants.UserStore.location] as? GeoPoint {
                            self.geoPoints.append(geopoint)
                            
                            if self.currentUserGeoPoint != nil, let covidStatus = data[Constants.UserStore.covidStatus] as? String {
                                if self.getRange(distance: 1.0, point: geopoint), covidStatus == UserCovidStatus.INFECTED.rawValue {
                                    infected = true
                                }
                            }
                            
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
                        
                        if infected {
                            SCLAlertView().showInfo("Danger", subTitle: "You are in a COVID 19 suspected location")
                        }
                    }
                }
            }
        }
    }
    
    func getRange(distance: Double, point: GeoPoint) -> Bool {
//        ~1 mile of lat and lon in degrees
        let lat = 0.0144927536231884
        let lon = 0.0181818181818182
        
        let lowerLat = currentUserGeoPoint!.latitude - (lat * distance)
        let lowerLon = currentUserGeoPoint!.longitude - (lon * distance)

        let greaterLat = currentUserGeoPoint!.latitude + (lat * distance)
        let greaterLon = currentUserGeoPoint!.longitude + (lon * distance)
        
        if point.latitude > lowerLat, point.latitude < greaterLat, point.longitude > lowerLon, point.longitude < greaterLon {
            return true
        }
        
        return false
    }
}
